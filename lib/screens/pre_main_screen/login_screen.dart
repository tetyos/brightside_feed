import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:brightside_feed/model/model_manager.dart';
import 'package:brightside_feed/model/user_data.dart';
import 'package:brightside_feed/navigation/app_state.dart';
import 'package:brightside_feed/navigation/route_paths.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {

  static String? passwordValidator(value) {
    if (value!.isEmpty || value.length < 8) {
      return 'Password is too short!';
    }
    return null;
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    // isLoggedIn();
    LoginMessages loginMessages = LoginMessages(
        signUpSuccess: "An activation code has been sent.",
        recoverPasswordSuccess: "An verification code has been sent.",
        recoverPasswordDescription:
        "We will sent a verification code, which allows you to choose a new password.");
    return FlutterLogin(
      title: 'Brightside-Feed',
      // logo: 'assets/images/ecorp-lightblue.png',
      messages: loginMessages,
      onLogin: _signIn,
      onSignup: _registerUser,
      passwordValidator: LoginScreen.passwordValidator,
      onSubmitAnimationCompleted: () {
        AppState appState = Provider.of<AppState>(context, listen: false);
        if (appState.isDataLoading) {
          appState.currentRoutePath = LoadingScreen2Path();
        } else {
          appState.currentRoutePath = HomePath();
        }
      },
      loginAfterSignUp: false,
      disableCustomPageTransformer: true,
      onRecoverPassword: _recoverPassword,
      // userValidator: ,
      // passwordValidator: ,
      // navigateBackAfterRecovery: false, // todo does not change anything right now. check 'recover_card' of FlutterLogin later on
      loginProviders: [
        LoginProvider(
          icon: Icons.facebook_outlined,
          label: 'Facebook',
          callback: () => socialLoginCallback(AuthProvider.facebook),
        ),
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: 'Google',
          callback: () => socialLoginCallback(AuthProvider.google),
        ),
        LoginProvider(
          icon: Icons.panorama_fish_eye,
          label: 'no account',
          callback: () async {
            return null;
          },
        ),
      ],
    );
  }

  Future<String?> _signIn(LoginData data) async {
    try {
      // todo usage of return value necessary? no exception == login successful?
      await Amplify.Auth.signIn(
        username: data.name,
        password: data.password,
      );
      AuthUser user = await Amplify.Auth.getCurrentUser();
      ModelManager.instance.userModel = UserModel(id: user.userId);
      await retrieveUserDataIfNecessary();
    } on UserNotConfirmedException {
      // we need a short delay, so that the message from FlutterLogin is visible to user before changing screen.
      Future.delayed(Duration(milliseconds: 2000), () {
        Provider.of<AppState>(context, listen: false).confirmLoginMail = data.name;
      });
      return "EMail not confirmed yet.";
    } on AuthException catch (e) {
      return 'Log In Error: ' + e.toString();
    }
  }

  Future<String?> _registerUser(SignupData data) async {
    try {
      if (data.name == null) return "Error: No email provided.";
      Map<String, String> userAttributes = {
        CognitoUserAttributes.email: data.name!,
      };
      // todo usage of return value necessary? no exception == register successful?
      await Amplify.Auth.signUp(
          username: data.name!,
          password: data.password,
          options: CognitoSignUpOptions(userAttributes: userAttributes));

      // we need a short delay, so that the confirmation from FlutterLogin is visible to user before changing screen.
      Future.delayed(Duration(milliseconds: 2500), () {
        Provider.of<AppState>(context, listen: false).confirmLoginMail = data.name!;
      });
      return null;
    } on AuthException catch (e) {
      print(e);
      return "Register Error: " + e.toString();
    }
  }

  Future<String?> _recoverPassword(String name) async {
    try {
      await Amplify.Auth.resetPassword(
        username: name,
      );
      // we need a short delay, so that the confirmation from FlutterLogin is visible to user before changing screen.
      Future.delayed(Duration(milliseconds: 1500), () {
        Provider.of<AppState>(context, listen: false).resetPasswordMail = name;
      });
      return null;
    } on UserNotFoundException {
      return "Please enter correct email address.";
    } on AmplifyException catch (e) {
      return e.message;
    }
  }

  Future<void> retrieveUserDataIfNecessary() async {
    if (!ModelManager.instance.isUserDataRetrieved) {
      await ModelManager.instance.retrieveUserData();
    }
  }

  Future<String?> socialLoginCallback(AuthProvider authProvider) async {
    try {
      // todo usage of return value necessary? no exception == login successful?
      await Amplify.Auth.signInWithWebUI(provider: authProvider);
      AuthUser user = await Amplify.Auth.getCurrentUser();
      ModelManager.instance.userModel = UserModel(id: user.userId);
      await retrieveUserDataIfNecessary();
      return null;
    } on AmplifyException catch (e) {
      print(e.message);
      return 'Login unsuccessful';
    }
  }
}