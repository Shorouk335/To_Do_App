import 'package:flutter/material.dart';
import 'package:to_do_app/Layout/Archived.dart';
import 'package:to_do_app/Layout/Done.dart';
import 'package:to_do_app/Layout/Tasks.dart';


//  for show bottomsheet
var scaffoldKey = GlobalKey<ScaffoldState>();


//for valdition
var formKey = GlobalKey<FormState>();




//Controller
var titleController = TextEditingController();
var timeController = TextEditingController();
var dateController = TextEditingController();