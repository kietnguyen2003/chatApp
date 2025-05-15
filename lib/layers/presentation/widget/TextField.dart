import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

Widget customTextField({
  required TextEditingController controller,
  required String labelText,
  required Color color,
  required bool obscureText,
  FormFieldValidator<String>? validate,
}) {
  return FormBuilderTextField(
    name: labelText.toLowerCase(),
    controller: controller,
    decoration: InputDecoration(
      hintText: labelText,
      hintStyle: const TextStyle(color: Colors.black, fontSize: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color, width: 2),
      ),
    ),
    obscureText: obscureText,
    validator: validate,
    style: const TextStyle(color: Colors.black, fontSize: 16),
  );
}
