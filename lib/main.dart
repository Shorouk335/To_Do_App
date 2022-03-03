import 'package:flutter/material.dart';
import 'package:to_do_app/Layout/HomeLayout.dart';
main(){
  runApp(ToDoApp());
}
class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ToDo(),
    );
  }
}
