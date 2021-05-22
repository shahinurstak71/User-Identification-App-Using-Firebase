import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/view/addprivatepost.dart';
import 'package:noteapp/widgets/drawer.dart';

class PublicPost extends StatelessWidget {
  static const routeName = '/ public post';

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _titleText = TextEditingController();
  final TextEditingController _descriptionText = TextEditingController();

  // Add function below................

  Future<void> _addValue() async {
    final collucrion = FirebaseFirestore.instance.collection('public');
    await collucrion.add({
      "title": _titleText.text,
      "description": _descriptionText.text,
    });

    _titleText.text = "";
    _descriptionText.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('ADD PUBLIC POST'),
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
      body: Center(
        child: Form(
          key: _formkey,
          // ignore: deprecated_member_use
          autovalidate: false,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _titleText,
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Please enter title';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Enter title'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _descriptionText,
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Please enter Description';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Description'),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                      onTap: () {
                        if (_formkey.currentState.validate()) {
                          print('process data');
                        } else {
                          print('Error');
                        }
                        _addValue();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Text(
                          'ADD NOW',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 5,
                              fontSize: 25),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
