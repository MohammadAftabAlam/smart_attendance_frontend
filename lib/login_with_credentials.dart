import 'package:flutter/material.dart';
import 'package:freelance/home_screen.dart';
import 'package:local_auth/local_auth.dart';

class FingerprintLoginPage extends StatefulWidget {
  const FingerprintLoginPage({super.key});

  @override
  State<FingerprintLoginPage> createState() => _FingerprintLoginPageState();
}

class _FingerprintLoginPageState extends State<FingerprintLoginPage> {
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _authenticate() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isAuthenticated = false;

      if (canCheckBiometrics) {
        isAuthenticated = await auth.authenticate(
          localizedReason: 'Use fingerprint to login',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          ),
        );
      }

      if (isAuthenticated) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()), (Route<dynamic> route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful!')),
        );

        // Navigate to home screen or perform login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authentication failed')),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fingerprint Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: _authenticate,
          child: Text('Login with Fingerprint'),
        ),
      ),
    );
  }
}
