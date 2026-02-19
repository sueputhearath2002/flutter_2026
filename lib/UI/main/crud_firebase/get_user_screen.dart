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
  List<UserModel> users = [];
  @override
  void initState() {
    getUsers();
    super.initState();
  }

  void pushToAddEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditUserScreen()),
    );
  }

  Future<void> getUsers() async {
    final data = await FirebaseFirestore.instance.collection("user").get();
    for (var a in data.docs) {
      print("===========================${a.data()}");
      users.add(UserModel.fromJson(a.data()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Playaround Firebase")),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return _buildCardUser(user);
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
        leading: Icon(Icons.person),
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
