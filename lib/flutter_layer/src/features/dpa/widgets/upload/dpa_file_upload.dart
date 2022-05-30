import 'dart:typed_data';

import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:logging/logging.dart';
import 'package:open_file/open_file.dart';

import '../../../../../../business_layer/business_layer.dart';
import '../../../../../../data_layer/data_layer.dart';

import '../../../../extensions.dart';
import '../../../../resources.dart';
import '../../../../utils.dart';

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

class _DPAFileUploadState extends State<DPAFileUpload> {
  /// The types used to decide whether it's safe to use the `image_picker` or if
  /// it's needed to use the `file_picker`.
  static const _imageTypes = ['jpg', 'jpeg', 'png'];

  final _logger = Logger('DPAFileUpload');

  /// This field holds the file name while it's being uploaded only.
  ///
  /// After the file is uploaded the file name will be read from the dpa
  /// variable value.
  String? _fileName;

  bool get _useImagePicker =>
      widget.variable.property.allowedTypes.isEmpty ||
      widget.variable.property.allowedTypes
          .every((type) => _imageTypes.contains(type));

  String get _description => widget.variable.property.allowedTypes.join(', ');

  String? get fileName => _fileName;
  set fileName(String? value) => setState(() => _fileName = value);

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

    // Only show the take a photo button if:
    // - Only handling image types
    // - Picker is idle
    // - Not on the web
    // - Picking from the gallery is allowed
    final showTakePhotoButton = _useImagePicker &&
        status == DKUploadStatus.idle &&
        !kIsWeb &&
        widget.allowPickingImageFromGallery;

    return Padding(
      padding: widget.padding,
      child: Column(
        children: [
          DKUpload(
            status: status,
            title: (effectiveAppendAdd
                    ? translation.translate('add_document').replaceFirst(
                          '{document}',
                          widget.variable.label!.toLowerCase(),
                        )
                    : widget.variable.label?.capitalize) ??
                translation.translate('upload'),
            useTitleWherePossible: true,
            description: _description,
            onPick: status != DKUploadStatus.idle
                ? null
                : _useImagePicker
                    ? () => _uploadImage(
                          source: widget.allowPickingImageFromGallery
                              ? ImageSource.gallery
                              : ImageSource.camera,
                        )
                    : _uploadFile,
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
                    ? widget.variable.translateValidationError(
                        translation,
                        uploadValidationKey: widget.emptyStateMessageKey,
                      )
                    : null) ??
                '',
            onDownload:
                widget.variable.constraints.readonly ? _downloadFile : null,
          ),
          if (showTakePhotoButton)
            DKButton(
              iconPath: FLImages.camera,
              title: widget.customTakePhotoLabel ??
                  translation.translate(
                    'take_a_photo',
                  ),
              type: DKButtonType.baseTertiary,
              onPressed: () => _uploadImage(
                source: ImageSource.camera,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _uploadImage({
    ImageSource source = ImageSource.gallery,
  }) async {
    widget.onPauseAutoLock?.call();

    final file = await ImagePicker().pickImage(
      source: source,
      maxWidth: widget.maxSize.width,
      maxHeight: widget.maxSize.height,
    );

    widget.onInitializeAutoLock?.call();

    if (file == null) return;
    final extension =
        file.mimeType?.split('/').last ?? file.name.split('.').last;
    final allowedTypes = widget.variable.property.allowedTypes.join(', ');

    if (!widget.variable.property.allowedTypes.contains(extension)) {
      widget.onFilePickError?.call(
        Translation.translateOf(context, 'unsupported_document_type')
            .replaceAll('{extensions}', allowedTypes),
      );
      return;
    }

    final fileData = await Future.wait([
      file.length(),
      file.readAsBytes(),
    ]);

    fileName = file.name;

    await context.read<DPAProcessCubit>().uploadImage(
          variable: widget.variable,
          filename: file.name,
          fileSizeBytes: fileData[0] as int,
          fileBase64Data: CodecUtils().encodeBase64Image(
            fileData[1] as Uint8List,
          ),
        );

    fileName = null;
  }

  Future<void> _uploadFile() async {
    widget.onPauseAutoLock?.call();

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: widget.variable.property.allowedTypes.toList(),
      withData: true,
    );

    widget.onInitializeAutoLock?.call();

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final allowedTypes = widget.variable.property.allowedTypes.join(', ');

    if (!widget.variable.property.allowedTypes.contains(file.extension)) {
      widget.onFilePickError?.call(
        Translation.translateOf(context, 'unsupported_document_type')
            .replaceAll('{extensions}', allowedTypes),
      );
      return;
    }

    // Force unwrapping is safe because we are picking `withData` above.
    var data = file.bytes!;
    final fileSize = file.size;

    fileName = file.name;

    await context.read<DPAProcessCubit>().uploadImage(
          variable: widget.variable,
          filename: file.name,
          fileSizeBytes: fileSize,
          fileBase64Data: file.extension == 'pdf'
              ? CodecUtils().encodeBase64PDF(data)
              : CodecUtils().encodeBase64Image(
                  data,
                  format: file.extension ?? 'jpeg',
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
