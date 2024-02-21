import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _submitEmail();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitEmail() {
    String email = _emailController.text;
    // TODO: Implement logic to send password reset email
    print('Sending password reset email to $email');
    // Reset the email field after submission
    _emailController.clear();
    // Show a snackbar or dialog to inform the user that the email has been sent
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Password reset email sent to $email'),
      ),
    );
  }
}


