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

class AboutPath extends AbstractRoutePath {
  const AboutPath();
}