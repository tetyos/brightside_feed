import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class CustomPageViewScrollPhysics extends ScrollPhysics {

  const CustomPageViewScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor));
  }

  // @override
  // SpringDescription get spring => SpringDescription.withDampingRatio(
  //   mass: 0.1,
  //   stiffness: 100,
  //   ratio: 1.1,
  // );

  @override
  SpringDescription get spring => SpringDescription(
    mass: 30,
    stiffness: 100,
    damping: 1.1,
  );
}