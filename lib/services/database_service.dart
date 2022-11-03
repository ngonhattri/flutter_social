import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_social/constants/constants.dart';
import 'package:flutter_social/models/post.dart';
import 'package:flutter_social/models/user_model.dart';

class DatabaseService {
  static Future<int> followersNum(String userId) async {
    QuerySnapshot followersSnapshot =
        await followersRef.doc(userId).collection('Followers').get();
    return followersSnapshot.docs.length;
  }

  static Future<int> followingNum(String userId) async {
    QuerySnapshot followingSnapshot =
        await followingRef.doc(userId).collection('Following').get();
    return followingSnapshot.docs.length;
  }

  static void updateUserData(UserModel user) {
    usersRef.doc(user.id).update({
      'name': user.name,
      'bio': user.bio,
      'profilePicture': user.profilePicture,
      'coverImage': user.coverImage,
    });
  }

  static Future<QuerySnapshot> searchUsers(String name) async {
    Future<QuerySnapshot> users = usersRef
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThan: '${name}z')
        .get();
    return users;
  }

  static void followUser(String currentUserId, String visitedUserId) {
    followingRef
        .doc(currentUserId)
        .collection('Following')
        .doc(visitedUserId)
        .set({});
    followersRef
        .doc(visitedUserId)
        .collection('Followers')
        .doc(currentUserId)
        .set({});
  }

  static void unFollowUser(String currentUserId, String visitedUserId) {
    followingRef
        .doc(currentUserId)
        .collection('Following')
        .doc(visitedUserId)
        .get()
        .then((doc) => {
              if (doc.exists) {doc.reference.delete()}
            });
    followersRef
        .doc(visitedUserId)
        .collection('Followers')
        .doc(currentUserId)
        .get()
        .then((doc) => {
              if (doc.exists) {doc.reference.delete()}
            });
  }

  static Future<bool> isFollowingUser(String currentUserId, String visitedUserId) async {
    DocumentSnapshot followingDoc = await followersRef.doc(visitedUserId).collection('Followers').doc(currentUserId).get();
    return followingDoc.exists;
  }

  static void createPost(Post post) {
    postsRef.doc(post.auhorId).set({'PostTime': post.timestamp});
    postsRef.doc(post.auhorId).collection('userPosts').add({
      'text': post.text,
      'image': post.image,
      'authorId': post.auhorId,
      'timeStamp': post.timestamp,
      'likes': post.likes,
      'shares': post.shares,
    });
  }

  static Future<List<Post>> getUserPosts(String userId) async {
    QuerySnapshot userPostsSnap = await postsRef
        .doc(userId)
        .collection('userPosts')
        .orderBy('timeStamp', descending: true)
        .get();
    List<Post> userPosts =
        userPostsSnap.docs.map((doc) => Post.fromDoc(doc)).toList();
    return userPosts;
  }
}
