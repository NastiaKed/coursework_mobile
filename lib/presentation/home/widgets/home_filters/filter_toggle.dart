import 'package:flutter/material.dart';

class FilterToggle extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const FilterToggle({
    required this.text,
    required this.active,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 1.3,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
