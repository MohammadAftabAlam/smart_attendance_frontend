import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freelance/controllers/attendanceController.dart';
import 'package:iconsax/iconsax.dart';
import 'package:location/location.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:freelance/absent_entries.dart';
import 'package:freelance/present_entries.dart';
import 'package:freelance/profile.dart';
import 'package:freelance/received_messages.dart';

import 'controllers/auth.dart';
import 'utils/qr_code_scanner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController();
  StreamSubscription<Object?>? _subscription;
  bool isScanned = false;
  DateTime? date;
  Location? userLocation;
  double? userLatitude;
  double? userLongitude;

  String? userName;
  String? email;

  // Latitude and Longitude of Women's polytechnic, AMU
  double? clgLatitude = 27.9150;
  double? clgLongitude = 78.0788;


  @override
  void initState() {
    super.initState();
    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Start listening to the barcode events.
    _subscription = controller.barcodes.listen(_handleBarcode);

     _getUserLocation();
    // Finally, start the scanner itself.
    // unawaited(controller.start());
  }



  @override
  Future<void> dispose() async {
    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    // Stop listening to the barcode events.
    unawaited(_subscription?.cancel());
    _subscription = null;
    // Dispose the widget itself.
    super.dispose();
    // Finally, dispose of the controller.
    await controller.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    if (!controller.value.hasCameraPermission) {
      return;
    }
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
      // Restart the scanner when the app is resumed.
      // Don't forget to resume listening to the barcode events.
        _subscription = controller.barcodes.listen(_handleBarcode);

        unawaited(controller.start());
      case AppLifecycleState.inactive:
      // Stop the scanner when the app is paused.
      // Also stop the barcode events subscription.
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }


  _getUserLocation() async{
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        location.requestPermission();
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    userLatitude = locationData.latitude ;
    userLongitude = locationData.longitude ;
    return locationData;
  }


  // bool _checkDateTime(DateTime currentDate){
  //   date = DateTime.now();
  //   if((currentDate.day == date!.day) &&(date!.hour >= 9 && date!.hour <= 17) && (date!.weekday >= 1 && date!.weekday <= 5)){
  //     return true;
  //   }
  //   return false;
  // }

  bool _checkLocation(){
    double latitudeDif = userLatitude! - clgLatitude!;
    double longitudeDif = userLongitude! - clgLongitude!;
    if(latitudeDif <= 0.2 && longitudeDif <= 0.2){
      return true;
    }
    return false;
  }


void showDialogBox(String title, String subTitle, IconData icon, Color iconColor){

  showDialog(context: context, builder: (context) => AlertDialog(
    title: Text(title),
    content: Text(subTitle),
    icon: Icon(icon, size: 48, color: iconColor,),
  ));
}

  void _openQrScanner(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QrCodeScanner()),
    );


    bool loc =  _checkLocation();
    debugPrint(loc.toString());

    if(!loc){
      showDialogBox("Qr scanned some where else","Location doesn't match. Please scan QR inside the college premises", Iconsax.cloud_cross, Colors.red);
    }
    else if (loc && result != null) {
      try{
        await AttendanceController().markAsPresent();
        showSnackBar("Attendance Marked", Colors.green);
      }catch(e){
        showSnackBar("Attendance already marked: $e", Colors.red);
      }
      // showDialogBox(result, "Your Attendance has been marked",Iconsax.tick_circle, Colors.green);
    }

    if (result == null) {
      showDialogBox("Attendance not Marked", "Something went wrong",Iconsax.shield_cross, Colors.red);
    }
  }

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

  Future<List<dynamic>> getAttendanceList() async{
    final attendanceController = AttendanceController();
    try{
      final data =  await attendanceController.fetchAttendance();
      return data;
    }catch(e){
      // print(e.toString());
    }
    return [];
  }

  void navigateToRecentEntries(List attendanceList){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  RecentEntries(recentEntries: attendanceList,),
      ),
    );
  }
  void navigateToAbsentEntries(List absentList){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AbsentEntries(absentEntries: absentList,),
      ),
    );
  }

  _getUserNameAndEmail()async{
    userName = await AuthService.getUserName();
    email = await AuthService.getUserEmail();
  }

  navigateToProfile(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfile(userName: userName!, email: email!,),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffF3F4EE),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
            onTap: () async {
              await _getUserNameAndEmail();
             navigateToProfile();
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              child: const Icon(Icons.person),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Smart \nEntry",
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 48),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Present Entries
                  ContainerTraits(
                    color: const Color(0xffB7D4BA),
                    iconWidget: SvgPicture.asset("assets/icon/correct.svg"),
                    text: "Attentive Details",
                    onTap: () async{
                      final attendanceList= await getAttendanceList();
                      navigateToRecentEntries(attendanceList);
                    },
                  ),

                  /// Absent Entries
                  ContainerTraits(
                    color: const Color(0xffDAA7A0),
                    iconWidget: SvgPicture.asset("assets/icon/cross.svg"),
                    text: "Non Attentive Details",
                    onTap: () {
                      navigateToAbsentEntries([]);
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: ContainerTraits(
                  color: const Color(0xffC1DBD8),
                  width: 310,
                  iconWidget: const Image(
                    image: AssetImage("assets/icon/message.png"),
                    height: 50,
                    width: 50,
                  ),
                  text: "Received Messages",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReceivedMessages(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 60,
              ),

              // Tap to scan widget starts here

              InkWell(
                onTap: () {
                  _openQrScanner(context);
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>QrCodeScanner()));
                },
                borderRadius: BorderRadius.circular(44),
                child: Container(
                  height: 83,
                  width: 372,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(64),
                      color: const Color(0xff0E484A)),
                  child: Center(
                    child: ListTile(
                      leading: Container(
                        height: 47,
                        width: 47,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9.25)),
                        child: const Image(
                          image: AssetImage("assets/icon/qr.png"),
                        ),
                      ),
                      title: const Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          "Tap to scan",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Inter",
                              color: Colors.white),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _handleBarcode(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;

    if (barcodes.isNotEmpty) {
      final Barcode barcode = barcodes.first;
      final String? rawValue = barcode.rawValue;

      if (rawValue != null) {
        debugPrint("Scanned QR Code Data: $rawValue");

        // Example: you can navigate or show dialog here
        // Navigator.of(context).pop(rawValue);
      }
    }
  }

  // void _handleBarcode(BarcodeCapture capture) async {
  //   final barcode = capture.barcodes.first;
  //   final qrData = barcode.rawValue;
  //
  //   if (qrData != null && !isScanned) {
  //     isScanned = true;
  //
  //     try {
  //       Position position = await _getCurrentLocation();
  //       bool verified = isAtCollege(position);
  //
  //       if (verified) {
  //         Navigator.pop(context, {
  //           'status': 'Present',
  //           'qrData': qrData,
  //           'location': position
  //         });
  //       } else {
  //         Navigator.pop(context, {
  //           'status': 'Invalid Location',
  //           'qrData': qrData,
  //         });
  //       }
  //     } catch (e) {
  //       Navigator.pop(context, {
  //         'status': 'Location Error',
  //         'error': e.toString(),
  //       });
  //     }
  //   }
  // }

}

class ContainerTraits extends StatelessWidget {
  final double width;
  final Color color;
  final Widget iconWidget;
  final String text;
  final VoidCallback onTap;
  const ContainerTraits(
      {super.key,
      required this.color,
      this.width = 170,
      required this.iconWidget,
      required this.text,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(35),
      child: Container(
        height: 168,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(46), color: color),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [iconWidget, SizedBox(height: 10,),Text(text)],
        ),
      ),
    );
  }
}
