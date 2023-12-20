import 'package:course_test_task/src/components/message.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  final List<dynamic> messages;
  final dynamic receiverId;
  final String senderName;

  const ChatMessages(
      {super.key,
      required this.messages,
      required this.receiverId,
      required this.senderName});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (content, index) {
            final isMe = receiverId != messages[index].senderId;
            return MessageCard(
              message: messages[index],
              isMe: isMe,
              senderName: senderName,
            );
          }),
    );
  }
}
