import 'dart:io';

import 'package:basic_flutter/UI/main/crud_firebase/add_edit_user_screen.dart';
import 'package:basic_flutter/UI/main/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserScreen extends StatefulWidget {
  const GetUserScreen({super.key});

  @override
  State<GetUserScreen> createState() => _GetUserScreenState();
}

class _GetUserScreenState extends State<GetUserScreen> {
  late Stream<List<UserModel>> _userStream;

  @override
  void initState() {
    _userStream = FirebaseFirestore.instance
        .collection("user")
        .snapshots()
        .map(
          (snapshots) => snapshots.docs.map((doc) {
            return UserModel.fromJson(doc.id, doc.data());
          }).toList(),
        );

    super.initState();
  }

  void pushToAddEdit({UserModel? user}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditUserScreen(user: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Playaround Firebase")),
      body: StreamBuilder(
        stream: _userStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(" No user found"));
          }

          final users = snapshot.data ?? [];
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return _buildCardUser(user);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => pushToAddEdit(),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildCardUser(UserModel? user) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: () => pushToAddEdit(user: user),
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: FileImage(File(user?.picture ?? "")),
        ),
        title: Text(user?.name.toString() ?? ""),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Address ${user?.address.toString() ?? ""}"),
            Text("Age :  ${user?.age.toString() ?? ""}"),
            Text("Gender :  ${user?.gender.toString() ?? ""}"),
          ],
        ),
      ),
    );
  }
}
