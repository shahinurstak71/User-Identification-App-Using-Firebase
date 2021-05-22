import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:noteapp/view/privateblog.dart';
import 'package:noteapp/view/publicblog.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Future<void> signOut() async {
    try {
      FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
    }

    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 200,
            width: double.infinity,
            color: Colors.blueGrey,
            child: Text(
              'USER IDENTIFICATION APP',
              style: TextStyle(color: Colors.lightBlue, fontSize: 20),
            ),
          ),
          SizedBox(
            height: 150,
          ),
          Divider(
            thickness: 2,
            height: 0.0,
            color: Colors.blueGrey,
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, PublicBlog.routeName);
            },
            child: ListTile(
              leading: Icon(Icons.public),
              title: Text('PUBLIC BLOG'),
              trailing: Icon(Icons.arrow_back_ios),
            ),
          ),
          Divider(
            thickness: 2,
            height: 0.0,
            color: Colors.blueGrey,
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, PrivateBlog.routeName);
            },
            child: ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('PRIVATE BLOG'),
              trailing: Icon(Icons.arrow_back_ios),
            ),
          ),
          Divider(
            thickness: 2,
            height: 0.0,
            color: Colors.blueGrey,
          ),
          InkWell(
            onTap: () {
              signOut();
            },
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text('LOGOUT'),
              trailing: Icon(Icons.arrow_back_ios),
            ),
          ),
          Divider(
            thickness: 2,
            height: 0.0,
            color: Colors.blueGrey,
          ),
        ],
      ),
    );
  }
}
