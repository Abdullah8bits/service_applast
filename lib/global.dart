library my_app.globals;

String? selectedCategory;
DateTime? selectedDate;
String? selectedUserDocId;
void setSelectedDate(DateTime date) {
  selectedDate = date;
}

DateTime? getSelectedDate() {
  return selectedDate;
}
void setSelectedCategory(String category) {
  selectedCategory = category;
}

String? getSelectedCategory() {
  return selectedCategory;
}
void setSelectedUserDocId(String docId) {
  selectedUserDocId = docId;
}

String? getSelectedUserDocId() {
  return selectedUserDocId;
}