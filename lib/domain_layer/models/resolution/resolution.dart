import 'package:equatable/equatable.dart';

/// Holds the resolution data for a device.
///
/// As data-layer is a pure dart project, we don't have access to
/// classes like Size so we're using our own classes.
class Resolution extends Equatable {
  /// The horizontal extent of this resolution.
  final double width;

  /// The vertical extent of this resolution.
  final double height;

  /// Creates a [Resolution] with the given [width] and [height].
  const Resolution(this.width, this.height);

  /// The lesser of the magnitudes of the [width] and the [height].
  double get shortestSide => width.abs() < height.abs() ? width : height;

  /// The greater of the magnitudes of the [width] and the [height].
  double get longestSide => width.abs() > height.abs() ? width : height;

  @override
  List<Object?> get props => [width, height];
}
