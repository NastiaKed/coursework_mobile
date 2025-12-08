import 'package:flutter/material.dart';

enum DeliveryType { courier, pickup }

class DeliverySection extends StatelessWidget {
  final DeliveryType selectedType;
  final double deliveryFee;
  final ValueChanged<DeliveryType> onTypeChanged;

  const DeliverySection({
    required this.selectedType,
    required this.deliveryFee,
    required this.onTypeChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DeliveryOptionCard(
            title: "Кур'єр",
            subtitle: "${deliveryFee.toStringAsFixed(0)} ₴",
            icon: Icons.delivery_dining,
            isSelected: selectedType == DeliveryType.courier,
            onTap: () => onTypeChanged(DeliveryType.courier),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DeliveryOptionCard(
            title: "Самовивіз",
            subtitle: "Безкоштовно",
            icon: Icons.storefront_outlined,
            isSelected: selectedType == DeliveryType.pickup,
            onTap: () => onTypeChanged(DeliveryType.pickup),
          ),
        ),
      ],
    );
  }
}

class DeliveryOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const DeliveryOptionCard({
    required this.title,
    required this.subtitle,
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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[100],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? Colors.white : Colors.black87,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}