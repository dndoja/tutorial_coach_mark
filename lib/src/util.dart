import 'package:flutter/widgets.dart';
import 'package:tutorial_coach_mark/src/target/target_focus.dart';
import 'package:tutorial_coach_mark/src/target/target_position.dart';

import 'target/target_content.dart';

// ignore: constant_identifier_names
enum ShapeLightFocus { Circle, RRect }

TargetPosition getEmptyTargetPosition(
  BuildContext context,
  TargetFocus targetFocus,
) {
  final Size size = MediaQuery.of(context).size;
  final ContentAlign? alignment = targetFocus.contents?.firstOrNull?.align;
  final double yOffset = alignment == ContentAlign.top
      ? 124
      : alignment == ContentAlign.bottom
          ? size.height - 124
          : size.height;

  return TargetPosition(
    const Size(1,1),
    Offset(size.width / 2, yOffset),
  );
}

TargetPosition? getTargetCurrent(
  TargetFocus target, {
  bool rootOverlay = false,
}) {
  if (target.keyTarget != null) {
    var key = target.keyTarget!;

    BuildContext? context;
    try {
      final RenderBox renderBoxRed =
          key.currentContext!.findRenderObject() as RenderBox;
      final size = renderBoxRed.size;

      if (rootOverlay) {
        context = key.currentContext!
            .findRootAncestorStateOfType<OverlayState>()
            ?.context;
      } else {
        context = key.currentContext!
            .findAncestorStateOfType<NavigatorState>()
            ?.context;
      }
      Offset offset;
      if (context != null) {
        offset = renderBoxRed.localToGlobal(
          Offset.zero,
          ancestor: context.findRenderObject(),
        );
      } else {
        offset = renderBoxRed.localToGlobal(Offset.zero);
      }

      return TargetPosition(size, offset);
    } catch (e) {
      return null;
    }
  } else {
    return target.targetPosition;
  }
}

abstract class TutorialCoachMarkController {
  void next();
  void previous();
  void skip();
}

extension StateExt on State {
  void safeSetState(VoidCallback call) {
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      setState(call);
    }
  }
}

class NotFoundTargetException extends FormatException {
  NotFoundTargetException()
      : super('It was not possible to obtain target position.');
}

void postFrame(VoidCallback callback) {
  Future.delayed(Duration.zero, callback);
}

extension NullableExt<T> on T? {
  void let(Function(T it) callback) {
    if (this != null) {
      callback(this as T);
    }
  }
}
