import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isloading = false;

  // AlertDialog alert = AlertDialog(
  //   // context: context,
  //   title: Text("My title"),
  //   content: Text("This is my message."),
  //   actions: [
  //     TextButton(
  //       child: Text("OK"),
  //       onPressed: () {
  //         // Navigator.pop();
  //       },
  //     ),
  //   ],
  // );

  void _submitAuthForm(String email, String password, String username, bool isLogin, [File? image]) async {
    UserCredential authResult;
    try {
      setState(() {
        _isloading = true;
      });
      if (isLogin) {
        log(email);
        log(password);
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        log(authResult.toString());
      } else {
        log(email);
        log(password);
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        log(authResult.toString());
      }

      // image uploade
      //create the puth
      final ref = FirebaseStorage.instance.ref().child('user_image').child('${authResult.user?.uid}.jpeg');
      //add image
      await ref.putFile(image!);

      final url = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(authResult.user!.uid).set({
        'username': username,
        'email': email,
        'image_url': url,
      });

      setState(() {
        _isloading = false;
      });
    } catch (e) {
      log(e.toString());
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
          child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: AuthForm(_submitAuthForm, _isloading),
        )),
      )),
    );
  }
}
