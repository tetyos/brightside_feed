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
      } else if (uri.pathSegments.first == 'profile') {
        return ProfilePath();
      } else if (uri.pathSegments.first == 'loadingScreen1') {
        return LoadingScreen1Path();
      } else if (uri.pathSegments.first == 'loadingScreen2') {
        return LoadingScreen2Path();
      } else if (uri.pathSegments.first == 'introScreen') {
        return IntroScreenPath();
      } else if (uri.pathSegments.first == 'loginScreen') {
        return LoginScreenPath();
      } else if (uri.pathSegments.first == 'home') {
        return HomePath();
      }
    }
    return LoadingScreen1Path();
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
    if (path is ProfilePath) {
      return RouteInformation(location: '/profile');
    }
    if (path is LoadingScreen1Path) {
      return RouteInformation(location: '/loadingScreen1');
    }
    if (path is LoadingScreen2Path) {
      return RouteInformation(location: '/loadingScreen2');
    }
    if (path is IntroScreenPath) {
      return RouteInformation(location: '/introScreen');
    }
    if (path is LoginScreenPath) {
      return RouteInformation(location: '/loginScreen');
    }
    print("NOT GOOD, UNKNOWN PATH");
    // todo replace this with error page or something
    return RouteInformation(location: '/home');
  }
}