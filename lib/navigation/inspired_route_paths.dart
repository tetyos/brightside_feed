import 'package:flutter/material.dart';

@immutable
abstract class InspiredRoutePath {
  const InspiredRoutePath();
}

class InspiredHomePath extends InspiredRoutePath {
  const InspiredHomePath();
}

class InspiredExplorePath extends InspiredRoutePath {
  const InspiredExplorePath();
}

class InspiredIncubatorPath extends InspiredRoutePath {
  const InspiredIncubatorPath();
}