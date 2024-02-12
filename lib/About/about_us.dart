import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
   final String title;
  const AboutUsScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text('About Us'),
      ),
      body: Center(
        child: Text(
          'This is the About Us page content',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
