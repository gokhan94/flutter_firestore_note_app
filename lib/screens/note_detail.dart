import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_note_app/api/data.dart';
import 'package:flutter_note_app/model/note.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class NoteDetail extends StatefulWidget {
  static const routeName = '/note-detail';

  @override
  _NoteDetailState createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  final FirestoreDatabase firebaseInstance = FirestoreDatabase();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Note note = ModalRoute.of(context).settings.arguments;
    final TextEditingController _controllerDesc =
        TextEditingController(text: note.description);

    return Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          title: Text(note.name),
          backgroundColor: Colors.blueGrey,
          actions: [_buttonUpdate(note, _controllerDesc)],
        ),
        body: Container(
          child: Card(
            color: Colors.blueGrey.shade300,
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular((10.0)),
                side: BorderSide(color: Colors.grey.shade400, width: 1)),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 5, left: 10, right: 5),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        maxLines: 18,
                        maxLength: 500,
                        controller: _controllerDesc,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Description field cannot be blank';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            note.description = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  _buttonUpdate(Note note, TextEditingController controllerDesc) {
    return FlatButton(
      colorBrightness: Brightness.dark,
      color: Colors.blueGrey.shade600,
      child: Icon(
        Icons.update,
        size: 30.0,
        color: Colors.blueGrey.shade100,
      ),

      onPressed: () async {
        CollectionReference notes = firebaseInstance.collectionNote;
        initializeDateFormatting('en');

        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();

          await notes.doc(note.id).update({
            'description': controllerDesc.text,
            'date': DateFormat.yMMMMd('en').format(DateTime.now())
          }).then((value) {});
        }
      },
    );
  }
}
