import 'package:flutter/material.dart';
import 'package:freelance/utils/entries.dart';

class RecentEntries extends StatefulWidget {
  final List<dynamic> recentEntries;
  const RecentEntries({super.key, required this.recentEntries});

  @override
  State<RecentEntries> createState() => _RecentEntriesState();
}


class _RecentEntriesState extends State<RecentEntries> {
  @override
  Widget build(BuildContext context) {
    // List presentEntries

    return Entries(
        headingText: "Present Entries",
        rightContainerColor: Color(0xffCEDED2),
        assetName: "assets/icon/tick_ent.svg",
      entriesPresent: widget.recentEntries,
    );
  }
}
