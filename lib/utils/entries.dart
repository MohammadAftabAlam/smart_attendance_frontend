import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';

class Entries extends StatelessWidget {
  final String headingText, assetName;
  final Color rightContainerColor, dateColor;
  final List<dynamic> entriesPresent;
  const Entries({
    super.key,
    required this.headingText,
    required this.rightContainerColor,
    required this.assetName,
    required this.entriesPresent,
    this.dateColor = const Color(0xff787476),
  });

  List<Map<String, dynamic>> formatAttendanceData(List<dynamic> records) {
    return records.map<Map<String, dynamic>>((record) {
      // 1. Get the date string
      final dateString = record['date'].toString();

      // 2. Extract date part using substring
      final simpleDate = dateString.substring(0, 10); // Gets "2025-04-24"

      // 3. Optionally format further (remove dashes)
      final cleanDate = simpleDate.replaceAll('-', '/'); // "2025/04/24"

      return {
        ...record as Map<String, dynamic>,
        'simpleDate': simpleDate,    // "2025-04-24"
        'cleanDate': cleanDate,      // "2025/04/24"
        'formattedDate': _formatWithSubstring(dateString), // Custom format
      };
    }).toList();
  }

  String _formatWithSubstring(String isoDate) {
    // Example: "2025-04-24T14:30:00Z" → "Apr 24, 2025"
    final year = isoDate.substring(0, 4);
    final month = _getMonthName(isoDate.substring(5, 7));
    final day = isoDate.substring(8, 10);
    return '$month $day, $year';
  }

  String _getMonthName(String monthNum) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[int.parse(monthNum) - 1];
  }

  @override
  Widget build(BuildContext context) {
    final formattedData = formatAttendanceData(entriesPresent);
    return Scaffold(
      appBar: AppBar(title: Text(headingText)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search by date (dd/MM/yyyy)',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Recent Entries Card
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE4D9CC),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          headingText,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Icon(Icons.remove, size: 20),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Inner white container
                    Container(
                      height: 450,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 8,
                      ),

                      // Showing Entries of Absent and present details
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              entriesPresent.isEmpty
                                  ? [
                                    SizedBox(height: 450/2 - 80,),
                                    Icon(
                                      Iconsax.emoji_sad,
                                      size: 100,
                                      color: Colors.grey.shade400,
                                    ),
                                    Center(child: Text("Nothing to show")),
                                  ]
                                  : List.generate(entriesPresent.length, (
                                    index,
                                  ) {

                                    return buildEntryRow(
                                      index + 1,
                                      formattedData[index]['formattedDate'].toString(),
                                      rightContainerColor,
                                      dateColor,
                                      assetName,
                                    );
                                  }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // const Spacer(),
              const SizedBox(height: 20),

              ShowConvention(
                color: const Color(0xFFC6D9C9),
                dotColor: rightContainerColor,
                text: "Present",
                textColor: const Color(0xff816D67),
                imagePath: "assets/icon/dots.png",
                assetName: "assets/icon/tick_ent.svg",
              ),
              const SizedBox(height: 20),
              ShowConvention(
                color: const Color(0xffEF8179),
                dotColor: rightContainerColor,
                text: "Absent",
                imagePath: "assets/icon/dots_red.png",
                assetName: "assets/icon/cross-ent.svg",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEntryRow(
    int number,
    String date,
    Color color,
    Color dateColor,
    String assetName,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Row(
              children: [
                // Right Container for numbering
                Container(
                  width: 33,
                  height: 33,
                  // margin: EdgeInsets.only(left: 24),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xffEAECEE),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff7F6B67),
                    ),
                  ),
                ),
                const SizedBox(width: 20),

                // Showing Date
                Text(date, style: TextStyle(fontSize: 16, color: dateColor)),
                const Spacer(),

                // Right Container
                Container(
                  width: 30,
                  height: 30,
                  // margin: EdgeInsets.only(right: 24),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(assetName),
                ),
              ],
            ),
            const Divider(thickness: 1, height: 3, color: Color(0xffFAFAFB)),
          ],
        ),
      ),
    );
  }
}

class ShowConvention extends StatelessWidget {
  final Color dotColor, color, textColor;
  final String text, imagePath, assetName;
  const ShowConvention({
    super.key,
    required this.dotColor,
    required this.color,
    required this.text,
    this.textColor = Colors.white,
    required this.imagePath,
    required this.assetName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Present Button
        Container(
          height: 65,
          width: 65,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
            // borderRadius: BorderRadius.circular(30),
          ),
          child: Image(image: AssetImage(imagePath)),
        ),

        // Container to show Absent and present
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
          ),
          child: SizedBox(
            width: 260,
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 21,
                    color: textColor,
                  ),
                ),
                SizedBox(
                  height: 26,
                  width: 26,
                  child: SvgPicture.asset(assetName),
                ),
              ],
            ),
          ),
        ),

        // Absent Button
        // Container(
        //   padding:
        //   const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        //   decoration: BoxDecoration(
        //     color: const Color(0xFFF09388),
        //     borderRadius: BorderRadius.circular(30),
        //   ),
        //   child: const Row(
        //     children: [
        //       Icon(Icons.fiber_manual_record, size: 16),
        //       SizedBox(width: 8),
        //       Text("Absent"),
        //       SizedBox(width: 8),
        //       Icon(Icons.cancel, size: 18),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
