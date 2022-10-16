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
    return Container(
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: widget.sentByMe ? 0 : 0,
          right: widget.sentByMe ? 0 : 0),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sentByMe
            ? const EdgeInsets.only(left: 20)
            : const EdgeInsets.only(right: 20),
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: widget.sentByMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                ),
          color: widget.sentByMe
              ? const Color.fromARGB(255, 121, 247, 180)
              : const Color.fromARGB(247, 247, 121, 125),
        ),
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
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
