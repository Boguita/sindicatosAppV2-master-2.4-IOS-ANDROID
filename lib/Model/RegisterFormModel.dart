import 'package:flutter/material.dart';

class RegisterFormModel {
  final String title;
  final IconData icon;
  final TextInputType keyboardType;
  final TextEditingController controller;

  RegisterFormModel(
      {this.title, this.icon, this.keyboardType, this.controller});
}
