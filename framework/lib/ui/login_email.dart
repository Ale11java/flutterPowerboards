import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'back_icon_button.dart';
import 'login_text_field.dart';
import 'logo_text.dart';
import 'primary_button.dart';
import 'text.dart';

class LoginEmailPage extends StatelessWidget {
  const LoginEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const LogoText(),
        leading: const BackIconButton(),
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
      body: const EmailForm(),
    );
  }
}

class EmailForm extends StatefulWidget {
  const EmailForm({super.key});

  @override
  EmailFormState createState() => EmailFormState();
}

class EmailFormState extends State<EmailForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  void onSubmit() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;

      if (_formKey.currentContext != null) {
        _formKey.currentContext!.push('/login-start-email/$email');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
        children: [
          const ScreenTitle2(
            text: 'Add an account using your email',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          LoginTextField(
            autofocus: true,
            controller: _emailController,
            hintText: 'Enter email',
            labelText: 'Email',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              const emailPattern =
                  r'^[\w-]+(\.[\w-]+)*(\+[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,}$';
              final isValidEmail = RegExp(emailPattern).hasMatch(value);
              if (!isValidEmail) {
                return 'Please enter a valid email';
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
