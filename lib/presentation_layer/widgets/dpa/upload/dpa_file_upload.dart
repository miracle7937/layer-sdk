import 'dart:typed_data';

import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:open_file/open_file.dart';

import '../../../../domain_layer/models.dart';
import '../../../cubits.dart';
import '../../../extensions.dart';
import '../../../mixins.dart';
import '../../../utils.dart';

/// The file upload widget for the DPA flows.
///
/// It uses either the `image_picker` or the `file_picker` package - the former
/// is used when the property `allowedTypes` is empty or all of its entries
/// match image types, the latter is used otherwise.
///
/// This requires two translations to work properly:
/// - 'upload': "Upload"
/// - `add_document`:	"Add {document}"
class DPAFileUpload extends StatefulWidget {
  /// The DPA variable that controls this widget.
  final DPAVariable variable;

  /// If the values can be changed.
  final bool readonly;

  /// The maximum size for the image.
  ///
  /// Defaults to `Size(640.0, 800.0)`.
  final Size maxSize;

  /// The widget padding.
  ///
  /// Defaults to `EdgeInsets.zero`.
  final EdgeInsets padding;

  /// If the upload widget should use the "Add {document}" text when expecting
  /// to upload a file.
  /// Defaults to `true`.
  final bool shouldAppendAdd;

  /// Optional param to be called when the app goes to background.
  /// This is useful when the application using this widget has an Auto lock
  /// mechanism.
  final VoidCallback? onPauseAutoLock;

  /// Optional param to be called when the app comes from the background.
  /// This is useful when the application using this widget has an Auto lock
  /// mechanism.
  final VoidCallback? onInitializeAutoLock;

  /// Custom label for the `Take a photo` button.
  final String? customTakePhotoLabel;

  /// Whether or not this widget is allowed to pick images from gallery.
  /// This setting only works when the allowed types are images only.
  /// When this setting is `false` and the allowed types are images only, the
  /// camera will be used.
  ///
  /// Defaults to `true`.
  final bool allowPickingImageFromGallery;

  /// Optional Error callback for file picking errors.
  final ValueChanged<String>? onFilePickError;

  /// The translation key for the empty upload state.
  final String? emptyStateMessageKey;

  /// Creates a new [DPAFileUpload].
  const DPAFileUpload({
    Key? key,
    required this.variable,
    required this.readonly,
    this.maxSize = const Size(640.0, 800.0),
    this.padding = EdgeInsets.zero,
    this.shouldAppendAdd = true,
    this.onInitializeAutoLock,
    this.onPauseAutoLock,
    this.customTakePhotoLabel,
    this.allowPickingImageFromGallery = true,
    this.onFilePickError,
    this.emptyStateMessageKey,
  }) : super(key: key);

  @override
  State<DPAFileUpload> createState() => _DPAFileUploadState();
}

class _DPAFileUploadState extends State<DPAFileUpload> with FilePickerMixin {
  final _logger = Logger('DPAFileUpload');

  /// This field holds the file name while it's being uploaded only.
  ///
  /// After the file is uploaded the file name will be read from the dpa
  /// variable value.
  String? _fileName;

  String get _description =>
      widget.variable.property.description ??
      widget.variable.property.allowedTypes.join(', ');

  String? get fileName => _fileName;
  set fileName(String? value) => setState(() => _fileName = value);

  /// Holds any error that ocurred internally in the widget and that
  /// are not related to the dpa flow.
  String? _error;
  String? get error => _error;
  set error(String? error) => setState(() => _error = error);

