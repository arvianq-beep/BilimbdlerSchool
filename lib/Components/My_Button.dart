import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback? onTap; // ✅ теперь можно передавать null
  final String text;

  const MyButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onTap, // если null → кнопка автоматически дизейблится
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(text),
        ),
      ),
    );
  }
}
