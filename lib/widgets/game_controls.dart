import 'package:flutter/material.dart';

class GameControls extends StatelessWidget {
  final VoidCallback onLeft;
  final VoidCallback onRight;
  final VoidCallback onRotate;
  final VoidCallback onDown;

  const GameControls({
    super.key,
    required this.onLeft,
    required this.onRight,
    required this.onRotate,
    required this.onDown,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.grey.shade900,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildControlButton(icon: Icons.arrow_left, onPressed: onLeft),
            _buildControlButton(icon: Icons.rotate_right, onPressed: onRotate),
            _buildControlButton(icon: Icons.arrow_downward, onPressed: onDown),
            _buildControlButton(icon: Icons.arrow_right, onPressed: onRight),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({required IconData icon, required VoidCallback onPressed}) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      iconSize: 36,
      onPressed: onPressed,
    );
  }
}
