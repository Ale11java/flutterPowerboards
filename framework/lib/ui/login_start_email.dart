import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../model/account.dart';
import '../timu_api/login_api.dart';
import 'auth_storage_cache.dart';
import 'back_icon_button.dart';
import 'login_text_field.dart';
import 'logo_text.dart';
import 'primary_button.dart';
import 'text.dart';

class LoginStartEmailPage extends StatelessWidget {
  const LoginStartEmailPage({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const LogoText(),
        leading: const BackIconButton(),
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
      body: StartEmailForm(email: email),
    );
  }
}

class StartEmailForm extends StatefulWidget {
  const StartEmailForm({super.key, required this.email});

  final String email;

  @override
  StartEmailFormState createState() => StartEmailFormState();
}

class StartEmailFormState extends State<StartEmailForm> {
  final _globalKey = GlobalKey();
  final _loginApi = LoginApi();
  late Future<GetMethodResult?> _loginMethodFuture;

  @override
  void initState() {
    super.initState();
    _loginMethodFuture = _loginApi.getMethod(widget.email);
  }

  void submit(String jwt) {
    if (_globalKey.currentContext != null) {
      _globalKey.currentContext!
          .pushReplacement('/login-start-jwt/$jwt/${widget.email}');
    }
  }

  Future<void> submitPassword(String password) async {
    if (_globalKey.currentContext != null) {
      final context = _globalKey.currentContext!;
      final storage = context.findAncestorStateOfType<AuthStorageCacheState>();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing')),
      );

      try {
        final result = await _loginMethodFuture;
        if (result != null) {
          final flowID = await _loginApi.initLoginFlow();
          final token =
              await _loginApi.loginPassword(flowID, result.username, password);
          final jwt = await _loginApi.exchangeToken(token);

          storage?.addAccount(Account(
              key: result.username,
              email: widget.email,
              // firstName: firstName,
              // lastName: lastName,
              firstName: null,
              lastName: null,
              accessToken: jwt,
              method: 'password',
              provider: null));

          submit(jwt);

          if (context.mounted) {
            ScaffoldMessenger.of(context).clearSnackBars();
          }
          return;
        }
      } catch (e) {
        // Show an error message or handle the error
        print('Error: $e');
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid credentials')),
        );
      }
    }
  }

  Future<void> submitSignup(
      String firstName, String lastName, String password) async {
    if (_globalKey.currentContext != null) {
      final context = _globalKey.currentContext!;
      final storage = context.findAncestorStateOfType<AuthStorageCacheState>();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing')),
      );

      try {
        final flowID = await _loginApi.initRegistrationFlow();
        final username = const Uuid().v4();

        final token = await _loginApi.registerUser(
            flowID, username, firstName, lastName, password);
        final jwt = await _loginApi.exchangeToken(token);

        storage?.addAccount(Account(
            key: username,
            email: widget.email,
            firstName: firstName,
            lastName: lastName,
            accessToken: jwt,
            method: 'password',
            provider: null));

        submit(jwt);

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
    return FutureBuilder<GetMethodResult?>(
      key: _globalKey,
      future: _loginMethodFuture,
      builder:
          (BuildContext context, AsyncSnapshot<GetMethodResult?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
            children: [
              ScreenTitle2(
                text: 'Starting sign in for ${widget.email}',
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
          if (snapshot.data == null) {
            return SignupForm(email: widget.email, submit: submitSignup);
          } else if (snapshot.data!.method == 'password') {
            return PasswordForm(email: widget.email, submit: submitPassword);
          }

          return const Center(
            child: Text('Unknown login method'),
          );
        }
      },
    );
  }
}

class PasswordForm extends StatefulWidget {
  const PasswordForm({super.key, required this.email, required this.submit});

  final String email;
  final void Function(String password) submit;

  @override
  PasswordFormState createState() => PasswordFormState();
}

class PasswordFormState extends State<PasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  void onSubmit() {
    if (_formKey.currentState!.validate()) {
      final password = _passwordController.text;
      widget.submit(password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
        children: [
          ScreenTitle2(
            text: 'Enter password for ${widget.email}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          LoginTextField(
            autofocus: true,
            controller: _passwordController,
            hintText: 'Enter password',
            labelText: 'Password',
            textInputAction: TextInputAction.next,
            // keyboardType: TextInputType.emailAddress,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            text: 'Continue',
            onPressed: onSubmit,
          ),
        ],
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({super.key, required this.email, required this.submit});

  final String email;
  final void Function(String firstName, String lastName, String password)
      submit;

  @override
  SignupFormState createState() => SignupFormState();
}

class SignupFormState extends State<SignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void onSubmit() {
    if (_formKey.currentState!.validate()) {
      final String firstName = _firstNameController.text;
      final String lastName = _lastNameController.text;
      final String password = _passwordController.text;
      final String confirmPassword = _confirmPasswordController.text;

      widget.submit(firstName, lastName, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
        children: [
          ScreenTitle2(
            text: 'Sign up with ${widget.email}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          LoginTextField(
            autofocus: true,
            controller: _firstNameController,
            hintText: 'Enter first name',
            labelText: 'First name',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          LoginTextField(
            controller: _lastNameController,
            hintText: 'Enter last name',
            labelText: 'Last name',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          LoginTextField(
            controller: _passwordController,
            hintText: 'Enter password',
            labelText: 'Password',
            textInputAction: TextInputAction.next,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          LoginTextField(
            controller: _confirmPasswordController,
            hintText: 'Re-enter password to confirm',
            labelText: 'Confirm password',
            textInputAction: TextInputAction.next,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (_passwordController.text != value) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            text: 'Continue',
            onPressed: onSubmit,
          ),
        ],
      ),
    );
  }
}
