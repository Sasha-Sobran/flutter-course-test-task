import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageCard extends StatelessWidget {
  final Message message;
  final bool isMe;
  final String senderName;

  const MessageCard(
      {Key? key,
      required this.message,
      required this.isMe,
      required this.senderName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.bottomLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width * 0.2,
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : const Color.fromARGB(255, 190, 189, 186),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isMe
                ? const SizedBox(
                    height: 4,
                  )
                : Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      senderName,
                      style: const TextStyle(
                        color: Color(0xFF2C2C2E),
                        fontSize: 14,
                        fontFamily: 'Eloquia Text',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 2, 3, 4),
              child: Text(
                message.content,
                style: TextStyle(color: isMe ? Colors.white : Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: Text(
                _formatTimestamp(message.sendTime),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return DateFormat.Hm().format(timestamp);
  }
}

class Message {
  final String content;
  final String senderId;
  final String receiverId;
  final DateTime sendTime;

  Message(
      {required this.content,
      required this.sendTime,
      required this.senderId,
      required this.receiverId});

  factory Message.fromJson(Map<dynamic, dynamic> json) {
    return Message(
      content: json['content'] as String,
      sendTime: DateTime.parse(json['sendTime'] as String),
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "sendTime": sendTime.toIso8601String(),
      "senderId": senderId,
      "receiverId": receiverId,
    };
  }
}
