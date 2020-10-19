class Note {
  int noteId;
  String name;
  String description;
  int categoryDocId;

  Note(this.noteId, this.name, this.description, this.categoryDocId);

  Note.fromJson(Map<String, dynamic> note) {
    noteId = note["noteId"];
    name = note["name"];
    description = note["description"];
    categoryDocId = note["categoryId"];
  }

  Map NotetoJson() {
    return {"noteId": noteId, "name": name, "description": description, categoryDocId: "categoryId"};
  }


}
