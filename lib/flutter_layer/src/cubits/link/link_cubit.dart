import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:validators/validators.dart';

import '../../../../data_layer/data_layer.dart';
import '../../../../migration/data_layer/network.dart';
import 'link_states.dart';

/// A cubit that helps with opening files from links.
class LinkCubit extends Cubit<LinkState> {
  final FileRepository _fileRepository;

  /// Creates [LinkCubit].
  LinkCubit({
    required FileRepository fileRepository,
  })  : _fileRepository = fileRepository,
        super(LinkState());

  /// Opens a link. Checks if it should open on a browser or if it should
  /// download and open in a dedicated app.
  Future<void> openLink({
    required String? link,
  }) async {
    assert(!state.busy, 'Cannot open a link when busy.');

    emit(
      state.copyWith(
        busy: true,
        errorStatus: LinkErrorStatus.none,
      ),
    );

    if (link?.isEmpty ?? true) {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: LinkErrorStatus.invalidURL,
        ),
      );

      return;
    }

    if (!isURL(link)) {
      emit(
        state.copyWith(busy: false),
      );

      openFile(link!);

      return;
    }

    final uri = Uri.tryParse(link!);

    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri);

      return;
    }

    emit(
      state.copyWith(
        busy: false,
        errorStatus: LinkErrorStatus.launchError,
      ),
    );
  }

  /// Opens a file by downloading it and opening on a dedicated app.
  Future<void> openFile(
    String url, {
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    bool fromCache = false,
    bool isPDF = false,
    bool inferFromBase64 = false,
    String defaultInferredType = 'jpeg',
  }) async {
    assert(!state.busy, 'Cannot open a link when busy.');

    emit(
      state.copyWith(
        busy: true,
        downloadedBytes: 0,
        totalBytes: 0,
        errorStatus: LinkErrorStatus.none,
      ),
    );

    final appPath = (await getApplicationDocumentsDirectory()).path;
    final parts = url.split('/');
    final fileName = parts.length > 1 ? parts.last : 'document.pdf';
    final path = '$appPath/$fileName';

    final file = File(path);

    // TODO: improve in the future... this can be done by opening the file?
    var uti = isPDF ? 'com.adobe.pdf' : null;
    var type = isPDF ? 'application/pdf' : null;

    if (fromCache && (await file.exists())) {
      OpenFile.open(
        path,
        uti: uti,
        type: type,
      );

      emit(
        state.copyWith(
          busy: false,
        ),
      );

      return;
    }

    try {
      final response = await _fileRepository.downloadFile(
        url: url,
        queryParameters: queryParameters,
        onReceiveProgress: (count, total) => emit(
          state.copyWith(
            downloadedBytes: count,
            totalBytes: total,
          ),
        ),
      );

      if (response is Map<String, dynamic>) {
        final responseContent = response['image'].toString().split(',');
        final imageData = base64Decode(responseContent[1]);

        if (inferFromBase64) {
          final inferPDF = response['image'].contains('application/pdf');

          type = inferPDF ? 'application/pdf' : 'image/$defaultInferredType';
          uti = inferPDF ? 'com.adobe.pdf' : 'public.$defaultInferredType';
        }

        await file.writeAsBytes(imageData);
      } else {
        await file.writeAsBytes(response);
      }

      emit(
        state.copyWith(
          busy: false,
          downloadedBytes: 0,
          totalBytes: 0,
        ),
      );

      OpenFile.open(
        file.path,
        uti: uti,
        type: type,
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          downloadedBytes: 0,
          totalBytes: 0,
          errorStatus: e.toLinkErrorStatus(),
        ),
      );
    }
  }
}

extension on Exception {
  LinkErrorStatus toLinkErrorStatus() {
    return this is NetException
        ? LinkErrorStatus.network
        : this is IOException
            ? LinkErrorStatus.io
            : LinkErrorStatus.generic;
  }
}
