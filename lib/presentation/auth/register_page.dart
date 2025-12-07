import 'package:cours_work/data/repositories/auth_repository.dart';
import 'package:cours_work/navigation/app_routes.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool obscurePass1 = true;
  bool obscurePass2 = true;
  bool loading = false;

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
                'Join us to explore menus',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 36),

              _inputField(
                controller: usernameController,
                hint: 'Username',
                icon: Icons.person,
              ),
              const SizedBox(height: 18),

              _inputField(
                controller: emailController,
                hint: 'Email',
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 18),

              _inputField(
                controller: passwordController,
                hint: 'Password',
                obscure: obscurePass1,
                icon: obscurePass1 ? Icons.visibility_off : Icons.visibility,
                onIconTap: () => setState(() => obscurePass1 = !obscurePass1),
              ),
              const SizedBox(height: 18),

              _inputField(
                controller: confirmController,
                hint: 'Confirm Password',
                obscure: obscurePass2,
                icon: obscurePass2 ? Icons.visibility_off : Icons.visibility,
                onIconTap: () => setState(() => obscurePass2 = !obscurePass2),
              ),

              const SizedBox(height: 32),

              // ---------- Button ----------
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: loading
                      ? null
                      : () async {
                          if (passwordController.text.trim() !=
                              confirmController.text.trim()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Passwords do not match'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          setState(() => loading = true);
                          try {
                            await AuthRepository().register(
                              username: usernameController.text.trim(),
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );

                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Registration successful!'),
                                backgroundColor: Colors.green,
                              ),
                            );

                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.login,
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: ${e.toString()}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } finally {
                            if (mounted) setState(() => loading = false);
                          }
                        },
                  child: Text(
                    loading ? 'Loading...' : 'Sign up',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Divider(height: 1, color: Colors.black26),
              const SizedBox(height: 20),

              // ---------- Login Redirect ----------
              GestureDetector(
                onTap: () =>
                    Navigator.pushReplacementNamed(context, AppRoutes.login),
                child: const Text(
                  'Have an account?  Log in',
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

  // ---------- Input builder ----------
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
