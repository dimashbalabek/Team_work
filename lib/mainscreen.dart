import 'package:flutter/material.dart';
import 'package:gsheet2/ggleheet.dart';
import 'package:gsheet2/sheetscolumn.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'loading_confirm.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Box _studentBox;
  double heightG = 350;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    print("Initializing 'students' box...");
    if (!Hive.isBoxOpen('students')) {
      _studentBox = await Hive.openBox('students');
      print("'students' box successfully opened in MainScreen.");
    } else {
      _studentBox = Hive.box('students');
      print("'students' box was already open in MainScreen.");
    }
  }

  Future<void> saveNewStudent() async {
    final newStudent = {
      'name': nameController.text.trim(),
      'phoneNumber': phonenumberController.text.trim(),
      'address': addressController.text.trim(),
      'IIN': IINController.text.trim(),
    };

    _studentBox.add(newStudent);
  }

  Future<void> saveToSheets() async {
    final feedback = {
      SheetsColumn.name: nameController.text.trim(),
      SheetsColumn.phonenumber: phonenumberController.text.trim(),
      SheetsColumn.address: addressController.text.trim(),
      SheetsColumn.IIN: IINController.text.trim(),
    };

    await SheetsFlutter.insert([feedback]);
  }

  void handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      await saveToSheets();
      await saveNewStudent();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProgressIndicatorExample2()),
      );
    }
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    if (!RegExp(r'^[a-zA-Zа-яА-Я]+$').hasMatch(value)) {
      return 'Name must contain only letters';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Phone number must contain only digits';
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an address';
    }
    return null;
  }

  String? validateIIN(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an IIN';
    }
    if (!RegExp(r'^\d{12}$').hasMatch(value)) {
      return 'IIN must contain 12 digits';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              Image.asset("assets/images/8.png"),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset("assets/images/4.png"),
            ],
          ),
          Stack(
            children: [
              SizedBox(height: 40,width: 40,),
              Row(
                children: [
                  SizedBox(width: 10, height: 30,),
                  Container(
                    margin: EdgeInsets.only(left: 0, top: 20),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, size: 30,),
                    ),
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                  blurStyle: BlurStyle.outer,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white54,
                            ),
                            height: 430,
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextFormField(
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Name',
                                      border: OutlineInputBorder(),
                                      errorStyle: TextStyle(color: Colors.red),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    validator: validateName,
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    controller: phonenumberController,
                                    decoration: InputDecoration(
                                      labelText: 'Phone Number',
                                      border: OutlineInputBorder(),
                                      errorStyle: TextStyle(color: Colors.red),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    validator: validatePhoneNumber,
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    controller: addressController,
                                    decoration: InputDecoration(
                                      labelText: 'Address',
                                      border: OutlineInputBorder(),
                                      errorStyle: TextStyle(color: Colors.red),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    validator: validateAddress,
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    controller: IINController,
                                    decoration: InputDecoration(
                                      labelText: 'IIN',
                                      border: OutlineInputBorder(),
                                      errorStyle: TextStyle(color: Colors.red),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    validator: validateIIN,
                                  ),
                                  SizedBox(height: 30),

                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 100,)
                        ],
                      ),
                      SizedBox(height: 40,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: handleSubmit,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.orangeAccent,
                              ),
                              height: 50,
                              width: 350,
                              child: const Center(
                                child: Text(
                                  'Save',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
