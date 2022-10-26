import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

const Color kocialColor = Color.fromRGBO(170, 196, 255, 1);

final _fireStore = FirebaseFirestore.instance;

final usersRef = _fireStore.collection('users');

final followersRef = _fireStore.collection('followers');

final followingRef = _fireStore.collection('following');
