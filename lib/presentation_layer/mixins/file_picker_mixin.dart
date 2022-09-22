import 'dart:io';

import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../utils.dart';
import '../widgets.dart';

/// A mixin that exposes methods for picking files.
mixin FilePickerMixin {
  /// Opens a bottom sheet that shows the available options for picking
  /// files and returns a file if picked.
  ///
  /// If the [title] parameter is indicated, the bottom sheet will
  /// show a title text on top.
  ///
  /// Use the [allowedExtensions] value for indicating the allowed extensions.
  /// This parameter is mapped into a [FilePickerSource] set, for showing the
  /// picker options on the bottom sheet.
  ///
  /// The [maxWidth], [maxHeight], and [imageQuality] values indicates the
  /// related properties for the camera picked files.
  /// By default, the [maxWidth] value will be `640.0`, the [maxHeight] `800.0`
  /// and the [imageQuality] will be `100`.
  ///
  /// If you wish the user to be able to crop an image after it has been picked,
  /// you can pass the [showImageCropper] as `true`.
  /// By deafult this parameter is `false`.
  ///
  /// The [maxCropSize] is used for determine the max size for the cropped
  /// image.
  /// By default will be `640`.
  Future<PickedFile?> startPickFileFlow(
    BuildContext context, {
    String? title,
    Set<String> allowedExtensions = const {},
    double maxWidth = 640.0,
    double maxHeight = 800.0,
    int imageQuality = 100,
    bool showImageCropper = false,
    int maxCropSize = 640,
  }) async {
    PickedFile? pickedFile;

    var allowedSources = _getAllowedSourcesFromExtensions(
      allowedExtensions,
    );

    if (allowedSources.contains(FilePickerSource.galleryImage)) {
      allowedSources = {
        FilePickerSource.cameraImage,
        ...allowedSources,
      };
    }

    final source = await _showFilePickerOptionsBottomSheet(
      context,
      title: title,
      allowedSources: allowedSources,
    );

    if (source != null) {
      pickedFile = await pickFile(
        source,
        allowedExtensions: allowedExtensions,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        imageQuality: imageQuality,
        showImageCropper: showImageCropper,
        maxCropSize: maxCropSize,
      );
    }

    return pickedFile;
  }

  /// Gets a set of allowed sources from a set of allowed extensions.
  Set<FilePickerSource> _getAllowedSourcesFromExtensions(
    Set<String> extensions,
  ) {
    final allowedExtensions = <FilePickerSource>{};

    for (final extension in extensions) {
      switch (extension) {
        case 'png':
        case 'jpg':
        case 'jpeg':
          allowedExtensions.add(
            FilePickerSource.galleryImage,
          );
          break;

        case 'pdf':
          allowedExtensions.add(
            FilePickerSource.file,
          );
          break;

        case 'video':
          allowedExtensions.add(
            FilePickerSource.video,
          );
          break;
      }
    }

    return allowedExtensions.isNotEmpty
        ? allowedExtensions
        : FilePickerSource.values.toSet();
  }

  /// Returns a file (if picked) related to the passed source.
  ///
  /// Use the [allowedExtensions] value for indicating the allowed extensions.
  /// This parameter is used when the passed [source] is [FilePickerSource.file]
  ///
  /// The [maxWidth], [maxHeight], and [imageQuality] values indicates the
  /// related properties for the camera picked files.
  /// By default, the [maxWidth] value will be `640.0`, the [maxHeight] `800.0`
  /// and the [imageQuality] will be `100`.
  ///
  /// If you wish the user to be able to crop an image after it has been picked,
  /// you can pass the [showImageCropper] as `true`.
  /// By deafult this parameter is `false`.
  ///
  /// The [maxCropSize] is used for determine the max size for the cropped
  /// image.
  /// By default will be `640`.
  Future<PickedFile?> pickFile(
    FilePickerSource source, {
    Set<String> allowedExtensions = const {},
    double maxWidth = 640.0,
    double maxHeight = 800.0,
    int imageQuality = 100,
    bool showImageCropper = false,
    int maxCropSize = 640,
  }) async {
    PickedFile? pickedFile;

    switch (source) {
      case FilePickerSource.cameraImage:
      case FilePickerSource.galleryImage:
        final file = await ImagePicker().pickImage(
          source: source == FilePickerSource.cameraImage
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
        );

        if (file != null) {
          pickedFile = PickedFile(
            file: File(file.path),
            mimeType: file.mimeType,
          );
        }
        break;

      case FilePickerSource.video:
        final result = await FilePicker.platform.pickFiles(
          type: FileType.video,
        );

        if (result?.files.isNotEmpty ?? false) {
          final file = result!.files.first;

          if (file.path != null) {
            pickedFile = PickedFile(
              file: File(file.path!),
            );
          }
        }
        break;

      case FilePickerSource.file:
        final result = await FilePicker.platform.pickFiles(
          type: allowedExtensions.isNotEmpty ? FileType.custom : FileType.any,
          allowedExtensions: allowedExtensions.toList(),
        );

        if (result?.files.isNotEmpty ?? false) {
          final file = result!.files.first;

          if (file.path != null) {
            pickedFile = PickedFile(
              file: File(file.path!),
            );
          }
        }
        break;
    }

    final shouldShowCropper = showImageCropper &&
        [
          FilePickerSource.cameraImage,
          FilePickerSource.galleryImage,
        ].contains(source);

    if (pickedFile != null) {
      pickedFile = shouldShowCropper
          ? pickedFile.copyWith(
              file: await _cropImage(pickedFile.file, maxCropSize),
            )
          : pickedFile;
    }

    return pickedFile;
  }

  /// Crops an image and returns the new file.
  Future<File?> _cropImage(
    File image,
    int maxCropSize,
  ) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      maxHeight: maxCropSize,
      maxWidth: maxCropSize,
      aspectRatio: CropAspectRatio(
        ratioX: 1,
        ratioY: 1,
      ),
      compressFormat: ImageCompressFormat.png,
    );

    return croppedFile == null ? null : File(croppedFile.path);
  }

  Future<FilePickerSource?> _showFilePickerOptionsBottomSheet(
    BuildContext context, {
    String? title,
    required Set<FilePickerSource> allowedSources,
  }) {
    final layerDesign = DesignSystem.of(context);
    final translation = Translation.of(context);

    return BottomSheetHelper.show<FilePickerSource?>(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 26.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[
              Text(
                title,
                style: layerDesign.titleXXL(),
              ),
              const SizedBox(height: 32.0),
            ],
            ...allowedSources.map(
              (source) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: DKButton(
                  title: source.localize(translation),
                  onPressed: () => Navigator.pop(context, source),
                  type: DKButtonType.baseSecondary,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: DKButton(
                  title: translation.translate('cancel'),
                  onPressed: () => Navigator.pop(context),
                  type: DKButtonType.baseSecondary,
                )),
          ],
        ),
      ),
    );
  }
}

