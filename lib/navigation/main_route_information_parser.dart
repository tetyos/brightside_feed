import 'package:flutter/material.dart';
import 'package:nexth/navigation/nexth_route_paths.dart';

class MainRouteInformationParser extends RouteInformationParser<NexthRoutePath> {

  @override
  Future<NexthRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    if (routeInformation.location == null) {
      // todo can this actually happen?
      // error page?
    }
    final uri = Uri.parse(routeInformation.location!);

    if (uri.pathSegments.isNotEmpty) {
      if (uri.pathSegments.first == 'explore') {
        return NexthExplorePath();
      } else if (uri.pathSegments.first == 'incubator') {
        return NexthIncubatorPath();
      } else if (uri.pathSegments.first == 'about') {
        return NexthIncubatorPath();
      } else if (uri.pathSegments.first == 'impressum') {
        return NexthIncubatorPath();
      }
      else if (uri.pathSegments.first == 'home') {
        return NexthHomePath();
      }
    }
    return NexthHomePath();
  }

  @override
  RouteInformation restoreRouteInformation(NexthRoutePath path) {
    if (path is NexthHomePath) {
      return RouteInformation(location: '/home');
    }
    if (path is NexthExplorePath) {
      return RouteInformation(location: '/explore');
    }
    if (path is NexthIncubatorPath) {
      return RouteInformation(location: '/incubator');
    }
    if (path is NexthIncubatorPath) {
      return RouteInformation(location: '/about');
    }
    if (path is NexthIncubatorPath) {
      return RouteInformation(location: '/impressum');
    }
    print("NOT GOOD, UNKNOWN PATH");
    // todo replace this with error page or something
    return RouteInformation(location: '/home');
  }
}