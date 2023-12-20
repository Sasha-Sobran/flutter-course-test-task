import 'package:course_test_task/src/constants/firabase_database.dart';
import 'package:course_test_task/src/constants/image_constants.dart';
import 'package:course_test_task/src/constants/text_constants.dart';
import 'package:course_test_task/src/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class HomePage extends StatelessWidget {
  final dynamic user;
  HomePage({super.key, required this.user});

  Future<Map<String, dynamic>> toChat(values) async {
    final receiver = await getReceiver(values);
    if (receiver != null) {
      final chat = await getChat(values);
      if (chat == null) {
        await createChat(values);
      }
      return {
        "success": true,
        "interlocutor": {"name": receiver, "id": values["id"]},
      };
    } else {
      return {"success": false};
    }
  }

  Future<String?> getReceiver(values) async {
    final event1 = await database.child("/users/${values["id"]}/name").once();
    return event1.snapshot.value as String?;
  }

  Future<dynamic> getChat(values) async {
    final event2 = await database
        .child("/users/${user["id"]}/chat/${values["id"]}")
        .once();
    return event2.snapshot.value;
  }

  Future<void> createChat(values) async {
    await database.child("/users/${user["id"]}/chat").set("${values["id"]}");
  }

  final _formKey = GlobalKey<FormBuilderState>();

  void showResultDialog(
      BuildContext context, bool success, interlocutor) async {
    success
        ? Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                user: user,
                interlocutor: interlocutor,
              ),
            ))
        : showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text(S.errorMessage),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text("Ok"),
                  ),
                ],
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              S.chatApp,
              style: TextStyle(
                color: Colors.black,
                fontSize: 40,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: 216,
                  height: 213,
                  decoration: ShapeDecoration(
                    image: const DecorationImage(
                      image: AssetImage(Assets.avatar),
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                ),
                Text(
                  "ID: ${user["id"]}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                children: [
                  Text(
                    user["name"],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  Container(
                    width: 247.01,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                        ),
                      ),
                    ),
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
                              name: 'id',
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: () async {
                                    _formKey.currentState?.save();
                                    final values = _formKey.currentState?.value;
                                    if (values != null) {
                                      toChat(values).then((value) {
                                        var success = value["success"];
                                        var interlocutor =
                                            value["interlocutor"];
                                        showResultDialog(
                                            context, success, interlocutor);
                                      });
                                    }
                                  },
                                  child: Image.asset(Assets.paperAirplane),
                                ),
                                hintText: S.enterChatId,
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
          ],
        ),
      ),
    );
  }
}
