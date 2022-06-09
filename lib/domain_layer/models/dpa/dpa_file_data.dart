import 'package:equatable/equatable.dart';

/// A helper class that keeps the data of an upload DPA file.
class DPAFileData extends Equatable {
  /// The file name.
  final String name;

  /// The file size in bytes.
  final int size;

  /// Creates a new [DPAFileData].
  const DPAFileData({
    required this.name,
    required this.size,
  });

  @override
  List<Object?> get props => [
        name,
        size,
      ];

  /// Creates a new [DPAFileData] using values from this one.
  DPAFileData copyWith({
    String? name,
    int? size,
  }) =>
      DPAFileData(
        name: name ?? this.name,
        size: size ?? this.size,
      );
}
