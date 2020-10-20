import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_note_app/model/category.dart';
import 'package:flutter_note_app/model/note.dart';

class FirestoreDatabase {

  final CollectionReference collectionCatergory = FirebaseFirestore.instance.collection("categories");
  final CollectionReference collectionNote = FirebaseFirestore.instance.collection("notes");

  Future addCategory(Category category){
    return collectionCatergory.add(category.CategorytoJson());
  }

  Stream<QuerySnapshot> streamCategoryGet(){
    return collectionCatergory.snapshots();
  }

  Future addNote(Note note){
    return collectionNote.add(note.NotetoJson());
  }

  Stream<QuerySnapshot> streamNoteGet(){
    return collectionNote.snapshots();
  }


}