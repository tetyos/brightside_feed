import 'package:flutter/material.dart';

@immutable
abstract class AbstractRoutePath {
  const AbstractRoutePath();
}

class HomePath extends AbstractRoutePath {
  const HomePath();
}

class ExplorePath extends AbstractRoutePath {
  const ExplorePath();
}

class IncubatorPath extends AbstractRoutePath {
  const IncubatorPath();
}

class ProfilePath extends AbstractRoutePath {
  const ProfilePath();
}

/// Pre main screen paths
abstract class PreMainScreenPath extends AbstractRoutePath {
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