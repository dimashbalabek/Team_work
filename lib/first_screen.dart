import 'package:flutter/material.dart';
import 'package:gsheet2/data.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'mainscreen.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final StudentsDataBase db = StudentsDataBase();
  List<Map<String, String>> dataList = [];
  List<Map<String, String>> filteredList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    print("Инициализация коробки 'students' в FirstScreen...");
    if (!Hive.isBoxOpen('students')) {
      await Hive.openBox('students');
      print("Коробка 'students' успешно открыта в FirstScreen.");
    } else {
      print("Коробка 'students' уже была открыта в FirstScreen.");
    }
    db.createInitialData();
    dataList = db.loadData();
    filteredList = dataList;
    searchController.addListener(filterData);
  }

  void filterData() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = dataList.where((data) {
        return data.values.any((value) => value.toLowerCase().contains(query));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная Страница'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Искать',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final data = filteredList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.person, size: 40),
                      title: Text('Имя: ${data['name']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Телефон: ${data['phoneNumber']}'),
                          Text('Адрес: ${data['address']}'),
                          Text('ИИН: ${data['IIN']}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 158, 162, 166), // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0), // Rounded corners
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 24.0), // Button padding
              ),
              child: const Text(
                'Регистрация',
                style: TextStyle(fontSize: 17),
              ),
              onPressed: () {
                _returnDataFromSecondScreen(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _returnDataFromSecondScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        if (!dataList.contains(result)) {
          dataList.add(result);
          filteredList = List.from(dataList);
          db.addStudent(result);
        }
      });
    }
  }
}
