import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_social/constants/constants.dart';
import 'package:flutter_social/models/activity_model.dart';
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

    addActivity(currentUserId, null, true, visitedUserId);
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

  static Future<bool> isFollowingUser(
      String currentUserId, String visitedUserId) async {
    DocumentSnapshot followingDoc = await followersRef
        .doc(visitedUserId)
        .collection('Followers')
        .doc(currentUserId)
        .get();
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
    }).then((doc) async {
      QuerySnapshot followerSnapshot =
          await followersRef.doc(post.auhorId).collection('Followers').get();
      for (var docSnapshot in followerSnapshot.docs) {
        feedRefs.doc(docSnapshot.id).collection('userFeed').doc(doc.id).set({
          'text': post.text,
          'image': post.image,
          "authorId": post.auhorId,
          "timeStamp": post.timestamp,
          'likes': post.likes,
          'shares': post.shares,
        });
      }
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

  static Future<List<Post>> getHomePosts(String currentUserId) async {
    QuerySnapshot homePosts = await feedRefs
        .doc(currentUserId)
        .collection('userFeed')
        .orderBy('timeStamp', descending: true)
        .get();

    List<Post> followingPosts =
        homePosts.docs.map((doc) => Post.fromDoc(doc)).toList();
    return followingPosts;
  }

  static void likePost(String currentUserId, Post post) {
    DocumentReference postDocProfile =
        postsRef.doc(post.auhorId).collection("userPosts").doc(post.id);
    postDocProfile.get().then((doc) {
      int likes = (doc.data() as Map<String,dynamic>)['likes'];
      postDocProfile.update({'likes': likes + 1});
    });

    DocumentReference postDocFeed =
        feedRefs.doc(currentUserId).collection("userFeed").doc(post.id);
    postDocFeed.get().then((doc) {
      if (doc.exists) {
        int likes = (doc.data() as Map<String,dynamic>)["likes"];
        postDocFeed.update({'likes': likes + 1});
      }
    });

    likesRefs
        .doc(post.id)
        .collection('postLikes')
        .doc(currentUserId)
        .get()
        .then((doc) => doc.reference.set({}));

    addActivity(currentUserId, post, false, null);
  }

  static void unLikePost(String currentUserId, Post post) {
    DocumentReference postDocProfile =
        postsRef.doc(post.auhorId).collection("userPosts").doc(post.id);
    postDocProfile.get().then((doc) {
      int likes = (doc.data() as Map<String,dynamic>)['likes'];
      postDocProfile.update({'likes': likes - 1});
    });

    DocumentReference postDocFeed =
        feedRefs.doc(currentUserId).collection("userFeed").doc(post.id);
    postDocFeed.get().then((doc) {
      if (doc.exists) {
        int likes = (doc.data() as Map<String,dynamic>)["likes"];
        postDocFeed.update({'likes': likes - 1});
      }
    });

    likesRefs
        .doc(post.id)
        .collection('postLikes')
        .doc(currentUserId)
        .get()
        .then((doc) => doc.reference.delete());
  }

  static Future<bool> isLikePost(String currentUserId, Post post) async {
    DocumentSnapshot userDoc = await likesRefs
        .doc(post.id)
        .collection("postLikes")
        .doc(currentUserId)
        .get();
    return userDoc.exists;
  }

  static Future<List<Activity>> getActivities(String userId) async {
    QuerySnapshot userActivitiesSnapshot = await activitiesRef
        .doc(userId)
        .collection('userActivities')
        .orderBy('timeStamp', descending: true)
        .get();

    List<Activity> activities = userActivitiesSnapshot.docs
        .map((doc) => Activity.fromDoc(doc))
        .toList();

    return activities;
  }

  static void addActivity(
      String currentUserId, Post? post, bool follow, String? followedUserId) {
    if (follow) {
      activitiesRef.doc(followedUserId).collection('userActivities').add({
        'fromUserId': currentUserId,
        'timeStamp': Timestamp.fromDate(DateTime.now()),
        "follow": true,
      });
    } else {
      //like
      activitiesRef.doc(post!.auhorId).collection('userActivities').add({
        'fromUserId': currentUserId,
        'timeStamp': Timestamp.fromDate(DateTime.now()),
        "follow": false,
      });
    }
  }
}
