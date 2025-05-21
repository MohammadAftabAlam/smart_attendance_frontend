import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ForgotPasswordSheet extends StatefulWidget {
  const ForgotPasswordSheet({super.key});

  @override
  State<ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<ForgotPasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Reset Password",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              "Email",
              _emailController,
              Icons.mail,
              false,
              TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              "New Password",
              _passwordController,
              Iconsax.lock_15,
              true,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              "Confirm Password",
              _confirmPasswordController,
              Iconsax.lock,
              true,
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Password reset successfully!"),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Submit",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller,
    IconData icon,
    bool isObscure, [
    TextInputType? type,
  ]) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: type,
      validator: (value) {
        if (value == null || value.isEmpty) return "$hint can't be empty";
        if (hint == "Confirm Password" && value != _passwordController.text)
          return "Passwords do not match";
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        prefixIcon: Icon(icon),
        // suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),

      // decoration: InputDecoration(
      //   hintText: hint,
      //   filled: true,
      //   fillColor: Colors.grey.shade100,
      //   contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      //   border: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(30),
      //     borderSide: BorderSide.none,
      //   ),
      // ),
    );
  }
}
