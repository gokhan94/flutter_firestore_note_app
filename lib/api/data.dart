import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_note_app/model/category.dart';

class FirestoreDatabase {

  final CollectionReference collectionCatergory = FirebaseFirestore.instance.collection("categories");

  Future addCategory(Category category){
    return collectionCatergory.add(category.CategorytoJson());
  }

  Stream<QuerySnapshot> streamCategoryGet(){
    return collectionCatergory.snapshots();
  }



}