import 'package:flutter/material.dart';
import 'package:gsheet2/first_screen.dart';
import 'package:gsheet2/ggleheet.dart';
import 'package:gsheet2/wellcome.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SheetsFlutter.init();
  await Hive.initFlutter();

  print("Открытие коробки 'students'...");
  if (!Hive.isBoxOpen('students')) {
    await Hive.openBox('students');
    print("Коробка 'students' успешно открыта.");
  } else {
    print("Коробка 'students' уже открыта.");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Onboarding(),
    );
  }
}
