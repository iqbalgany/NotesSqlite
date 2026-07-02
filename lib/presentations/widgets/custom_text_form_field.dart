import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String text;
  final bool readOnly;
  final Function()? onTap;
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.validator,
    required this.text,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: 'Add a $text',
      ),
      onTap: onTap,
      maxLines: text == 'content' ? 10 : 1,
    );
  }
}
