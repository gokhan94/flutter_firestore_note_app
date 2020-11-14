import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note_app/model/note.dart';
import 'package:flutter_note_app/api/data.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class NoteAdd extends StatefulWidget {
  static const routeName = '/note_add';
  @override
  _NoteAddState createState() => _NoteAddState();
}

class _NoteAddState extends State<NoteAdd> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreDatabase firebaseInstance = FirestoreDatabase();
  final Note note = Note.withInfo();

  String _noteName = '';
  String _description = '';
  var _categoryName;
  String docId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          title: Text("Note Add"),
          backgroundColor: Colors.blueGrey,
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
      style: TextStyle(color: Colors.white, fontSize: 20.0),
      maxLength: 20,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.grey.shade800, fontSize: 20.0),
        fillColor: Colors.grey.shade500,
        filled: true,
        labelText: 'Note Title',
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color:  Colors.white70
          ),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(
              color: Colors.white70,
              width: 1.0,
            )),
        suffixIcon: Icon(
          Icons.category,
          color: Colors.white54,
        ),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Title field cannot be blank';
        }
        return null;
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
      style: TextStyle(color: Colors.white, fontSize: 20.0),
      maxLines: 6,
      maxLength: 500,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.grey.shade800, fontSize: 20.0),
        fillColor: Colors.grey.shade500,
        filled: true,
        labelText: 'Note Description',
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color:  Colors.white70
          ),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(
              color: Colors.white70,
              width: 1.0,
            )),
        suffixIcon: Icon(
          Icons.category,
          color: Colors.white70,
        ),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Description field cannot be blank';
        }
        return null;
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

          initializeDateFormatting('en');

          note.id = firebaseInstance.generateId();
          note.name = _noteName;
          note.description = _description;
          note.categoryId = docId;
          note.categoryName = _categoryName;
          note.date = DateFormat.yMMMMd('en').format(DateTime.now());


          await firebaseInstance.addNote(note).then((value) {
            Navigator.pop(context);
          });

        }
      },
      color: Colors.blueGrey.shade600,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.blueGrey.shade600)
      ),
      child: Center(child: Text('Create', style: TextStyle(fontSize: 20, color: Colors.white),)),
    );
  }

  Widget buildSelectedCategory() {
    return Container(
      margin: EdgeInsets.all(40),
      child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('categories').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(
                child: Text('Error'),
              );

            return DropdownButtonFormField<String>(
              validator: (value) => value == null ? 'Please select a category' : null,
              value: _categoryName,
              isDense: true,
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.blueGrey),
              hint: Text(
                'Category Change',
                style: TextStyle(color: Colors.grey.shade800, fontSize: 20, letterSpacing: 1, wordSpacing: 1, ),
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
                          onTap: () {
                            setState(() {
                              docId = document.id;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 50.0,
                            child: Text(
                              document.data()['categoryName'].toString(),
                              style: TextStyle(fontSize: 20,),
                            ),
                          ));
                    }).toList()
                  : DropdownMenuItem(
                      value: 'Category Null',
                      child: Container(
                        height: 100.0,
                        child: Text('Category Null'),
                      ),
                    ),
            );
          }),
    );
  }
}
