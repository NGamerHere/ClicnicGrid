import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ← for input formatter
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import "../components/MainTitle.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final body = {
      'phone': _phone.text.trim(),
      'password': _password.text,
    };

    try {
      final api = ApiService();
      final result = await api.login(body);

      final token = result['token'] as String;
      final userId = result['user_id'] as num;
      final hospitalId=result['hospital_id'] as num;
      final role = result['role'] as String;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('user_id', userId.toString());
      await prefs.setString('hospital_id', hospitalId.toString());
      await prefs.setString('role', role);

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } on ApiException catch (e) {
      if (!mounted) return;
      _showError(e.message);
    } catch (_) {
      if (!mounted) return;
      _showError('Something went wrong. Try again.');
    }
  }

  void _showError(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

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

              const Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Maintitle(),
              ),
              // const Padding(
              //   padding: EdgeInsets.only(bottom: 24),
              //   child: Text(
              //     'Welcome Back',
              //     style: TextStyle(
              //       fontSize: 28,
              //       fontWeight: FontWeight.bold,
              //       color: Colors.black87,
              //       letterSpacing: 1.2,
              //     ),
              //     textAlign: TextAlign.center,
              //   ),
              // ),

              /* ---- PHONE FIELD ---- */
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // digits only
                ],
                decoration: InputDecoration(
                  labelText: 'Phone number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (v) =>
                    (v != null && v.length == 10) ? null : 'Enter 10 digits',
              ),
              const SizedBox(height: 12),

              /* ---- PASSWORD FIELD ---- */
              TextFormField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (v) =>
                    v != null && v.length >= 6 ? null : 'Min 6 characters',
              ),

              const SizedBox(height: 24),
              ElevatedButton(onPressed: _submit, child: const Text('Sign in')),
            ],
          ),
        ),
      ),
    );
  }
}
