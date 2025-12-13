import 'package:cours_work/data/repositories/auth_repository.dart';
import 'package:cours_work/data/services/local_storage.dart';
import 'package:cours_work/navigation/app_routes.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberMe = false;
  bool obscureText = true;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final token = await LocalStorage.getToken();
    if (token != null && token.isNotEmpty) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  Future<void> _login() async {
    setState(() => loading = true);

    try {
      await AuthRepository().login(
        username: emailController.text.trim(),
        password: passwordController.text.trim(),
        rememberMe: rememberMe,
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: Column(
            children: [

              const SizedBox(height: 20),

              Image.asset(
                'assets/images/auth_illustration.png',
                height: 220,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 20),

              const Text(
                'MenuExplorer',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 36),

              _inputField(
                controller: emailController,
                hint: 'Username',
                icon: Icons.person,
              ),
              const SizedBox(height: 18),

              _inputField(
                controller: passwordController,
                hint: 'Password',
                obscure: obscureText,
                icon: obscureText ? Icons.visibility_off : Icons.visibility,
                onIconTap: () =>
                    setState(() => obscureText = !obscureText),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    activeColor: Colors.black,
                    onChanged: (v) =>
                        setState(() => rememberMe = v ?? false),
                  ),
                  const Text(
                    'Remember me',
                    style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: loading ? null : _login,
                  child: Text(
                    loading ? 'Loading...' : 'Log in',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Divider(height: 1, color: Colors.black26),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.register),
                child: const Text(
                  "Don't have an account?  Sign up",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }


  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    bool obscure = false,
    VoidCallback? onIconTap,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: icon == null
            ? null
            : GestureDetector(
          onTap: onIconTap,
          child: Icon(icon, color: Colors.black),
        ),
      ),
    );
  }
}
