import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  Messages({Key? key}) : super(key: key);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var useId;
  Future getCurrentUser() async {
    final User user = _auth.currentUser!;
    final uid = user.uid;
    useId = uid;
    // print(uid);
    return uid.toString();
  }

  @override
  build(BuildContext context) {
    getCurrentUser();
    return FutureBuilder(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt', descending: true).snapshots(),
          builder: (context, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = chatSnapshot.data?.docs;
            // log(chatDocs.toString());
            return ListView.builder(
              reverse: true,
              itemCount: chatDocs?.length,
              itemBuilder: (context, index) => MessageBubble(
                chatDocs?[index]['text'],
                chatDocs?[index]['username'],
                chatDocs?[index]['userImage'],
                chatDocs?[index]['userId'] == useId,
                chatDocs?[index]['createdAt'],
              ),
            );
          },
        );
      },
    );
  }
}
