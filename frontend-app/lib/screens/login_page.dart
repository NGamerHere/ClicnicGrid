import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email    = TextEditingController();
  final _password = TextEditingController();
  final _formKey  = GlobalKey<FormState>();

  /// 👉 1.  Make submit async so we can `await` API / storage calls.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // 👉 2. Pretend we hit a backend and got a JWT back.
    //     Replace this with your real API call.
    const fakeToken = 'ey.fake.jwt.token';

    // 👉 3. Save the token securely (for quick demos SharedPreferences is fine).
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', fakeToken);

    // 👉 4. Navigate away.
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) =>
                v!.contains('@') ? null : 'Enter a valid email',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (v) =>
                v!.length >= 6 ? null : 'Min 6 characters',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,                   // ← now async
                child: const Text('Sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
