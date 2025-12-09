import 'package:flutter/material.dart';

class HomeCategories extends StatelessWidget {
  final List<String> categories;
  final void Function(int categoryId) onCategorySelected;
  final int? selectedIndex;

  const HomeCategories({
    required this.categories,
    required this.onCategorySelected,
    required this.selectedIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(categories.length, (i) {
        final isSelected = selectedIndex == i + 1;

        return GestureDetector(
          onTap: () => onCategorySelected(i + 1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.black,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                width: 1.2,
              ),
            ),
            child: Text(
              categories[i],
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
  }
}
