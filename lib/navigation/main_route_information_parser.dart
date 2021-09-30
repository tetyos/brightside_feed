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

    if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'explore') {
      return NexthExplorePath();
    } else if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'incubator') {
      return NexthIncubatorPath();
    } else {
      return NexthHomePath();
    }
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
    print("NOT GOOD, UNKNOWN PATH");
    // todo replace this with error page or something
    return RouteInformation(location: '/home');
  }
}