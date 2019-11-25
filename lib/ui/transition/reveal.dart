import 'package:flutter/material.dart';
import 'package:shaky_rps/ui/utils/circle_clipper.dart';

/// Animation origin can be precise [offset] or less precise but properly
/// working counterpart [alignment].
class AnimationCenter {
  AnimationCenter({this.offset, this.alignment})
      : assert(offset != null || alignment != null);

  final Offset offset;
  final AlignmentGeometry alignment;
}

class RevealRoute extends PageRouteBuilder {
  final Widget page;
  final AnimationCenter centerIn;
  final AnimationCenter centerOut;
  final double minRadius;
  final double maxRadius;

  /// Reveals the next item pushed to the navigation using circle shape.
  ///
  /// The transition doesn't affect the entry screen so we will only touch
  /// the target screen.
  RevealRoute({
    @required this.page,
    this.minRadius = 0,
    @required this.maxRadius,
    @required this.centerIn,
    this.centerOut,
  }) : super(
          /// We could override pageBuilder but it's a required parameter of
          /// [PageRouteBuilder] and it won't build unless it's provided.
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return page;
          },
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    var base = animation.status == AnimationStatus.forward && centerOut != null
        ? centerIn
        : centerOut;

    return ClipPath(
      clipper: CircleClipper(
        fraction: animation.value,
        centerAlignment: base.alignment,
        centerOffset: base.offset,
        minRadius: minRadius,
        maxRadius: maxRadius,
      ),
      child: child,
    );
  }
}
