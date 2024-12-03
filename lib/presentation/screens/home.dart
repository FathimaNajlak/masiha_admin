import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 125, 158, 185),
        title: const Text(
          "Masiha_Admin",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context); // This will pop the current route off the navigator
          },
        ),
      ),
      body: Center(
        child: Container(
          child: const Text(
            "home",
          ),
        ),
      ),
    );
  }
}
