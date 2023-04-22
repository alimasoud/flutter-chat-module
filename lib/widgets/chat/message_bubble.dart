import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
    this.message,
    this.username,
    this.userImage,
    this.isMe,
    this.timeStamp,
  );
  final String message;
  final String username;
  final String userImage;
  final Timestamp timeStamp;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    var time = DateFormat('hh:mm a').format(timeStamp.toDate());
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : Colors.purple,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: !isMe ? const Radius.circular(0) : const Radius.circular(12),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              // width: 140,
              constraints: BoxConstraints(minWidth: 100, maxWidth: 300),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 13,
                horizontal: 6,
              ),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.start : CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isMe ? Colors.black : Colors.white,
                        ),
                      ),
                      Text(
                        message,
                        style: TextStyle(color: isMe ? Colors.black : Colors.white),
                        // textAlign: isMe ? TextAlign.end : TextAlign.start,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        time,
                        style: TextStyle(color: isMe ? Colors.black : Colors.white, fontSize: 10),
                        // textAlign: isMe ? TextAlign.start : TextAlign.end,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        // Positioned(
        //   top: 0,
        //   left: isMe ? null : 120,
        //   right: isMe ? 120 : null,
        //   child: CircleAvatar(
        //     backgroundImage: NetworkImage(userImage),
        //   ),
        // )
      ],
    );
  }
}
