import 'package:flutter/material.dart';

class GameControls extends StatelessWidget {
  final VoidCallback onLeft;
  final VoidCallback onRight;
  final VoidCallback onRotate;
  final VoidCallback onDown;
  final VoidCallback onHardDrop; // Новая функция для сброса

  const GameControls({
    super.key,
    required this.onLeft,
    required this.onRight,
    required this.onRotate,
    required this.onDown,
    required this.onHardDrop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade900.withOpacity(0.5),
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // D-Pad для перемещения
          SizedBox(
            width: 140,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildControlButton(icon: Icons.arrow_back, onPressed: onLeft),
                    _buildControlButton(icon: Icons.arrow_forward, onPressed: onRight),
                  ],
                ),
                _buildControlButton(icon: Icons.arrow_downward, onPressed: onDown),
              ],
            ),
          ),

          // Кнопки действий
          Row(
            children: [
              _buildActionButton(icon: Icons.rotate_right, onPressed: onRotate, color: Colors.blue.shade400),
              const SizedBox(width: 15),
              // ИСПРАВЛЕНИЕ: Кнопка для мгновенного сброса
              _buildActionButton(icon: Icons.vertical_align_bottom, onPressed: onHardDrop, color: Colors.red.shade400, isLarge: true),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildControlButton({required IconData icon, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
            color: Colors.grey.shade800,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.5), offset: const Offset(2, 2), blurRadius: 3),
              BoxShadow(color: Colors.white.withOpacity(0.1), offset: const Offset(-1, -1), blurRadius: 1),
            ]
        ),
        child: Icon(icon, color: Colors.grey.shade300, size: 30),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required VoidCallback onPressed, required Color color, bool isLarge = false}) {
    double size = isLarge ? 80 : 60;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            color: color.withOpacity(0.8),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
            gradient: RadialGradient(
              colors: [color.withOpacity(0.6), color],
              center: Alignment.topLeft,
              radius: 1.5,
            ),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.6), offset: const Offset(3, 3), blurRadius: 5),
              BoxShadow(color: Colors.white.withOpacity(0.15), offset: const Offset(-2, -2), blurRadius: 2),
            ]
        ),
        child: Icon(icon, size: size * 0.5, color: Colors.white),
      ),
    );
  }
}
