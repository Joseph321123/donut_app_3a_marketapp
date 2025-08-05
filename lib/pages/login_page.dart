import 'package:flutter/material.dart';
import 'package:donut_app_3a_marketapp/pages/home_page.dart';
import 'package:donut_app_3a_marketapp/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final correo = _correoController.text.trim();
    final contrasena = _contrasenaController.text;

    try {
      final token = await AuthService.login(correo, contrasena);
      if (token != null) {
        // Aquí podrías guardar el token localmente con SharedPreferences si deseas

        // Navegar al HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        setState(() {
          _errorMessage = "Correo o contraseña inválidos";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error inesperado: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                "Market App Login",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _correoController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Correo electrónico",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _contrasenaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Contraseña",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 218, 113, 148),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                      ),
                      child: const Text(
                        "Iniciar sesión",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
