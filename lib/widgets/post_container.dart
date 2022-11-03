import 'package:flutter/material.dart';
import 'package:flutter_social/Constants/Constants.dart';
import 'package:flutter_social/models/post.dart';
import 'package:flutter_social/models/user_model.dart';

class PostContainer extends StatefulWidget {
  final Post post;
  final UserModel author;
  final String? currentUserId;

  const PostContainer({Key? key, required this.post, required this.author, this.currentUserId})
      : super(key: key);

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  int _likesCount = 0;
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            widget.post.text,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          widget.post.image.isEmpty
              ? SizedBox.shrink()
              : Column(
                  children: [
                    SizedBox(height: 15),
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
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.favorite_border,
                        ),
                      ),
                      Text(
                        widget.post.likes.toString() + ' Likes',
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.repeat,
                        ),
                      ),
                      Text(
                        widget.post.shares.toString() + ' Shares',
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                widget.post.timestamp.toDate().toString().substring(0, 19),
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: 10),
          Divider(),
        ],
      ),
    );
  }
}
