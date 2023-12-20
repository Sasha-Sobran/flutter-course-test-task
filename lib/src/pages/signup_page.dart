import 'dart:async';

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
    DatabaseEvent event = await database.child("/users/${user["id"]}/name").once();
    Map<dynamic, dynamic>? data = event.snapshot.value as Map?;

    if (data != null) {
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
          title: Text(success
              ? "You are successfully signed up. Now you can login."
              : "ID already exists. Please choose a different ID."),
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
                        decoration: const InputDecoration(
                          hintText: 'Enter chat id',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
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
                        name: 'name',
                        decoration: const InputDecoration(
                          hintText: 'Enter name',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
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
                    child: const Text('Sign up'),
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
