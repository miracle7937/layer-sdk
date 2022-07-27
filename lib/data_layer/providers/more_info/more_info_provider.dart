import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../network.dart';

/// Provides data related to Image rendered on server
/// based on a list of [MoreInfoField]s
class MoreInfoProvider {
  /// The NetClient to use for the network requests
  final NetClient _netClient;

  /// Creates a new [MoreInfoProvider]
  MoreInfoProvider({
    required NetClient netClient,
  }) : _netClient = netClient;

  /// Fetch the rendered file
  Future<Uint8List> fetchRenderedFile(List<MoreInfoField> infoFields) async {
    final fields = <Map<String, dynamic>>[];

    for (var f in infoFields) {
      fields.add(f.toMoreInfoFieldDTO().toJson());
    }

    final moreInfo = <String, dynamic>{
      'more_info': fields,
    };

    final data = <String, dynamic>{
      'data': moreInfo,
      'parameters': {
        'body': 'body.html',
      }
    };

    final response = await _netClient.request(
      _netClient.netEndpoints.moreInfo,
      method: NetRequestMethods.post,
      responseType: ResponseType.bytes,
      data: data,
    );

    return response.data;
  }
}
