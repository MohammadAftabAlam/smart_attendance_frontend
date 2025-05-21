import 'package:flutter/material.dart';
import 'package:freelance/controllers/auth.dart';
import 'package:freelance/login_page.dart';
import 'package:freelance/utils/change_password.dart';
import 'package:iconsax/iconsax.dart';

import 'utils/small_text.dart';

class UserProfile extends StatefulWidget {
  final String userName;
  final String email;
  const UserProfile({super.key, required this.userName, required this.email});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  String? authToken ;
  getAuthToken() async{
    final authToken1 =  await AuthService.getToken();
    setState(() {
      authToken = authToken1;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAuthToken();
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(Iconsax.user, size: 52),
                  ),
                  // SvgPicture.asset("assets/icon/person.svg",height: 100,width: 100,),
                  SizedBox(height: 10),
                  Text(widget.userName, style: TextStyle(fontSize: 25)),
                  Text(widget.email, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 50),
            const Text(" Email", style: TextStyle(fontSize: 12)),
            const SizedBox(height: 10),

            Container(
              height: 56,
              width: 380,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: const Color(0xffD5D4DF)),
              ),
              child: ListTile(
                // leading: Text("+91", style: TextStyle(fontSize: 16),),
                leading: Icon(Icons.email_outlined),
                title: Text(
                  widget.email,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 30),
                titleAlignment: ListTileTitleAlignment.center,
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                // showSnackBar("Feature will be added soon ");
                // Navigator.push(context, MaterialPageRoute(builder: (context)=> ChangePasswordScreen(authToken: authToken!)));
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => ChangePasswordScreen(authToken: authToken!),
                );
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                height: 68,
                width: 380,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(width: 1, color: const Color(0xffD5D4DF)),
                ),
                child: Center(
                  child: ListTile(
                    leading: Container(
                      height: 44,
                      width: 44,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffDCEBED),
                      ),
                      child: const Icon(Iconsax.brush_1),
                    ),
                    title: const Text(
                      "Change Password",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                    titleAlignment: ListTileTitleAlignment.center,
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showBottomLogoutButton(screenHeight, screenWidth);
                },
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  elevation: WidgetStatePropertyAll(3),
                ),
                child: Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        showCloseIcon: true,
        closeIconColor: Colors.white,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showBottomLogoutButton(double screenHeight, double screenWidth, ) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.0486,
              vertical: screenHeight * 0.0224,
            ), //20
            width: double.maxFinite,
            height: screenHeight * 0.3211, //286

            child: Column(
              children: [
                /* ************* Icon STARTS here **************** */
                Container(
                  height: screenHeight * 0.0786, //70,
                  width: screenWidth * 0.17013, //70,
                  margin: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.0135 /*12*/,
                    horizontal: screenWidth * 0.0486 /*20*/,
                  ),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(23, 120, 136, 0.15),
                  ),
                  child: const Icon(Iconsax.information, size: 52),
                ),

                /* ************* Big Exclamation Mark in Circle Ends here **************** */
                SizedBox(height: screenHeight * 0.0056 /*5*/),
                SmallText(
                  text: "Logout",
                  fontSize: screenHeight * 0.0269 /*24*/,
                  fontFamilyName: "Inter",
                  fontWeightName: FontWeight.w700,
                  color: const Color(0xff374151),
                ),
                SizedBox(height: screenHeight * 0.0056 /*5*/),
                const SmallText(
                  text: "Are you sure, you want to logout ?",
                  color: Color(0xff374151),
                  fontWeightName: FontWeight.w500,
                ),
                SizedBox(height: screenHeight * 0.0112 /*10*/),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Button(
                    //   onPress: () {
                    //     Navigator.pop(context);
                    //   },
                    //   text: "No",
                    // ),
                    ElevatedButton(onPressed: () {
                      Navigator.pop(context);
                    }, child: Text("No")),

                    ElevatedButton(onPressed: () async {
                      await AuthService.logout();
                      await AuthService.isLoggedIn(false);
                     logoutUser();
                    }, child: Text("Yes")),
                  ],
                ),
              ],
            ),
          ),
    );
  }
  logoutUser(){
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
    );
  }
}

