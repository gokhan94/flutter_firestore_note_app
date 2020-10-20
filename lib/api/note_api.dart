import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_note_app/model/note.dart';

class FirestoreDatabase {

  final CollectionReference collectionNote = FirebaseFirestore.instance.collection("notes");

  Future addCategory(Note note){
    return collectionNote.add(note.NotetoJson());
  }

  Stream<QuerySnapshot> streamCategoryGet(){
    return collectionNote.snapshots();
  }



}