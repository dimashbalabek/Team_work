import 'package:flutter/material.dart';
import 'first_screen.dart';
import 'mainscreen.dart';

class _NewClassNameState extends State<ProgressIndicatorExample2>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController fadeController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
      setState(() {});
    });
    controller.repeat(reverse: true);

    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
      fadeController.forward();
      // Wait a little before navigating to the main screen
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FirstScreen()),
        );
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (isLoading)
                          CircularProgressIndicator(
                            value: controller.value,
                          ),
                        if (!isLoading)
                          FadeTransition(
                            opacity: fadeController,
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.purple,
                              size: 75,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Saving the Data",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

// Make sure to update the StatefulWidget class as well
class ProgressIndicatorExample2 extends StatefulWidget {
  const ProgressIndicatorExample2({Key? key}) : super(key: key);

  @override
  _NewClassNameState createState() => _NewClassNameState();
}
