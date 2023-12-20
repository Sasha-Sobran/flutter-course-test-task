import 'dart:async';

import 'package:course_test_task/src/components/custom_text_field.dart';
import 'package:course_test_task/src/constants/firabase_database.dart';
import 'package:course_test_task/src/constants/text_constants.dart';
import 'package:course_test_task/src/pages/login_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  Future<bool> registerUser(user) async {
    DatabaseEvent event = await database.child("/users/${user["id"]}").once();
    Map<dynamic, dynamic>? data = event.snapshot.value as Map?;

    if (data != null && data.containsKey('id')) {
      return false;
    } else {
      await database.child("/users/${user["id"]}/name").set(user["name"]);
      return true;
    }
  }

  void showResultDialog(BuildContext context, bool success) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(success ? S.successMessage : S.errorMessage),
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
              S.signup,
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
                  const CustomTextField(name: 'id', hintText: S.enterChatId),
                  const CustomTextField(name: 'name', hintText: S.enterName),
                  MaterialButton(
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () async {
                      _formKey.currentState?.save();
                      final values = _formKey.currentState?.value;

                      if (values != null) {
                        bool success = await registerUser(values);
                        showResultDialog(context, success);
                      }
                    },
                    child: const Text(S.signUpButton),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  S.register,
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
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    S.logIn,
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
