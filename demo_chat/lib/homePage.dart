import 'package:flutter/material.dart';
import 'package:demo_chat/chatPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class ChatUsers {
  String name;
  String imageURL;
  ChatUsers(this.name, this.imageURL);
}

class _HomeState extends State<HomePage> {
  String userId = '';
  List<ChatUsers> chatUsers = [
    ChatUsers("Soraya Su", "images/userImage1.jpeg"),
    ChatUsers("Demo SuSu", "images/userImage2.jpeg")
  ];

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  getUserId() async {
    final _prefs = await SharedPreferences.getInstance();
    userId = _prefs.getString('id').toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple.shade500,
        title: Text('Flutter Voice Chat App'),
      ),
      body: Container(
        // decoration: BoxDecoration(
        //     image: DecorationImage(image: AssetImage('asset/crop.jpeg'))),
        child: Stack(
          children: [
            Positioned(
              top: 80,
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: chatUsers.length,
                    itemBuilder: (context, index) {
                      return buildItem(chatUsers[index]);
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }

  buildItem(doc) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChatPage(doc),
        ));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        color: Colors.grey.shade200,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Container(
              child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(doc.name.toString().split(' ').first.substring(0, 1) +
                  doc.name.toString().split(' ')[1].substring(0, 1)),
            ),
            title: Text(
              doc.name,
              style: TextStyle(color: Colors.black),
            ),
          )),
        ),
      ),
    );
  }
}
