import 'package:flutter/material.dart';
import 'package:flutter_note_app/model/note.dart';

class NoteDetail extends StatelessWidget {
  static const routeName = '/note-detail';

  @override
  Widget build(BuildContext context) {
    final Note args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.name),
      ),
      body: Center(
        child: Text(args.description),
      ),
    );
  }
}