  @override
  Widget build(BuildContext context) {
    final translation = Translation.of(context);

    final data = context.select<DPAProcessCubit, DPAProcessingFileData?>(
      (cubit) => cubit.state.processingFileDataFromKey(widget.variable.key),
    );

    final fileData = widget.variable.value as DPAFileData?;
    final fileExtra = widget.variable.extraInformation;

    final status = data != null
        ? DKUploadStatus.uploading
        : fileData != null
            ? DKUploadStatus.uploaded
            : DKUploadStatus.idle;

    final effectiveAppendAdd = widget.shouldAppendAdd &&
        status == DKUploadStatus.idle &&
        widget.variable.label != null;

    final title = (widget.variable.value as DPAFileData?)?.name ??
        data?.fileName ??
        (effectiveAppendAdd
            ? translation.translate('add_document').replaceFirst(
                  '{document}',
                  widget.variable.label!.toLowerCase(),
                )
            : widget.variable.label) ??
        translation.translate('upload');

    return Padding(
      padding: widget.padding,
      child: Column(
        children: [
          DKUpload(
            status: status,
            title: title,
            useTitleWherePossible: true,
            description: _description.replaceAll(r'\n', '\n'),
            onPick: status != DKUploadStatus.idle ? null : _pickFile,
            onDelete: widget.readonly
                ? null
                : (_) => context.read<DPAProcessCubit>().deleteFile(
                      variable: widget.variable,
                    ),
            progress: data != null && data.total > 0
                ? (data.count / data.total) * 100
                : null,
            filename:
                fileExtra.isNotEmpty ? fileExtra : fileData?.name ?? fileName,
            fileExtra: (fileData?.size ?? 0) > 0
                ? FileUtils.formatBytes(
                    bytes: fileData!.size,
                  )
                : null,
            error: (status == DKUploadStatus.idle
                    ? error ??
                        widget.variable.translateValidationError(
                          translation,
                          uploadValidationKey: widget.emptyStateMessageKey,
                        )
                    : null) ??
                '',
            onDownload:
                widget.variable.constraints.readonly ? _downloadFile : null,
          ),
        ],
      ),
    );
  }

  /// Opens a bottom sheet and shows the options for picking a file. If picked,
  /// starts uploading the file using the [DPAProcessCubit].
  Future<void> _pickFile() async {
    error = null;
    widget.onPauseAutoLock?.call();

    final pickedFile = kIsWeb
        ? await pickFile(
            context,
            widget.allowPickingImageFromGallery
                ? FilePickerSource.galleryImage
                : FilePickerSource.cameraImage,
          )
        : await startPickFileFlow(
            context,
            title: Translation.of(context).translate('uploading_options'),
            allowedExtensions: widget.variable.property.allowedTypes.toSet(),
          );

    widget.onInitializeAutoLock?.call();

    if (pickedFile == null) return;

    /// TOD0: Check with Grzeg how to handle the error form automation, cause
    /// right now it's not being handled on the repository. Should we?
    ///
    /// The mime type is not being handled when the document is custom (file).
    final extension = pickedFile.mimeType?.split('/').last ??
        pickedFile.file.path.split('.').last;
    final allowedTypes = widget.variable.property.allowedTypes.join(', ');
    if (!allowedTypes.contains(extension)) {
      final errorMessage = Translation.translateOf(
        context,
        'unsupported_document_type',
      );

      if (widget.onFilePickError != null) {
        widget.onFilePickError!.call(errorMessage);
      } else {
        error = errorMessage;
      }

      return;
    }

    final fileData = await Future.wait([
      pickedFile.file.length(),
      pickedFile.file.readAsBytes(),
    ]);

    fileName = pickedFile.file.path.split('/').last;

    await context.read<DPAProcessCubit>().uploadImage(
          variable: widget.variable,
          filename: fileName!,
          fileSizeBytes: fileData[0] as int,
          fileBase64Data: CodecUtils().encodeBase64Image(
            fileData[1] as Uint8List,
          ),
        );

    fileName = null;
  }

  /// This method has been commented out since we're unable to decode
  /// the base64 image after it has been resized.
  /// Returns data of an image resized according to [widget.maxSize].
  ///
  /// Returns null if decoding of the image data fails.
  // Future<Uint8List?> _resizeImage(Uint8List data) async {
  //   try {
  //     final image = await decodeImage(data);

  //     if (image == null) return null;

  //     return copyResize(
  //       image,
  //       width: widget.maxSize.width.toInt(),
  //       height: widget.maxSize.height.toInt(),
  //     ).getBytes();
  //   } on Exception catch (e, s) {
  //     _logger.severe('Failed to resize the image', e, s);

  //     return null;
  //   }
  // }

  /// Downloads a file from the server
  Future<void> _downloadFile(
    String path,
  ) async {
    final result = await context.read<DPAProcessCubit>().downloadFile(
          variable: widget.variable,
        );

    if (result == null) {
      _logger.severe('Failed to download file');
      return;
    }

    final bytes = CodecUtils().decodeBase64(
      result.split(',').last,
    );

    final fileExtension = widget.variable.extraInformation.split('.').last;
    final key = widget.variable.key;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filename = '$key-$timestamp.$fileExtension';

    final path = await FileUtils().saveBytes(
      filename: filename,
      bytes: bytes,
    );

    if (!kIsWeb) {
      OpenFile.open(path);
    }
  }
}
