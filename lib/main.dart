import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_note_app/screens/category_note_detail.dart';
import 'package:flutter_note_app/screens/note_add.dart';
import 'package:flutter_note_app/ui/category_add.dart';
import 'package:flutter_note_app/ui/note_detail.dart';
import 'ui/note_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: {
        NoteHomePage.routeName: (context) => NoteHomePage(),
        NoteDetail.routeName:   (context) => NoteDetail(),
        NoteAdd.routeName: (context) => NoteAdd(),
        CategoryAdd.routeName:   (context) => CategoryAdd(),
        CategoryNoteDetail.routeName:   (context) => CategoryNoteDetail(),
        //'/home': (context) => NoteHomePage(),
        //'/note-detail': (context) => NoteDetail(),
      },

    );
  }
}

