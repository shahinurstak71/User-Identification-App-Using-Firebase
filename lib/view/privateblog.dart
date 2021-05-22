import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/view/addprivatepost.dart';
import 'package:noteapp/view/addpublicpost.dart';
import 'package:noteapp/widgets/drawer.dart';
import 'package:noteapp/widgets/single_todo.dart';

class PrivateBlog extends StatefulWidget {
  static const routeName = '/ private blog';

  @override
  _PrivateBlogState createState() => _PrivateBlogState();
}

class _PrivateBlogState extends State<PrivateBlog> {
  final _todoUpdate = TextEditingController();
  final _todoUpdate1 = TextEditingController();

  Future<void> delateTodo(String id) async {
    String uid = FirebaseAuth.instance.currentUser.uid;

    try {
      await FirebaseFirestore.instance
          .collection('private')
          .doc(uid)
          .collection('personal')
          .doc(id)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _updatetod(String id) async {
    String uid = FirebaseAuth.instance.currentUser.uid;

    String updateText = _todoUpdate.text;
    String updateText1 = _todoUpdate1.text;
    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('private')
          .doc(uid)
          .collection('personal')
          .doc(id);
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.get(documentReference);
        transaction.update(documentReference, {
          'title': updateText,
          'description': updateText1,
        });
      });
      Navigator.of(context).pop();
      _todoUpdate.text = '';
      _todoUpdate1.text = '';
    } catch (e) {
      print(e);
    }
  }

  Future<void> editButton(String id) async {
    String uid = FirebaseAuth.instance.currentUser.uid;

    final collucrion = FirebaseFirestore.instance
        .collection('private')
        .doc(uid)
        .collection('personal')
        .doc(id);
    await collucrion.get().then((value) {
      _todoUpdate.text = value.data()['title'];
      _todoUpdate1.text = value.data()['description'];
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Todo"),
          content: Column(
            children: [
              TextField(
                controller: _todoUpdate,
                decoration: InputDecoration(
                  hintText: "Update a Todo",
                ),
              ),
              TextField(
                controller: _todoUpdate1,
                decoration: InputDecoration(
                  hintText: "Update a Todo",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _updatetod(id);
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('PRIVATE BLOG'),
        centerTitle: true,
        actions: [
          PopupMenuButton(onSelected: (route) {
            Navigator.pushNamed(context, route);
          }, itemBuilder: (context) {
            // ignore: deprecated_member_use
            var list = List<PopupMenuEntry<Object>>();
            list.add(
              PopupMenuItem(
                  child: Text(
                'YOUR POST',
                style: TextStyle(
                    color: Colors.blueGrey,
                    letterSpacing: 5,
                    fontWeight: FontWeight.bold),
              )),
            );
            list.add(PopupMenuDivider(
              height: 20,
            ));
            list.add(
              PopupMenuItem(
                child: Text(
                  "PUBLIC POST",
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
                value: PublicPost.routeName,
              ),
            );
            list.add(
              PopupMenuDivider(
                height: 20,
              ),
            );
            list.add(
              PopupMenuItem(
                child: Text(
                  "PRIVATE POST",
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
                value: PrivatePost.routeName,
              ),
            );
            return list;
          }),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('private')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .collection('personal')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data.docs
                .map((privateValue) => SingleTodo(
                      title: privateValue['title'],
                      description: privateValue['description'],
                      id: privateValue.id,
                      delFunction: delateTodo,
                      editFunction: editButton,
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
