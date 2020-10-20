import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note_app/api/data.dart';
import 'package:flutter_note_app/model/category.dart';
import 'package:flutter_note_app/screens/note_add.dart';
import 'package:flutter_note_app/ui/category_add.dart';
import 'note_detail.dart';
import 'package:flutter_note_app/model/note.dart';
import 'package:flutter_note_app/screens/category_note_detail.dart';

class NoteHomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _NoteHomePageState createState() => _NoteHomePageState();
}

class _NoteHomePageState extends State<NoteHomePage> {
  final FirestoreDatabase collectionCatergory = FirestoreDatabase();
  final Category category = Category();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('About'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Note Application"),
        backgroundColor: Colors.lightBlue[700],
        actions: [
          IconButton(
            icon: Icon(Icons.category),
            iconSize: 30,
            onPressed: () {
              Navigator.pushNamed(context, CategoryAdd.routeName);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          categoryScrollView(),
          FlatButton(
            child: Text("Note Home"),
            color: Colors.grey,
            textColor: Colors.black87,
            onPressed: () {
              Navigator.pushNamed(context, NoteDetail.routeName,
                  arguments: Note(1, "note 1", "1", "note description", "PC"));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, NoteAdd.routeName);
        },
        child: Icon(Icons.add_to_photos),
      ),
    );
  }

  Widget categoryScrollView() {
    return StreamBuilder<QuerySnapshot>(
      stream: collectionCatergory.streamCategoryGet(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        return Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return categoryFlatButton(document);
                  }).toList(),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget categoryFlatButton(DocumentSnapshot document) {
    return Container(
      margin: EdgeInsets.all(5),
      child: FlatButton(
        child: Text(
          document.data()['categoryName'],
          style: TextStyle(color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.lightBlue.shade700)),
        color: Colors.lightBlue.shade700,
        onPressed: () {
          Navigator.pushNamed(context, CategoryNoteDetail.routeName,
              arguments: CategoryNoteDetail.category(
                id: document.id.toString(),
                name: document.data()['categoryName'],
              ));
          print(document.id);
        },
      ),
    );
  }
}
