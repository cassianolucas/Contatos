import 'package:flutter/material.dart';

class BotaoPadrao extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const BotaoPadrao({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        width: double.maxFinite,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.orange[600],
          gradient: LinearGradient(
            colors: [
              Colors.orange[600]!,
              Colors.orange[400]!,
            ],
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
