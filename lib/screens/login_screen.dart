import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isLogin = true; // Toggle between Login and Signup
  bool isLoading = false;

  // Handle Signup Logic
  Future<void> _handleSignup() async {
    if (fullNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _showSnackBar("Please fill in all fields.");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showSnackBar("Passwords do not match.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      const String baseUrl = "http://10.0.2.2:8080/users/register";
      Map<String, dynamic> signupData = {
        "name": fullNameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "phone": phoneController.text,
        "role": "USER",
      };

      Response response = await Dio().post(
        baseUrl,
        data: signupData,
        options: Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          _showSnackBar("Signup Successful! Please login.");
          setState(() {
            isLogin = true;
          });
        }
      } else {
        if (mounted) {
          _showSnackBar("Signup Failed: ${response.data}");
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar("Signup Failed: $e");
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Handle Login Logic
  Future<void> _handleLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showSnackBar("Please fill in all fields.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      const String baseUrl = "http://10.0.2.2:8080/api/login";
      Map<String, dynamic> loginData = {
        "email": emailController.text,
        "password": passwordController.text,
      };

      Response response = await Dio().post(
        baseUrl,
        data: loginData,
        options: Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          _showSnackBar("Login Successful! Redirecting...");
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }
      } else {
        if (mounted) {
          _showSnackBar("Login Failed: Invalid credentials.");
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar("Login Failed: $e");
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Show SnackBar Helper
  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Section
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF8B0000),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'La Baguette Raffinée',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'SAVOUREZ LE RAFFINEMENT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Toggle Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => setState(() => isLogin = true),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: isLogin ? const Color(0xFF8B0000) : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => isLogin = false),
                    child: Text(
                      "Sign-up",
                      style: TextStyle(
                        color: !isLogin ? const Color(0xFF8B0000) : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.grey, thickness: 1),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: isLogin ? _buildLoginForm() : _buildSignupForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Login Form
  Widget _buildLoginForm() {
    return Column(
      children: [
        _buildInputField("Email", emailController),
        const SizedBox(height: 16),
        _buildInputField("Password", passwordController, isPassword: true),
        const SizedBox(height: 24),
        _buildSubmitButton("Login", _handleLogin, isLoading: isLoading),
      ],
    );
  }

  // Signup Form
  Widget _buildSignupForm() {
    return Column(
      children: [
        _buildInputField("Full Name", fullNameController),
        const SizedBox(height: 16),
        _buildInputField("Email", emailController),
        const SizedBox(height: 16),
        _buildInputField("Phone", phoneController),
        const SizedBox(height: 16),
        _buildInputField("Password", passwordController, isPassword: true),
        const SizedBox(height: 16),
        _buildInputField("Confirm Password", confirmPasswordController, isPassword: true),
        const SizedBox(height: 24),
        _buildSubmitButton("Sign Up", _handleSignup, isLoading: isLoading),
      ],
    );
  }

  // Input Field Widget
  Widget _buildInputField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(hintText: "Enter $label"),
        ),
      ],
    );
  }

  // Submit Button Widget
  Widget _buildSubmitButton(String text, VoidCallback onPressed, {bool isLoading = false}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8B0000),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(text),
    );
  }
}
