import 'package:flutter/material.dart';
import 'package:flutter_social/Constants/Constants.dart';
import 'package:flutter_social/Services/database_service.dart';
import 'package:flutter_social/models/post.dart';
import 'package:flutter_social/models/user_model.dart';

class PostContainer extends StatefulWidget {
  final Post post;
  final UserModel author;
  final String currentUserId;

  const PostContainer(
      {Key? key,
      required this.post,
      required this.author,
      required this.currentUserId})
      : super(key: key);

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  int _likesCount = 0;
  bool _isLiked = false;

  initPostLikes() async {
    bool isLiked =
        await DatabaseService.isLikePost(widget.currentUserId, widget.post);
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  likePost() {
    if (_isLiked) {
      DatabaseService.unLikePost(widget.currentUserId, widget.post);
      setState(() {
        _isLiked = false;
        _likesCount--;
      });
    } else {
      DatabaseService.likePost(widget.currentUserId, widget.post);
      setState(() {
        _isLiked = true;
        _likesCount++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _likesCount = widget.post.likes;
    initPostLikes();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: widget.author.profilePicture.isEmpty
                    ? const AssetImage('assets/anya.png') as ImageProvider
                    : NetworkImage(widget.author.profilePicture),
              ),
              const SizedBox(width: 10),
              Text(
                widget.author.name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            widget.post.text,
            style: const TextStyle(fontSize: 15),
          ),
          widget.post.image.isEmpty
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    const SizedBox(height: 15),
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        color: kocialColor,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.post.image),
                        ),
                      ),
                    )
                  ],
                ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: likePost,
                        icon: Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          color: _isLiked ? Colors.red : Colors.black,
                        ),
                      ),
                      Text('$_likesCount Likes'),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.repeat),
                      ),
                      Text('${widget.post.shares} Shares'),
                    ],
                  ),
                ],
              ),
              Text(
                widget.post.timestamp.toDate().toString().substring(0, 19),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
        ],
      ),
    );
  }
}
