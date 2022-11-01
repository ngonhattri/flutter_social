import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? id;
  String auhorId;
  String text;
  String image;
  Timestamp timestamp;
  int likes;
  int shares;

  Post({
    this.id,
    required this.auhorId,
    required this.text,
    required this.image,
    required this.timestamp,
    required this.likes,
    required this.shares,
  });

  factory Post.fromDoc(DocumentSnapshot doc) {
    return Post(
      id: doc.id,
      auhorId: doc['authorId'],
      text: doc['text'],
      image: doc['image'],
      timestamp: doc['timeStamp'],
      likes: doc['likes'],
      shares: doc['shares'],
    );
  }
}
