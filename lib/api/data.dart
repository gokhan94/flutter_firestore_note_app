import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_note_app/model/category.dart';
import 'package:flutter_note_app/model/note.dart';

class FirestoreDatabase {
  final CollectionReference collectionCategory =
      FirebaseFirestore.instance.collection("categories");
  final CollectionReference collectionNote =
      FirebaseFirestore.instance.collection("notes");

  generateId() {
    String newDocID = collectionNote.doc().id;
    return newDocID;
  }

  Future addCategory(Category category) {
    return collectionCategory.add(category.CategorytoJson());
  }

  Stream<QuerySnapshot> streamCategoryGet() {
    return collectionCategory.snapshots();
  }

  Future deleteCategory(String id) {
    return collectionCategory.doc(id).delete();
  }

  Future addNote(Note note) {
    return collectionNote.add(note.NotetoJson());
  }

  Future updateNote(String id, data) {
    return collectionNote.doc(id).update(data);
  }

  Future deleteNote(String id) {
    return collectionNote.doc(id).delete();
  }

  Stream<QuerySnapshot> streamNoteGet() {
    return collectionNote.snapshots();
  }
}
