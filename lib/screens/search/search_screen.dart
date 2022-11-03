import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social/Constants/Constants.dart';
import 'package:flutter_social/models/user_model.dart';
import 'package:flutter_social/profile/profile.dart';
import 'package:flutter_social/services/database_service.dart';

class SearchScreen extends StatefulWidget {
  final String currentUserId;

  const SearchScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<QuerySnapshot>? _users;
  final TextEditingController _searchController = TextEditingController();

  clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      _users = null;
    });
  }

  userTile(UserModel user) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: user.profilePicture.isEmpty
            ? const AssetImage('assets/anya.png')
            : NetworkImage(user.profilePicture) as ImageProvider,
      ),
      title: Text(user.name),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              currentUserId: widget.currentUserId,
              visitedUserId: user.id,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
            hintText: 'Search User...',
            hintStyle: const TextStyle(color: Colors.white),
            border: InputBorder.none,
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.clear,
                color: kocialColor,
              ),
              onPressed: () {
                clearSearch();
              },
            ),
            filled: true,
          ),
          onChanged: (input) {
            if (input.isNotEmpty) {
              setState(() {
                _users = DatabaseService.searchUsers(input);
              });
            }
          },
        ),
      ),
      body: _users == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.search, size: 200),
                  Text(
                    'Search User...',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            )
          : FutureBuilder(
              future: _users,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data.docs.length == 0) {
                  return const Center(
                    child: Text('User not found!'),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      UserModel user =
                          UserModel.fromDoc(snapshot.data.docs[index]);
                      return userTile(user);
                    });
              }),
    );
  }
}
