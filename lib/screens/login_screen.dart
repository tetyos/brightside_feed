import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/navigation/nexth_route_paths.dart';
import 'package:provider/provider.dart';

const users = const {
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSignedUp = false;

  bool _isConfirmed = false;

  bool _isSignedIn = false;

  String? _userName;

  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String?> _signIn(LoginData data) async {
    try {
      SignInResult res = await Amplify.Auth.signIn(
        username: data.name,
        password: data.password,
      );

      _isSignedIn = res.isSignedIn;
    } on AuthException catch (e) {
      print(e);
      return 'Log In Error: ' + e.toString();
    }

    // print('Name: ${data.name}, Password: ${data.password}');
    // return Future.delayed(loginTime).then((_) {
    //   if (!users.containsKey(data.name)) {
    //     return 'User not exists';
    //   }
    //   if (users[data.name] != data.password) {
    //     return 'Password does not match';
    //   }
    //   return "";
    // });
  }

  Future<String?> _registerUser(LoginData data) async {
    try {
      Map<String, String> userAttributes = {
        CognitoUserAttributes.email: data.name,
        CognitoUserAttributes.preferredUsername: 'tetyos',
      };
      SignUpResult res = await Amplify.Auth.signUp(
          username: data.name,
          password: data.password,
          options: CognitoSignUpOptions(userAttributes: userAttributes));

      _userName = data.name;
      _isSignedUp = res.isSignUpComplete;
      return null;
    } on AuthException catch (e) {
      print(e);
      return "Register Error: " + e.toString();
    }
  }

  Future<String?> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // isLoggedIn();
    return FlutterLogin(
      title: 'Nera News',
      // logo: 'assets/images/ecorp-lightblue.png',
      onLogin: _signIn,
      onSignup: _registerUser,
      onSubmitAnimationCompleted: () {
        Provider.of<AppState>(context, listen: false).currentRoutePath = NexthHomePath();
      },
      loginAfterSignUp: false,
      onRecoverPassword: _recoverPassword,
      // userValidator: ,
      // passwordValidator: ,
      navigateBackAfterRecovery: true,
    );
  }
}