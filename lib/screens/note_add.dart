import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note_app/model/note.dart';
import 'package:flutter_note_app/api/data.dart';

class NoteAdd extends StatefulWidget {
  static const routeName = '/note_add';
  @override
  _NoteAddState createState() => _NoteAddState();
}

class _NoteAddState extends State<NoteAdd> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreDatabase collectionNote = FirestoreDatabase();
  final Note note = Note.withInfo();

  String _noteName = '';
  String _description = '';
  var _categoryName;
  String docId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Category Add"),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  buildNoteNameField(),
                  buildNoteDescriptionField(),
                  buildSelectedCategory(),
                  submitBuildForm()
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildNoteNameField() {
    return TextFormField(
      maxLength: 20,
      decoration: InputDecoration(
        labelText: 'Note Name',
        suffixIcon: Icon(
          Icons.note,
        ),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a name';
        }
      },
      onSaved: (value) {
        setState(() {
          _noteName = value;
        });
      },
    );
  }

  Widget buildNoteDescriptionField() {
    return TextFormField(
      maxLength: 20,
      decoration: InputDecoration(
        labelText: 'Note Description',
        suffixIcon: Icon(
          Icons.note,
        ),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a name';
        }
      },
      onSaved: (value) {
        setState(() {
          _description = value;
        });
      },
    );
  }

  Widget submitBuildForm() {
    return RaisedButton(
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();

          Note note = Note.withInfo();
          note.noteId = 1;
          note.name = _noteName;
          note.description = _description;
          note.categoryId = docId;
          note.categoryName = _categoryName;

         await collectionNote.addNote(note);

        }
      },
      child: Center(child: Text('Create')),
    );
  }

  Widget buildSelectedCategory() {
    return Container(
      margin: EdgeInsets.all(40),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('categories').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(
                child: Text('hata'),
              );

            return DropdownButton<String>(
              value: _categoryName,
              isDense: true,
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),
              hint: Text('Category Change', style: TextStyle(fontSize: 20),),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  _categoryName = newValue;
                });
              },
              items: snapshot.data != null
                  ? snapshot.data.docs.map((DocumentSnapshot document) {
                      return new DropdownMenuItem<String>(
                          value: document.data()['categoryName'].toString(),
                          onTap: (){
                            setState(() {
                              docId = document.id;
                            });
                          },
                          child: Container(
                            height: 50.0,
                            child: Text(
                              document.data()['categoryName'].toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                          ));
                    }).toList()
                  : DropdownMenuItem(
                      value: 'null',
                      child: Container(
                        height: 100.0,
                        child: Text('null'),
                      ),
                    ),
            );
          }),
    );
  }
}
