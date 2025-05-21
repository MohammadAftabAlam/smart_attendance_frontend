import 'package:flutter/material.dart';
import 'package:freelance/controllers/user_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String authToken;

  const ChangePasswordScreen({super.key, required this.authToken});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  UserController userController = UserController();

  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      bool isPasswordChanged = await userController.changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        token: widget.authToken,
      );
      // 'Password changed successfully!'
      if(isPasswordChanged){
        showSnackBar("Password changed successfully", Colors.green);
        popToPreviousScreen();
      }
    } catch (e) {
      showSnackBar(e.toString(), Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 50,
      ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Change Password",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Current Password",
                  // prefixIcon: Icon(icon),
                  // suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter current password' : null,
              ),

              SizedBox(height: 20,),

              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "New Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator:
                    (value) =>
                        value!.length < 6
                            ? 'Minimum 6 characters required'
                            : null,
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Confirm New Password",
                  // prefixIcon: Icon(icon),
                  // suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: TextButton.styleFrom(foregroundColor: Colors.blue),
                child:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Change Password'),
              ),
            ],
          ),
        ),
      );
  }

  void showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        showCloseIcon: true,
        closeIconColor: Colors.white,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void popToPreviousScreen(){
      Navigator.pop(context);
  }
}
