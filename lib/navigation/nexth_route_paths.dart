import 'package:flutter/material.dart';

@immutable
abstract class NexthRoutePath {
  const NexthRoutePath();
}

class NexthHomePath extends NexthRoutePath {
  const NexthHomePath();
}

class NexthExplorePath extends NexthRoutePath {
  const NexthExplorePath();
}

class NexthIncubatorPath extends NexthRoutePath {
  const NexthIncubatorPath();
}