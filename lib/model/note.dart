class Note {
  int noteId;
  String name;
  String description;
  String categoryId;
  String categoryName;

  Note(this.noteId, this.name, this.description, this.categoryId, this.categoryName);

  Note.withInfo({this.noteId, this.name, this.description, this.categoryId, this.categoryName});

  Note.fromJson(Map<String, dynamic> note) {
    noteId = note["noteId"];
    name = note["name"];
    description = note["description"];
    categoryId = note["categoryId"];
    categoryName = note["categoryName"];
  }

  Map<String, dynamic> NotetoJson() {
    return {"noteId": noteId, "name": name, "description": description, "categoryId": categoryId, "categoryName": categoryName};
  }


}
