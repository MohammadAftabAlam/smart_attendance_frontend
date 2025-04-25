import 'package:flutter/material.dart';

class ReceivedMessages extends StatefulWidget {
  const ReceivedMessages({super.key});

  @override
  State<ReceivedMessages> createState() => _ReceivedMessagesState();
}

class _ReceivedMessagesState extends State<ReceivedMessages> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true,),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Cute empty inbox illustration
            Image.asset(
              'assets/images/chat.png', // Add a cute SVG or PNG of empty inbox
              height: 200,
            ),
            const SizedBox(height: 20),
            const Text(
              "You're all caught up!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0051FF), // Your theme blue
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "No messages received yet.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}