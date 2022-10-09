import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminname;

  const GroupInfo({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.adminname,
  });

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold();
  }
}
