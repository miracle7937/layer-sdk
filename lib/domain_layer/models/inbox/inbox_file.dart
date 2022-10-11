// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

/// Class that holds information about inbox files
class InboxFile extends Equatable {
  /// The File name
  final String name;

  /// The length of the file
  final int? fileLength;

  /// The status of the chat message
  final InboxChatMessageStatus? status;

  /// base64 File
  final Uint8List? fileBinary;

  /// The file path
  final String? path;

  /// File count
  final int? fileCount;

  InboxFile({
    required this.name,
    this.fileLength,
    this.status,
    this.fileBinary,
    this.path,
    this.fileCount,
  });

  @override
  List<Object?> get props {
    return [
      name,
      fileLength,
      status,
      fileBinary,
      path,
      fileCount,
    ];
  }

  InboxFile copyWith({
    String? name,
    int? fileLength,
    InboxChatMessageStatus? status,
    Uint8List? fileBinary,
    String? path,
    int? fileCount,
  }) {
    return InboxFile(
      name: name ?? this.name,
      fileLength: fileLength ?? this.fileLength,
      status: status ?? this.status,
      fileBinary: fileBinary ?? this.fileBinary,
      path: path ?? this.path,
      fileCount: fileCount ?? this.fileCount,
    );
  }
}

enum InboxChatMessageStatus {
  uploaded,
  uploading,
  failed,
  downloaded,
}
