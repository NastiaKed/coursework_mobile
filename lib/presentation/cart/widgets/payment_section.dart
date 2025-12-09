import 'package:flutter/material.dart';

class PaymentSection extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String?> onChanged;

  const PaymentSection({
    required this.selectedMethod,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PaymentCard(
          value: 'card',
          title: 'Карта',
          icon: Icons.credit_card,
          isSelected: selectedMethod == 'card',
          onTap: () => onChanged('card'),
        ),

        const SizedBox(height: 12),

        PaymentCard(
          value: 'cash',
          title: 'Готівка',
          icon: Icons.payments_outlined,
          isSelected: selectedMethod == 'cash',
          onTap: () => onChanged('cash'),
        ),
      ],
    );
  }
}

class PaymentCard extends StatelessWidget {
  final String value;
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentCard({
    required this.value,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? Colors.black : Colors.grey[500],
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),

            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isSelected ? 12 : 0,
                  height: isSelected ? 12 : 0,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