/// Model representing the a picked file.
class PickedFile extends Equatable {
  /// The file.
  final File file;

  /// The mime type.
  final String? mimeType;

  /// Creates a new [PickedFile].
  PickedFile({
    required this.file,
    this.mimeType,
  });

  /// Creates a copy with the passed values.
  PickedFile copyWith({
    File? file,
    String? mimeType,
  }) =>
      PickedFile(
        file: file ?? this.file,
        mimeType: mimeType ?? this.mimeType,
      );

  @override
  List<Object?> get props => [
        file,
        mimeType,
      ];
}

/// The allowed sources for picking a file.
enum FilePickerSource {
  /// Image from camera.
  cameraImage,

  /// Image from gallery.
  galleryImage,

  /// Video.
  video,

  /// File.
  file,
}

/// Provides ui extensions for the [FilePickerSource]
extension FilePickerSourceUIExtension on FilePickerSource {
  /// Localizes the source.
  String localize(Translation translation) {
    switch (this) {
      case FilePickerSource.cameraImage:
        return translation.translate('take_photo');

      case FilePickerSource.galleryImage:
        return translation.translate('choose_photo');

      case FilePickerSource.video:
        return translation.translate('choose_video');

      case FilePickerSource.file:
        return translation.translate('choose_file');
    }
  }
}
