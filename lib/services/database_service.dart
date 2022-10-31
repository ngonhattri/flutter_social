import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_social/constants/constants.dart';
import 'package:flutter_social/models/post.dart';
import 'package:flutter_social/models/user_model.dart';

class DatabaseService {
  static Future<int> followersNum(String userId) async {
    QuerySnapshot followersSnapshot =
        await followersRef.doc(userId).collection('userFollowers').get();
    return followersSnapshot.docs.length;
  }

  static Future<int> followingNum(String userId) async {
    QuerySnapshot followingSnapshot =
        await followingRef.doc(userId).collection('userFollowing').get();
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

  static void createPost(Post post) {
    postsRef.doc(post.auhorId).set({'PostTime':post.timestamp});
    postsRef.doc(post.auhorId).collection('userPosts').add({
      'text': post.text,
      'image': post.image,
      'authorId': post.auhorId,
      'timeStamp': post.timestamp,
      'likes': post.likes,
      'shares': post.shares,
    });
  }
}
