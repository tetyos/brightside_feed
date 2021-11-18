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

abstract class ItemDetailsScreenPath extends NexthRoutePath {
}

class HomeItemDetailsPath extends NexthHomePath implements ItemDetailsScreenPath {
  const HomeItemDetailsPath();
}

class IncubatorItemDetailsPath extends NexthIncubatorPath implements ItemDetailsScreenPath {
  const IncubatorItemDetailsPath();
}

class ExploreItemDetailsPath extends NexthExplorePath implements ItemDetailsScreenPath {
  const ExploreItemDetailsPath();
}

abstract class PreMainScreenPath extends NexthRoutePath {
  const PreMainScreenPath();
}

class LoadingScreen1Path extends PreMainScreenPath {
  const LoadingScreen1Path();
}

class LoadingScreen2Path extends PreMainScreenPath {
  const LoadingScreen2Path();
}

class IntroScreenPath extends PreMainScreenPath {
  const IntroScreenPath();
}

class LoginScreenPath extends PreMainScreenPath {
  const LoginScreenPath();
}

class ConfirmScreenPath extends LoginScreenPath {
  const ConfirmScreenPath();
}