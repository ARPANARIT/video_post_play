import 'package:flutter/material.dart';

const textFieldDecor = InputDecoration(
  contentPadding: EdgeInsets.all(12),
  hintText: 'Enter Title',
  hintStyle: TextStyle(fontSize: 20),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(20),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(20),
    ),
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);
