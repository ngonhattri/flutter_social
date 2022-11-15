import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  String id;
  String fromUserId;
  Timestamp timeStamp;
  bool follow;

  Activity(
      {required this.id,
      required this.fromUserId,
      required this.timeStamp,
      required this.follow});

  factory Activity.fromDoc(DocumentSnapshot doc) {
    return Activity(
      id: doc.id,
      fromUserId: doc['fromUserId'],
      timeStamp: doc['timeStamp'],
      follow: doc['follow'],
    );
  }
}
