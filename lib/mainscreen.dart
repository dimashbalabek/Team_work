import 'package:flutter/material.dart';
import 'package:gsheet2/ggleheet.dart';
import 'package:gsheet2/sheetscolumn.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Box _studentBox;

  TextEditingController nameController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController IINController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    print("Инициализация коробки 'students'...");
    if (!Hive.isBoxOpen('students')) {
      _studentBox = await Hive.openBox('students');
      print("Коробка 'students' успешно открыта в MainScreen.");
    } else {
      _studentBox = Hive.box('students');
      print("Коробка 'students' уже была открыта в MainScreen.");
    }
  }

  void saveNewStudent() {
    final newStudent = {
      'name': nameController.text.trim(),
      'phoneNumber': phonenumberController.text.trim(),
      'address': addressController.text.trim(),
      'IIN': IINController.text.trim(),
    };

    _studentBox.add(newStudent);

    Navigator.pop(context, newStudent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Имя'),
              ),
              TextFormField(
                controller: phonenumberController,
                decoration: const InputDecoration(labelText: 'Телефон'),
              ),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Адрес'),
              ),
              TextFormField(
                controller: IINController,
                decoration: const InputDecoration(labelText: 'ИИН'),
              ),
              GestureDetector(
                onTap: () async {
                  final feedback = {
                    SheetsColumn.name: nameController.text.trim(),
                    SheetsColumn.phonenumber: phonenumberController.text.trim(),
                    SheetsColumn.address: addressController.text.trim(),
                    SheetsColumn.IIN: IINController.text.trim(),
                  };

                  await SheetsFlutter.insert([feedback]);

                  saveNewStudent();
                },
                child: Container(
                  height: 50,
                  width: 100,
                  color: Colors.red,
                  child: const Center(child: Text('Сохранить')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
