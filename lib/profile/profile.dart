import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social/authentication/controller/authentication_controller.dart';
import 'package:flutter_social/constants/constants.dart';
import 'package:flutter_social/models/user_model.dart';
import 'package:flutter_social/profile/edit_profile_screen.dart';
import 'package:flutter_social/services/database_service.dart';
import 'package:flutter_social/widgets/post_container.dart';

import '../models/post.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String currentUserId;
  final String visitedUserId;

  const ProfileScreen({
    Key? key,
    required this.currentUserId,
    required this.visitedUserId,
  }) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  int _followersCount = 0;
  int _followingCount = 0;
  List<Post> _allPosts = [];
  List<Post> _mediaPosts = [];

  int _profileSegmentedValue = 0;
  Map<int, Widget> _profileTabs = <int, Widget>{
    0: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Posts',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    ),
    1: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Media',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    ),
    2: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Likes',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    ),
  };

  Widget BuildProfileWidgets(UserModel author) {
    switch (_profileSegmentedValue) {
      case 0:
        return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _allPosts.length,
            itemBuilder: (context, index) {
              return PostContainer(
                post: _allPosts[index],
                author: author,
              );
            });
      case 1:
        return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _mediaPosts.length,
            itemBuilder: (context, index) {
              return PostContainer(
                post: _mediaPosts[index],
                author: author,
              );
            });
      case 2:
        return Center(child: Text('Likes', style: TextStyle(fontSize: 25)));

      default:
        return Center(
            child: Text('Something wrong', style: TextStyle(fontSize: 25)));
    }
  }

  getFollowersCount() async {
    int followersCount =
        await DatabaseService.followersNum(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _followersCount = followersCount;
      });
    }
  }

  getFollowingCount() async {
    int followingCount =
        await DatabaseService.followersNum(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _followingCount = followingCount;
      });
    }
  }

  getAllPosts() async {
    List<Post> userPosts = await DatabaseService.getUserPosts(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _allPosts = userPosts;
        _mediaPosts =
            _allPosts.where((element) => element.image.isNotEmpty).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getFollowersCount();
    getFollowingCount();
    getAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    final authController = ref.read(authProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: usersRef.doc(widget.visitedUserId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(kocialColor),
              ),
            );
          }
          UserModel userModel = UserModel.fromDoc(snapshot.data);
          return ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: kocialColor,
                  image: userModel.coverImage.isEmpty
                      ? null
                      : DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(userModel.coverImage),
                        ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox.shrink(),
                      PopupMenuButton(
                        icon: Icon(
                          Icons.more_horiz,
                          color: Colors.black,
                        ),
                        itemBuilder: (_) {
                          return <PopupMenuItem<String>>[
                            new PopupMenuItem(
                              child: Text('Logout'),
                              value: 'logout',
                            )
                          ];
                        },
                        onSelected: (selectedItem) {},
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: userModel.profilePicture.isEmpty
                              ? null
                              : NetworkImage(userModel.profilePicture),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(
                                  user: userModel,
                                ),
                              ),
                            );
                            setState(() {});
                          },
                          child: Container(
                            width: 100,
                            height: 35,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              border: Border.all(color: kocialColor),
                            ),
                            child: Center(
                              child: Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: kocialColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      userModel.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      userModel.bio,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Text(
                          '$_followingCount Following',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2),
                        ),
                        SizedBox(width: 20),
                        Text(
                          '$_followersCount Following',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: CupertinoSlidingSegmentedControl(
                        groupValue: _profileSegmentedValue,
                        thumbColor: kocialColor,
                        backgroundColor: Colors.blueGrey,
                        children: _profileTabs,
                        onValueChanged: (i) {
                          setState(() {
                            _profileSegmentedValue = i!;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              BuildProfileWidgets(userModel),
            ],
          );
        },
      ),
    );
  }
}
