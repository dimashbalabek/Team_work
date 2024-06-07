import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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

  void _launchURL() async {
    const url = 'https://docs.google.com/spreadsheets/d/1C2JKFHUOrbDxcBHKAu58utkK6-OfYQMLBdaxwK1JuCw/edit#gid=0';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    print("Initializing 'students' box in FirstScreen...");
    if (!Hive.isBoxOpen('students')) {
      await Hive.openBox('students');
      print("'students' box successfully opened in FirstScreen.");
    } else {
      print("'students' box was already open in FirstScreen.");
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
      body: Column(
        children: <Widget>[
          SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [


            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final data = filteredList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.person, size: 40),
                      title: Text('Name: ${data['name']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Phone: ${data['phoneNumber']}'),
                          Text('Address: ${data['address']}'),
                          Text('IIN: ${data['IIN']}'),
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
                elevation: 3,
                backgroundColor: const Color.fromARGB(255, 159, 124, 221), // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0), // Rounded corners
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0), // Button padding
              ),
              child: const Text(
                '               Add User               ',
                style: TextStyle(fontSize: 17, color: Colors.white),
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
