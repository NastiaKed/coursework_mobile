import 'package:cours_work/data/models/restaurant.dart';
import 'package:cours_work/presentation/restaurant_details/widgets/dish_card.dart';
import 'package:flutter/material.dart';

class DishesList extends StatelessWidget {
  final List<Dish> dishes;
  final void Function(int id, String name) onAdd;

  const DishesList({required this.dishes, required this.onAdd, super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => DishCard(dish: dishes[index], onAdd: onAdd),
          childCount: dishes.length,
        ),
      ),
    );
  }
}
