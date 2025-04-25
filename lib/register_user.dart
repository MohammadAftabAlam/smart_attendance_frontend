import 'package:flutter/material.dart';
import 'package:freelance/controllers/user_controller.dart';
import 'package:iconsax/iconsax.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
    final _formKey = GlobalKey<FormState>();
    UserController userController = UserController();

    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    bool isLoading = false;

    void showSnackBar(String message, Color? color) {
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

    void registerUser() async {
      setState(() {
        isLoading = true;
      });
      try {
        bool isUserRegister = await userController.registerUser(
          fullName: nameController.text.trim(),
          email: emailController.text,
          password: passwordController.text,
        );
        if (isUserRegister) {
          showSnackBar("User Registered Successfully", Colors.green);
        } else {
          showSnackBar("User Registration Failed", Colors.red);
        }
      } catch (e) {
        showSnackBar("Error: $e", Colors.red);
      }
      setState(() {
        isLoading = false;
      });
    }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5F1FF), // Light blue like login screen
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Arrow
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),
              const Text(
                "Register",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Mark you attendance with new technologies with ease.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 30),

              // Full Name
              // buildTextField(icon: Icons.person, hintText: "Full Name"),

          TextFormField(
            obscureText: false,
            controller: nameController,
            validator: (String? value) {
              String name = nameController.text.toString();
              if (name == "") {
                return "Enter your name";
              }
              return null;
            },
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Name",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)
                )
            ),
          ),

            const SizedBox(height: 20),

              // Email
              TextFormField(
                obscureText: false,
                controller: emailController,
                validator: (String? value) {
                  String email = emailController.text.toString();
                  if (!email.contains('@') || !email.endsWith("gmail.com")) {
                    return "Enter a valid email address";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Email",
                    prefixIcon: Icon(Icons.mail),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)
                    )
                ),

              ),
              const SizedBox(height: 20),

              buildTextField(
                icon: Iconsax.element_1,
                hintText: "Enrollment Number",
              ),
              const SizedBox(height: 20),

              buildTextField(
                icon: Icons.roller_shades,
                hintText: "University Roll Number",
              ),
              const SizedBox(height: 20),

              // Password
              // buildTextField(
              //   icon: Icons.lock,
              //   hintText: "Password",
              //   obscureText: true,
              //   suffixIcon: Icons.visibility,
              // ),
              TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Password",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)
                    )
                ),

              ),
              const SizedBox(height: 20),

              // Confirm Password
              // buildTextField(
              //   icon: Icons.lock_outline,
              //   hintText: "Confirm Password",
              //   obscureText: true,
              //   suffixIcon: Icons.visibility,
              // ),

              TextFormField(
                obscureText: false,
                controller: confirmPasswordController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Confirm Password",
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)
                    )
                ),

              ),
              const SizedBox(height: 30),

              // Register Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if(!_formKey.currentState!.validate()){
                      showSnackBar("Missing Required Field", Colors.red);
                    }else if(passwordController.text.trim() != confirmPasswordController.text.trim()){
                      showSnackBar("Password doesn't match",Colors.red);
                    }
                    else{
                      registerUser();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Bright green
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                  isLoading
                      ? CircularProgressIndicator()
                      : const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Already have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Having an account ",style:TextStyle(
                    // color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),),
                  TextButton(onPressed: (){
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }, child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),),
                ],
              ),
            ],
          ),)
        ),
      ),
    );
  }

  Widget buildTextField({
    required IconData icon,
    required String hintText,
    bool obscureText = false,
    IconData? suffixIcon,
  }) {
    return TextField(
      obscureText: obscureText,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
