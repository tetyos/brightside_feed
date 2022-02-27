import 'package:flutter/material.dart';
import 'package:brightside_feed/navigation/route_paths.dart';

class MainRouteInformationParser extends RouteInformationParser<AbstractRoutePath> {

  @override
  Future<AbstractRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    if (routeInformation.location == null) {
      // todo can this actually happen?
      // error page?
    }
    final uri = Uri.parse(routeInformation.location!);

    if (uri.pathSegments.isNotEmpty) {
      if (uri.pathSegments.first == 'explore') {
        return ExplorePath();
      } else if (uri.pathSegments.first == 'incubator') {
        return IncubatorPath();
      } else if (uri.pathSegments.first == 'about') {
        return AboutPath();
      }
      else if (uri.pathSegments.first == 'home') {
        return HomePath();
      }
    }
    return HomePath();
  }

  @override
  RouteInformation restoreRouteInformation(AbstractRoutePath path) {
    if (path is HomePath) {
      return RouteInformation(location: '/home');
    }
    if (path is ExplorePath) {
      return RouteInformation(location: '/explore');
    }
    if (path is IncubatorPath) {
      return RouteInformation(location: '/incubator');
    }
    if (path is AboutPath) {
      return RouteInformation(location: '/about');
    }
    print("NOT GOOD, UNKNOWN PATH");
    // todo replace this with error page or something
    return RouteInformation(location: '/home');
  }
}