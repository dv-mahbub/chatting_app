import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final Alignment alignment;
  const ChatBubble({super.key, required this.message, required this.alignment});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.alignment== Alignment.centerRight? CupertinoColors.systemGrey4: Colors.blue,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Text(
          widget.message,
          style: TextStyle(
              fontSize: 17,
              color:
              widget.alignment==Alignment.centerRight
              ?Colors.black
              :Colors.white,
          ),
          maxLines: null,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
