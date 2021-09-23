import 'package:flutter/material.dart';
import 'package:inspired/navigation/inspired_route_paths.dart';

class MainRouteInformationParser extends RouteInformationParser<InspiredRoutePath> {

  @override
  Future<InspiredRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    if (routeInformation.location == null) {
      // todo can this actually happen?
      // error page?
    }
    final uri = Uri.parse(routeInformation.location!);

    if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'explore') {
      return InspiredExplorePath();
    } else if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'incubator') {
      return InspiredIncubatorPath();
    } else {
      return InspiredHomePath();
    }
  }

  @override
  RouteInformation restoreRouteInformation(InspiredRoutePath path) {
    if (path is InspiredHomePath) {
      return RouteInformation(location: '/home');
    }
    if (path is InspiredExplorePath) {
      return RouteInformation(location: '/explore');
    }
    if (path is InspiredIncubatorPath) {
      return RouteInformation(location: '/incubator');
    }
    print("NOT GOOD, UNKNOWN PATH");
    // todo replace this with error page or something
    return RouteInformation(location: '/home');
  }
}