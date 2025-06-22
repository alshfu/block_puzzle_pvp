import 'package:flutter/material.dart';
import 'dart:math';

class IdenticonAvatar extends StatelessWidget {
  final String text;
  final int seed;
  final double size;

  const IdenticonAvatar({
    super.key,
    required this.text,
    this.seed = 0,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    final random = Random(text.hashCode + seed);

    final color = Color.fromARGB(
      255,
      100 + random.nextInt(156),
      100 + random.nextInt(156),
      100 + random.nextInt(156),
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text.isNotEmpty ? text[0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: size * 0.5,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
