import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:nexth/model/model_manager.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/navigation/nexth_route_paths.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String?> _signIn(LoginData data) async {
    try {
      // todo usage of return value necessary? no exception == login successful?
      await Amplify.Auth.signIn(
        username: data.name,
        password: data.password,
      );
      Provider.of<AppState>(context, listen: false).isUserLoggedIn = true;
      await retrieveUserVotesIfNecessary();
      // AuthUser user = await Amplify.Auth.getCurrentUser();
      // Provider.of<AppState>(context, listen: false).userData = user.userId;
      // Provider.of<AppState>(context, listen: false).mail = user.username;
    } on AuthException catch (e) {
      return 'Log In Error: ' + e.toString();
    }
  }

  Future<String?> _registerUser(LoginData data) async {
    try {
      Map<String, String> userAttributes = {
        CognitoUserAttributes.email: data.name,
      };
      // todo usage of return value necessary? no exception == register successful?
      await Amplify.Auth.signUp(
          username: data.name,
          password: data.password,
          options: CognitoSignUpOptions(userAttributes: userAttributes));

      Future.delayed(Duration(milliseconds: 2500), () {
        Provider.of<AppState>(context, listen: false).currentRoutePath = ConfirmScreenPath();
        Provider.of<AppState>(context, listen: false).confirmLoginMail = data.name;
      });
      return null;
    } on AuthException catch (e) {
      print(e);
      return "Register Error: " + e.toString();
    }
  }

  Future<String?> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      // if (!users.containsKey(name)) {
      //   return 'User not exists';
      // }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // isLoggedIn();
    LoginMessages loginMessages = LoginMessages(
        signUpSuccess: "An activation code has been sent.",
        recoverPasswordDescription:
            "We will sent you a confirmation code, which allows you to reset you password.");
    return FlutterLogin(
      title: 'Nera News',
      // logo: 'assets/images/ecorp-lightblue.png',
      messages: loginMessages,
      onLogin: _signIn,
      onSignup: _registerUser,
      onSubmitAnimationCompleted: () {
        AppState appState = Provider.of<AppState>(context, listen: false);
        if (appState.isDataLoading) {
          appState.currentRoutePath = LoadingScreen2Path();
        } else {
          appState.currentRoutePath = NexthHomePath();
        }
      },
      loginAfterSignUp: false,
      disableCustomPageTransformer: true,
      onRecoverPassword: _recoverPassword,
      // userValidator: ,
      // passwordValidator: ,
      navigateBackAfterRecovery: true,
      loginProviders: [
        LoginProvider(
          icon: Icons.facebook_outlined,
          label: 'Facebook',
          callback: () => socialLoginCallback(AuthProvider.facebook),
        ),
        LoginProvider(
          icon: Icons.grid_on_outlined,
          label: 'Google',
          callback: () => socialLoginCallback(AuthProvider.google),
        ),
        LoginProvider(
          icon: Icons.panorama_fish_eye,
          label: 'no acc',
          callback: () async {
            return null;
          },
        ),
      ],
    );
  }

  Future<void> retrieveUserVotesIfNecessary() async {
    if (!ModelManager.instance.isUserVotesRetrieved) {
      await ModelManager.instance.retrieveUserVotes();
    }
  }

  Future<String?> socialLoginCallback(AuthProvider authProvider) async {
    try {
      // todo usage of return value necessary? no exception == login successful?
      await Amplify.Auth.signInWithWebUI(provider: authProvider);
      Provider.of<AppState>(context, listen: false).isUserLoggedIn = true;
      await retrieveUserVotesIfNecessary();
      // AuthSession authSession = await Amplify.Auth.fetchAuthSession(options: CognitoSessionOptions(getAWSCredentials: true),);
      // AuthUser user = await Amplify.Auth.getCurrentUser();
      // print(authSession.isSignedIn);
      return null;
    } on AmplifyException catch (e) {
      print(e.message);
      return 'Login unsuccessful';
    }
  }
}