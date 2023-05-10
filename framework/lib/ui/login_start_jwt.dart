import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../timu_api/login_api.dart';
import 'back_icon_button.dart';
import 'login_email_verify_watch.dart';
import 'login_text_field.dart';
import 'logo_text.dart';
import 'primary_button.dart';
import 'text.dart';

class LoginStartJwtPage extends StatelessWidget {
  LoginStartJwtPage({super.key, required this.jwt, required this.email});

  final String jwt;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const LogoText(),
        leading: const BackIconButton(),
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
      body: StartJwtForm(jwt: jwt, email: email),
    );
  }
}

class StartJwtForm extends StatefulWidget {
  const StartJwtForm({super.key, required this.jwt, required this.email});

  final String jwt;
  final String email;

  @override
  StartJwtFormState createState() => StartJwtFormState();
}

class StartJwtFormState extends State<StartJwtForm> {
  final _globalKey = GlobalKey();
  final LoginApi _loginApi = LoginApi();
  late Future<bool?> _isEmailVerifiedFuture;

  @override
  void initState() {
    super.initState();

    _isEmailVerifiedFuture = _loginApi.isEmailVerified(widget.jwt);

    _handleIsEmailVerified();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (_key.currentContext != null) {
    //     _handleEmailVerification(_globalKey.currentContext!);
    //   }
    // });
  }

  void submit() {
    if (_globalKey.currentContext != null) {
      _globalKey.currentContext!.go('/my-home-page');
    }
  }

  Future<void> _handleIsEmailVerified() async {
    try {
      final result = await _isEmailVerifiedFuture;
      if (result != null && result) {
        await verified();
        // await _loginApi.ramp(widget.jwt);

        // submit();
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> submitCode(String flowID, String token, String code) async {
    if (_globalKey.currentContext != null) {
      final context = _globalKey.currentContext!;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing')),
      );

      try {
        await _loginApi.verifyEmailWithCode(widget.jwt, flowID, token, code);
        //await verified();
        // await _loginApi.ramp(widget.jwt);

        // submit();

        // if (context.mounted) {
        //   ScaffoldMessenger.of(context).clearSnackBars();
        // }
        return;
      } catch (e) {
        // Show an error message or handle the error
        print('Error: $e');
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid code')),
        );
      }
    }
  }

  Future<void> verified() async {
    if (_globalKey.currentContext != null) {
      final context = _globalKey.currentContext!;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preparing')),
      );

      try {
        await _loginApi.ramp(widget.jwt);

        submit();

        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
        }
        return;
      } catch (e) {
        // Show an error message or handle the error
        print('Error: $e');
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool?>(
      key: _globalKey,
      future: _isEmailVerifiedFuture,
      builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
            children: [
              ScreenTitle2(
                text: 'Signing in ${widget.email}',
                textAlign: TextAlign.center,
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
            children: [
              ScreenTitle2(
                text: 'Error: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ],
          );
        } else {
          if (snapshot.data == null || snapshot.data == false) {
            return VerifyCodeForm(
              jwt: widget.jwt,
              email: widget.email,
              submit: submitCode,
              verified: verified,
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
            children: [
              ScreenTitle2(
                text: 'Signing in ${widget.email}',
                textAlign: TextAlign.center,
              ),
            ],
          );
        }
      },
    );
  }
}

class VerifyCodeForm extends StatefulWidget {
  const VerifyCodeForm(
      {super.key,
      required this.jwt,
      required this.email,
      required this.submit,
      required this.verified});

  final String jwt;
  final String email;
  final void Function(String flowID, String token, String code) submit;
  final Future<void> Function() verified;

  @override
  VerifyCodeFormFormState createState() => VerifyCodeFormFormState();
}

class VerifyCodeFormFormState extends State<VerifyCodeForm> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final LoginApi _loginApi = LoginApi();
  late Future<VerifyEmailResult?> _verifyEmailFuture;

  @override
  void initState() {
    super.initState();

    _verifyEmailFuture = _loginApi.verifyEmail(widget.jwt, widget.email);
  }

  void onSubmit(String flowID, String token) {
    if (_formKey.currentState!.validate()) {
      final code = _codeController.text;
      widget.submit(flowID, token, code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: FutureBuilder<VerifyEmailResult?>(
        future: _verifyEmailFuture,
        builder:
            (BuildContext context, AsyncSnapshot<VerifyEmailResult?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
              children: [
                ScreenTitle2(
                  text: 'Sending verification code to ${widget.email}',
                  textAlign: TextAlign.center,
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
              children: [
                ScreenTitle2(
                  text: 'Error: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ],
            );
          } else {
            if (snapshot.data != null) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
                children: [
                  ScreenTitle2(
                    text: 'Enter verification code sent to ${widget.email}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  LoginTextField(
                    autofocus: true,
                    controller: _codeController,
                    hintText: 'Enter six digit verification code',
                    labelText: 'Verification code',
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your verification code';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    text: 'Continue',
                    onPressed: () =>
                        onSubmit(snapshot.data!.flowID, snapshot.data!.token),
                  ),
                  LoginEmailVerifyWatch(
                    jwt: widget.jwt,
                    verified: widget.verified,
                  )
                ],
              );
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
              children: [
                ScreenTitle2(
                  text: 'Signing in ${widget.email}',
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
