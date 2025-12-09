import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    required this.selectedIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(Icons.home_outlined, 0),
          _buildItem(Icons.shopping_cart_outlined, 1),
          _buildItem(Icons.person_outline, 2),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, int index) {
    final bool active = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Icon(
        icon,
        size: 35,
        color: active ? Colors.black : Colors.black.withValues(alpha: 0.35),
      ),
    );
  }
}
