import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/view/addprivatepost.dart';
import 'package:noteapp/view/addpublicpost.dart';
import 'package:noteapp/widgets/drawer.dart';
import 'package:noteapp/widgets/single_todo.dart';

class PublicBlog extends StatefulWidget {
  static const routeName = '/public blog';

  @override
  _PublicBlogState createState() => _PublicBlogState();
}

class _PublicBlogState extends State<PublicBlog> {
  final TextEditingController _updateText = TextEditingController();
  final TextEditingController _updateText1 = TextEditingController();

  Future<void> delateTodo(String id) async {
    try {
      final collucrion =
          FirebaseFirestore.instance.collection('public').doc(id);
      await collucrion.delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _updatetod(String id) async {
    String updateText = _updateText.text;
    String updateText1 = _updateText1.text;
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('public').doc(id);
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.get(documentReference);
        transaction.update(documentReference, {
          'title': updateText,
          'description': updateText1,
        });
      });
      Navigator.of(context).pop();
      _updateText.text = '';
      _updateText1.text = '';
    } catch (e) {}
  }

  Future<void> editButton(String id) async {
    final editValue = FirebaseFirestore.instance.collection('public').doc(id);
    await editValue.get().then((value) {
      _updateText.text = value.data()['title'];
      _updateText1.text = value.data()['description'];
    });

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update Todo'),
            content: Column(
              children: [
                TextField(
                  controller: _updateText,
                  decoration: InputDecoration(
                    hintText: "Update a Todo",
                  ),
                ),
                TextField(
                  controller: _updateText1,
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
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    _updatetod(id);
                  },
                  child: Text('Update')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('PUBLIC BLOG'),
        centerTitle: true,
        actions: [
          PopupMenuButton(onSelected: (route) {
            // add this property

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
        stream: FirebaseFirestore.instance.collection("public").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data.docs
                .map(
                  (todoData) => SingleTodo(
                    title: todoData['title'],
                    description: todoData['description'],
                    id: todoData.id,
                    delFunction: delateTodo,
                    editFunction: editButton,
                  ),
                )
                .toList(),
          );
        },
        // builder: ,
      ),
    );
  }
}
