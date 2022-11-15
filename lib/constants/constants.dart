import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

const Color kocialColor = Color.fromRGBO(170, 196, 255, 1);

final _fireStore = FirebaseFirestore.instance;

final usersRef = _fireStore.collection('users');

final followersRef = _fireStore.collection('followers');

final followingRef = _fireStore.collection('following');

final storageRef = FirebaseStorage.instance.ref();

final postsRef = _fireStore.collection('posts');

final feedRefs = _fireStore.collection('feeds');

final likesRefs = _fireStore.collection("likes");

final activitiesRef = _fireStore.collection("activities");