import 'dart:async';

import 'package:course_test_task/src/components/chat_messages.dart';
import 'package:course_test_task/src/components/message.dart';
import 'package:course_test_task/src/constants/firabase_database.dart';
import 'package:course_test_task/src/constants/image_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ChatPage extends StatefulWidget {
  final dynamic user;
  final dynamic interlocutor;

  const ChatPage({
    super.key,
    required this.user,
    required this.interlocutor,
  });

  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final StreamController<List<Message>> _messagesController =
      StreamController<List<Message>>.broadcast();

  @override
  void initState() {
    super.initState();

    setState(() {
      _initMessagesStream();
    });
  }

  void _initMessagesStream() {
    String receiverId = widget.interlocutor["id"];
    final messagesRef =
        database.child("/users/${widget.user["id"]}/chat/$receiverId/messages");

    List<Message> messages = [];

    messagesRef.orderByChild("sentTime").onChildAdded.listen((event) {
      var message = Message.fromJson(event.snapshot.value as Map);
      messages.add(message);
      _messagesController.add(List.from(messages));
    });
  }

  Future<void> _sendText(values, receiverId) async {
    final message = Message(
      content: values["message"],
      sendTime: DateTime.now(),
      senderId: widget.user["id"],
      receiverId: receiverId,
    );

    await database
        .child("users/${widget.user["id"]}/chat/$receiverId/messages")
        .push()
        .set(message.toJson());

    await database
        .child("users/$receiverId/chat/${widget.user["id"]}/messages")
        .push()
        .set(message.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.interlocutor["name"]} - : : - last seen 45 minutes ago',
          style: const TextStyle(
            color: Color(0xFF666668),
            fontSize: 15,
            fontFamily: 'Eloquia Text',
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            StreamBuilder<List<Message>>(
              stream: _messagesController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Message> messages = snapshot.data!;
                  return ChatMessages(
                    messages: messages,
                    receiverId: widget.interlocutor["id"],
                    senderName: widget.interlocutor["name"],
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                    child: Container(
                      padding: const EdgeInsets.only(left: 20),
                      alignment: Alignment.center,
                      width: 323,
                      height: 66,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: FormBuilderTextField(
                        name: 'message',
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                            onTap: () async {
                              _formKey.currentState?.save();
                              final values = _formKey.currentState?.value;
                              if (values != null) {
                                _sendText(
                                  values,
                                  widget.interlocutor["id"],
                                );
                              }
                              _formKey.currentState?.reset();
                            },
                            child: Image.asset(Assets.paperAirplane),
                          ),
                          hintText: 'Enter chat id',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messagesController.close();
    super.dispose();
  }
}
