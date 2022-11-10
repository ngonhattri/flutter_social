import 'package:flutter/material.dart';
import 'package:flutter_social/Services/database_service.dart';

import 'package:flutter_social/models/post.dart';
import 'package:flutter_social/models/user_model.dart';
import 'package:flutter_social/widgets/post_container.dart';

import '../Constants/Constants.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;

  const HomeScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Post> _followingPosts = [];
  bool _loading = false;

  posts(Post post, UserModel author) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: PostContainer(
        post: post,
        author: author,
        currentUserId: widget.currentUserId,
      ),
    );
  }

  showFollowingPosts(String currentUserId) {
    List<Widget> followingPostsList = [];
    for (Post post in _followingPosts) {
      followingPostsList.add(FutureBuilder(
          future: usersRef.doc(post.auhorId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              UserModel author = UserModel.fromDoc(snapshot.data);
              return posts(post, author);
            } else {
              return const SizedBox.shrink();
            }
          }));
    }
    return followingPostsList;
  }

  setupFollowingPosts() async {
    setState(() {
      _loading = true;
    });
    List<Post> followingPosts =
        await DatabaseService.getHomePosts(widget.currentUserId);
    if (mounted) {
      setState(() {
        _followingPosts = followingPosts;
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setupFollowingPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: SizedBox(
            height: 40,
            child: Image.asset('assets/kocial_logo2.png'),
          ),
          title: const Text(
            'Home Screen',
            style: TextStyle(
              color: kocialColor,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => setupFollowingPosts(),
          child: ListView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              _loading ? const LinearProgressIndicator() : const SizedBox.shrink(),
              const SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 5),
                  Column(
                    children: _followingPosts.isEmpty && _loading == false
                        ? [
                            const SizedBox(height: 5),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Text(
                                'There is No New Tweets',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            )
                          ]
                        : showFollowingPosts(widget.currentUserId),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
