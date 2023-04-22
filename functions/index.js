const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp(functions.config().firebase);

exports.myFunction = functions.firestore.document("chat/{message}")
    .onCreate((snapshot, context) => {
      console.log("Push notification event triggered");

      console.log(snapshot.data());
      console.log(snapshot);
      const payload = {
        topic: "chat",
        notification: {
          title: snapshot.data().username,
          body: snapshot.data().text,
        },
        data: {
          body: "message",
        },
      };
      admin.messaging().send(payload).then((response) => {
        console.log("Successfully sent message:", response);
        return {success: true};
      }).catch((error) => {
        return {error: error.code};
      });
    });
