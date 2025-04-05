import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:hr_app/services/auth_service.dart';
import 'package:hr_app/models/user_model.dart';
import 'package:hr_app/localization/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Default accounts for development
    if (kDebugMode) {
      // Admin account
      if (_usernameController.text == 'admin' && _passwordController.text == 'admin123') {
        final user = User(
          id: 'admin-user',
          email: 'admin@hrsystem.com',
          fullName: 'مدير النظام',
          role: 'admin'
        );
        context.read<AuthService>().setUser(user);
        return;
      }

      // Employee account
      if (_usernameController.text == 'employee' && _passwordController.text == 'employee123') {
        final user = User(
          id: 'employee-user',
          email: 'employee@hrsystem.com',
          fullName: 'موظف افتراضي',
          role: 'employee'
        );
        context.read<AuthService>().setUser(user);
        return;
      }
    }

    setState(() => _isLoading = true);
    try {
      final auth = context.read<AuthService>();
      await auth.signInWithEmailAndPassword(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'نظام إدارة الموارد البشرية',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم المستخدم',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يجب إدخال اسم المستخدم';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يجب إدخال كلمة المرور';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('تسجيل الدخول'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}