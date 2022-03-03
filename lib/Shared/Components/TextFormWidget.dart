import 'package:flutter/material.dart';

Widget TextFormWidget({
  required String Label,
  required IconData prefIcon,
  required  var Controller ,
 TextInputType? type = TextInputType.none ,
  void Function()? OnTap,

}) {
  return Padding(
    padding: const EdgeInsets.all(3.0),
    child: TextFormField(
      controller: Controller ,
      decoration: InputDecoration(
        labelText: Label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        prefixIcon: Icon(prefIcon),
      ),
      onTap: OnTap,
      keyboardType: type,
      validator: (value){
        if (value!.isEmpty){
          return ("$Label must be not empty");
        }
        else
          return null ;
      },
    ),
  );
}
