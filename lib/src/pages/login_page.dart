import 'package:course_test_task/src/components/custom_text_field.dart';
import 'package:course_test_task/src/constants/firabase_database.dart';
import 'package:course_test_task/src/constants/text_constants.dart';
import 'package:course_test_task/src/pages/home_page.dart';
import 'package:course_test_task/src/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  Future<Map> logInUser(values) async {
    final event = await database.child("/users/${values["id"]}/name").once();
    final username = event.snapshot.value;
    Map<String, dynamic> matchingUser = {
      "id": values["id"],
      "name": username,
    };

    Map<dynamic, dynamic> result = {
      "user": matchingUser,
      "isUserExists": matchingUser["name"] != null
    };
    return result;
  }

  void showResultDialog(BuildContext context, bool success, user) {
    success
        ? Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(user: user)),
          )
        : showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text("Account with such id doesnt exists"),
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              S.login,
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  const CustomTextField(name: "id", hintText: S.enterChatId),
                  MaterialButton(
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () async {
                      _formKey.currentState?.save();
                      final values = _formKey.currentState?.value;

                      if (values != null) {
                        logInUser(values).then((value) {
                          var success = value["isUserExists"];
                          var user = value["user"];
                          showResultDialog(context, success, user);
                        });
                      }
                    },
                    child: const Text('Log in'),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  S.loginer,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  },
                  child: const Text(
                    S.signUp,
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
