import 'package:flutter/material.dart';

class Change extends StatefulWidget {
  static const RouteName = '/change';

  @override
  _ChangeState createState() => _ChangeState();
}

class _ChangeState extends State<Change> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text('เริ่มขาย'),
      ),
    );
  }
}