class Button extends StatelessWidget {
  final VoidCallback onPress;
  final String text;
  final Color textColor, buttonColor;
  final double width;
  final double height;
  const Button({
    super.key,
    required this.onPress,
    required this.text,
    this.textColor = Colors.white,
    this.buttonColor = Colors.white,
    this.width = 147,
    this.height = 44,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: InkWell(
        onTap: onPress,
        child: Container(
          height:
              height == 44
                  ? screenHeight * 0.0494 /*44*/
                  : screenHeight * height / screenHeight,
          width:
              width == 147
                  ? screenWidth * 0.3573
                  : screenWidth * width / screenWidth, //147,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(screenHeight * 0.0561 /*50*/),
          ),
          child: Center(
            child: SmallText(
              text: text,
              color: textColor,
              fontWeightName: FontWeight.w700,
              fontFamilyName: "Inter",
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:calma/utils/colors.dart';
// import 'package:calma/widgets/back_arrow_button.dart';
// import 'package:calma/widgets/button.dart';
// import 'package:calma/widgets/small_text.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';

// class ForgetPasswordScreen extends StatefulWidget {
//   const ForgetPasswordScreen({super.key});
//
//   @override
//   State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
// }
//
// class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
//   TextEditingController phoneNumberController = TextEditingController();
//   TextEditingController forgetPassController = TextEditingController();
//   TextEditingController forgetConfirmPassController = TextEditingController();
//
//   final _formKey = GlobalKey<FormState>();
//   bool isVisible = true;
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.sizeOf(context).height;
//     final screenWidth = MediaQuery.sizeOf(context).width;
//     return Scaffold(
//       // backgroundColor: AppColor.mainBackgroundColor,
//       body: SingleChildScrollView(
//         // physics: const NeverScrollableScrollPhysics(),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               /*******************Back Arrow Button and Logo Of the application STARTS here ******************/
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Padding(
//                   padding: EdgeInsets.only(
//                       top: screenHeight * 0.0562 /*50*/,
//                       left: screenWidth * 0.0486 /*20*/),
//                   child: BackArrowButton(onPress: () {
//                     Navigator.pop(context);
//                   }),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(top: screenHeight * 0.0786 /*70*/),
//                 child: Container(
//                   height: screenHeight * 0.1123, //100,
//                   width: screenWidth * 0.4059, //167,
//                   decoration: const BoxDecoration(
//                       image: DecorationImage(
//                           image: AssetImage("asset/images/calmaLogo.png"))),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(bottom: screenHeight * 0.0112 /*10*/),
//                 child: Text(
//                   "Change Password",
//                   style: TextStyle(
//                     fontFamily: "Inter",
//                     fontWeight: FontWeight.w600,
//                     fontSize: screenHeight * 0.0224, //20
//                     color: const Color(0xff414141),
//                   ),
//                 ),
//               ),
//               /*******************Back Arrow Button Logo of the application ENDS here ******************/
//
//               /// Phone Number fields STARTS HERE
//               Padding(
//                 padding: EdgeInsets.only(
//                   left: screenWidth * 0.0368, //15
//                   right: screenWidth * 0.0368, //15
//                 ),
//                 child: SizedBox(
//                   height: screenHeight * 0.0898, //80
//                   width: double.maxFinite,
//                   child: IntlPhoneField(
//                     controller: phoneNumberController,
//                     cursorColor: AppColor.imageBgColor,
//                     style: TextStyle(fontSize: screenWidth * 0.0387),
//                     dropdownTextStyle: TextStyle(
//                       fontSize: screenWidth * 0.0387,
//                     ),
//                     invalidNumberMessage: "Invalid Phone Number",
//                     dropdownIcon: Icon(
//                       Icons.arrow_drop_down,
//                       size: screenWidth * 0.0583,
//                     ),
//                     validator: (value){
//                       if(phoneNumberController.text.toString().isEmpty){
//                         return "Enter valid phone number";
//                       }
//                       return null;
//                     },
//                     decoration: InputDecoration(
//                       labelText: 'Phone Number',
//                       labelStyle: TextStyle(fontSize: screenWidth * 0.0387),
//                       border: const OutlineInputBorder(
//                         borderSide: BorderSide(),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius:
//                         BorderRadius.circular(screenWidth * 0.0243),
//                         borderSide: BorderSide(
//                           color: AppColor.buttonBackgroundColor,
//                           width: screenWidth * 0.00486,
//                         ),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius:
//                         BorderRadius.circular(screenWidth * 0.0243),
//                         borderSide: BorderSide(
//                           color: AppColor.buttonBackgroundColor,
//                           width: screenWidth * 0.00486,
//                         ),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(screenWidth * 0.0243),
//                         borderSide: BorderSide(
//                           color: Colors.red,
//                           width: screenWidth * 0.00486,
//                         ),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(screenWidth * 0.0243),
//                         borderSide: BorderSide(
//                           color:  Colors.red,
//                           width: screenWidth * 0.00486,
//                         ),
//                       ),
//                     ),
//                     initialCountryCode: 'IN',
//                   ),
//                 ),
//               ),
//
//               /// Phone Number fields ENDS HERE
//
//               /************** Password STARTS here **********************/
//               Padding(
//                 padding: EdgeInsets.only(
//                   left: screenWidth * 0.0368, //15
//                   right: screenWidth * 0.0368, //15
//                   bottom: screenHeight * 0.0225, //20
//                   top: screenHeight * 0.005, //5
//                 ),
//                 child: TextFormField(
//                   controller: forgetPassController,
//                   obscureText: isVisible,
//                   validator: (value){
//                     if(forgetPassController.text.toString().isEmpty){
//                       return "Enter a valid password";
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     hintText: "Password",
//                     prefixIcon: const Icon(Iconsax.lock),
//                     suffixIcon: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           isVisible = !isVisible;
//                         });
//                       },
//                       child: Icon(
//                         isVisible ? Iconsax.eye_slash5 : Iconsax.eye,
//                         color: AppColor.iconColor,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius:
//                       BorderRadius.circular(screenWidth * 0.0243 /*10*/),
//                       borderSide: BorderSide(
//                         color: AppColor.buttonBackgroundColor,
//                         width: screenWidth * 0.00486,
//                       ),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(screenWidth * 0.0243),
//                       borderSide: BorderSide(
//                         color: AppColor.buttonBackgroundColor,
//                         width: screenWidth * 0.00486,
//                       ),
//                     ),
//                     focusedErrorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(screenWidth * 0.0243),
//                       borderSide: BorderSide(
//                         color: Colors.red,
//                         width: screenWidth * 0.00486,
//                       ),
//                     ),
//                     errorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(screenWidth * 0.0243),
//                       borderSide: BorderSide(
//                         color:  Colors.red,
//                         width: screenWidth * 0.00486,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               /************** Password ENDS here **********************/
//
//               /************** Confirm Password STARTS here **********************/
//               PasswordTextField(
//                 text: "Confirm Password",
//                 // fKey: _formKey,
//                 controller: forgetConfirmPassController,
//                 screenWidth: screenWidth,
//                 screenHeight: screenHeight,
//                 verticalPad: screenHeight * 0.0202, //18,
//               ),
//               /************** Confirm Password ENDS here **********************/
//
//               Button(
//                 onPress: () {
//                   if (!_formKey.currentState!.validate()) {
//                     snackBar("Missing required field");
//                   } else {
//                     showDialog(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               Navigator.pushNamedAndRemoveUntil(
//                                   context, '/login-screen', (route) => false);
//                             },
//                             child: Text(
//                               "Return to Login",
//                               style: TextStyle(
//                                 color: AppColor.textColor2,
//                                 fontSize: screenHeight * 0.01774, //18,
//                                 fontFamily: "Inter",
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                         actionsAlignment: MainAxisAlignment.center,
//                         content: const SmallText(
//                           text: "Password has been changed Successfully",
//                           textAlignName: TextAlign.center,
//                         ),
//                         icon: Icon(
//                           Iconsax.tick_circle,
//                           color: Colors.green,
//                           size: screenHeight * 0.0449, //40,
//                         ),
//                       ),
//                     );
//                   }
//                 },
//                 width: screenWidth * 0.4861, //200,
//                 text: "Confirm",
//                 // fontFamily: "Inter",
//                 // fontSize: screenHeight * 0.01774, //18,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   snackBar(String? message) {
//     return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(message!),
//       backgroundColor: Colors.red,
//       duration: const Duration(seconds: 2),
//       dismissDirection: DismissDirection.up,
//     ));
//   }
// }
//
// class PasswordTextField extends StatelessWidget {
//   final double screenHeight, screenWidth, verticalPad;
//   final TextEditingController controller;
//   final String text;
//   final bool isVisible;
//
//   const PasswordTextField({
//     super.key,
//     required this.text,
//     required this.controller,
//     required this.screenWidth,
//     required this.screenHeight,
//     this.verticalPad = 5,
//     this.isVisible = true,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         left: screenWidth * 0.0368, //15
//         right: screenWidth * 0.0368, //15
//         bottom: screenHeight * 0.0225, //20
//         top: screenHeight * 0.005, //5
//       ),
//       child: TextFormField(
//         controller: controller,
//         obscureText: true,
//         cursorColor: AppColor.imageBgColor,
//         validator: (value){
//           if(controller.text.toString().isEmpty){
//             return "Required Field";
//           }
//           return null;
//         },
//         decoration: InputDecoration(
//           hintText: text,
//           prefixIcon: const Icon(Iconsax.lock),
//
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(screenWidth * 0.0243 /*10*/),
//             borderSide: BorderSide(
//               color: AppColor.buttonBackgroundColor,
//               width: screenWidth * 0.00486,
//             ),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(screenWidth * 0.0243),
//             borderSide: BorderSide(
//               color: AppColor.buttonBackgroundColor,
//               width: screenWidth * 0.00486,
//             ),
//           ),
//
//           focusedErrorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(screenWidth * 0.0243),
//             borderSide: BorderSide(
//               color: Colors.red,
//               width: screenWidth * 0.00486,
//             ),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(screenWidth * 0.0243),
//             borderSide: BorderSide(
//               color:  Colors.red,
//               width: screenWidth * 0.00486,
//             ),
//           ),
//           contentPadding: EdgeInsets.symmetric(
//               vertical: verticalPad, horizontal: screenWidth * 0.0243 /*10*/),
//         ),
//       ),
//     );
//   }
// }
//
