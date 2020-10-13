import 'package:flutter/material.dart';
import 'note_detail.dart';
import 'package:flutter_note_app/model/note.dart';

class NoteHomePage extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note Application"),
      ),
      body: Center(
        child: FlatButton(
          child: Text("Note Home"),
          color: Colors.grey,
          textColor: Colors.black87,
          onPressed: () {
            Navigator.pushNamed(context, NoteDetail.routeName,
                arguments: Note(1, "note 1", "note description", 2));
          },
        ),
      ),
    );
  }
}
