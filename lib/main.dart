import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_note_app/screens/category_note_detail.dart';
import 'package:flutter_note_app/screens/note_add.dart';
import 'package:flutter_note_app/screens/note_all.dart';
import 'package:flutter_note_app/screens/note_detail.dart';
import 'package:flutter_note_app/ui/category_add.dart';
import 'package:flutter_note_app/ui/category_detail.dart';
import 'ui/note_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        NoteHomePage.routeName: (context) => NoteHomePage(),
        NoteAdd.routeName: (context) => NoteAdd(),
        NoteAll.routeName: (context) => NoteAll(),
        NoteDetail.routeName:   (context) => NoteDetail(),
        CategoryAdd.routeName: (context) => CategoryAdd(),
        CategoryNoteDetail.routeName: (context) => CategoryNoteDetail(),
        CategoryDetail.routeName: (context) => CategoryDetail(),
      },
    );
  }
}
