import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:brightside_feed/navigation/app_state.dart';
import 'package:brightside_feed/screens/pre_main_screen/login_screen.dart';
import 'package:brightside_feed/utils/ui_utils.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _verificationCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isVerificationCodeFieldEnabled = false;
  bool _isPasswordFieldEnabled = false;
  bool _isConfirmPasswordFieldEnabled = false;
  String? _email;

  @override
  void initState() {
    super.initState();
    _email = Provider.of<AppState>(context, listen: false).resetPasswordMail;
    _verificationCodeController.addListener(() {
      setState(() {
        _isVerificationCodeFieldEnabled = _verificationCodeController.text.isNotEmpty;
      });
    });
    _passwordController.addListener(() {
      setState(() {
        _isPasswordFieldEnabled = _passwordController.text.isNotEmpty;
      });
    });
    _confirmPasswordController.addListener(() {
      setState(() {
        _isConfirmPasswordFieldEnabled = _confirmPasswordController.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_email == null) {
      return Text('Glitch in the matrix detected.');
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 50,),
              Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                margin: const EdgeInsets.all(30),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text("Enter verification code and new password",
                          textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      renderTextField(
                        controller: _verificationCodeController,
                        icon: Icons.vpn_key_outlined,
                        label: 'Enter verification code',
                      ),
                      SizedBox(height: 10),
                      renderTextField(
                          controller: _passwordController,
                          icon: Icons.lock,
                          label: 'Enter new password',
                          obscureText: true),
                      SizedBox(height: 10),
                      renderTextField(
                          controller: _confirmPasswordController,
                          icon: Icons.lock,
                          label: "Confirm new password",
                          obscureText: true),
                      SizedBox(height: 10),
                      _renderResetButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _verificationCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget renderTextField(
      {required IconData icon, required String label, required TextEditingController controller, bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 4.0),
        prefixIcon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
      ),
    );
  }

  Widget _renderResetButton() {
    bool allFieldsNonEmpty = _isVerificationCodeFieldEnabled &&
        _isPasswordFieldEnabled &&
        _isConfirmPasswordFieldEnabled;

    return MaterialButton(
      onPressed: allFieldsNonEmpty
          ? () {
              _resetPassword(context, _verificationCodeController.text, _passwordController.text,
                  _confirmPasswordController.text);
            }
          : null,
      elevation: 4,
      color: Theme.of(context).primaryColor,
      disabledColor: Colors.teal.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Text(
        'Confirm',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }

  void _resetPassword(BuildContext context, String code, String password, String confirmPassword) async {
    FocusScope.of(context).unfocus();
    bool isPasswordCorrect = _checkPasswords(password, confirmPassword);
    if (!isPasswordCorrect) {
      return;
    }
    try {
      await Amplify.Auth.confirmResetPassword(
          username: _email!,
          newPassword: password,
          confirmationCode: code
      );

      UIUtils.showSnackBar("New password confirmed.", context, color: Colors.green);
      Future.delayed(Duration(milliseconds: 1500), () {
        Provider.of<AppState>(context, listen: false).resetPasswordMail = "";
      });
    } on AmplifyException catch (e) {
      UIUtils.showSnackBar(e.message, context, color: Colors.redAccent);
    }
  }

  bool _checkPasswords(String password, String confirmPassword) {
    if (password != confirmPassword) {
      UIUtils.showSnackBar("Passwords do not match", context, color: Colors.redAccent);
      return false;
    }
    String? errorMessage = LoginScreen.passwordValidator(password);
    if (errorMessage != null) {
      UIUtils.showSnackBar(errorMessage, context, color: Colors.redAccent);
      return false;
    }
    return true;
  }
}