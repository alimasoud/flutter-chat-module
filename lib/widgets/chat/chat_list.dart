import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/widgets/chat/message_bubble.dart';

class ChatList extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var useId;
  var userEmail;
  Future getCurrentUser() async {
    final User user = _auth.currentUser!;
    final uid = user.uid;
    useId = uid;
    userEmail = user.email;
    return uid.toString();
  }

  @override
  Widget build(BuildContext context) {
    getCurrentUser();
    final Stream<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collection('users').where('email', isNotEqualTo: userEmail).snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final data = snapshot.data?.docs;
        return ListView.builder(
          itemCount: data?.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(data?[index]['username']),
            subtitle: Text(data?[index]['email']),
            onTap: () {},
          ),
        );
      },
    );
  }
}
