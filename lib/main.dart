import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:noteapp/view/addprivatepost.dart';
import 'package:noteapp/view/addpublicpost.dart';
import 'package:noteapp/view/loginpage.dart';
import 'package:noteapp/view/privateblog.dart';
import 'package:noteapp/view/publicblog.dart';
import 'package:noteapp/view/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PublicBlog();
          }
          return Login();
        },
      ),
      routes: {
        PrivatePost.routeName: (context) => PrivatePost(),
        PublicPost.routeName: (context) => PublicPost(),
        PrivateBlog.routeName: (context) => PrivateBlog(),
        PublicBlog.routeName: (context) => PublicBlog(),
        Login.routename: (context) => Login(),
        SignUp.routeName: (context) => SignUp()
      },
    );
  }
}
