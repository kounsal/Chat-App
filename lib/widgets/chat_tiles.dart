import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  const MessageTile({
    super.key,
    required this.message,
    required this.sentByMe,
    required this.sender,
  });

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          widget.sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.sentByMe ? Colors.green : Colors.redAccent,
          ),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                Text(
                  widget.sender,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.end,
                ),
                Text(
                  widget.message,
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}
