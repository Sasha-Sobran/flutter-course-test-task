import 'package:course_test_task/src/components/message.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatefulWidget {
  final List<dynamic> messages;
  final dynamic receiverId;
  final String senderName;

  const ChatMessages({
    Key? key,
    required this.messages,
    required this.receiverId,
    required this.senderName,
  }) : super(key: key);

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void didUpdateWidget(covariant ChatMessages oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _scrollToBottom();

    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: widget.messages.length,
        itemBuilder: (context, index) {
          final isMe = widget.receiverId != widget.messages[index].senderId;
          return MessageCard(
            message: widget.messages[index],
            isMe: isMe,
            senderName: widget.senderName,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
