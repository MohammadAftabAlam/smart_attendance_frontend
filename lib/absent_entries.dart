import 'package:flutter/material.dart';
import 'package:freelance/utils/entries.dart';

class AbsentEntries extends StatefulWidget {
  final List absentEntries;
  const AbsentEntries({super.key, required this.absentEntries});

  @override
  State<AbsentEntries> createState() => _AbsentEntriesState();
}

class _AbsentEntriesState extends State<AbsentEntries> {

  // List<dynamic> presentEntriesDynamic = getEntriesFromApi(); // dynamic list
  @override
  Widget build(BuildContext context) {
  // List<String> absentEntries = widget.absentEntries.map((e) => e.toString()).toList();

    return Entries(
        headingText: "Absent Entries",
        rightContainerColor: Color(0xffEF8179),
        dateColor: Color(0xffEF8179),
        assetName: "assets/icon/cross-ent.svg",
      entriesPresent: widget.absentEntries,
    );
  }
}
