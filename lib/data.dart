import 'package:hive_flutter/hive_flutter.dart';

class StudentsDataBase {
  late Box _studentBox;

  StudentsDataBase() {
    _studentBox = Hive.box('students');
  }

  void createInitialData() {
    if (_studentBox.isEmpty) {
      // Adding initial data if the box is empty
      _studentBox.add({
        'name': 'Alice',
        'phoneNumber': '1234567890',
        'address': 'Төлеби 72a',
        'IIN': '123456789012'
      });
      _studentBox.add({
        'name': 'Bob',
        'phoneNumber': '0987654321',
        'address': 'Шымкент',
        'IIN': '109876543210'
      });
    }
  }

  List<Map<String, String>> loadData() {
    return _studentBox.values
        .cast<Map>()
        .map((e) => Map<String, String>.from(e))
        .toList();
  }

  void addStudent(Map<String, String> student) {
    bool duplicate = _studentBox.values.any((existingStudent) {
      return existingStudent['IIN'] == student['IIN'];
    });

    if (!duplicate) {
      _studentBox.add(student);
    }
  }
}
