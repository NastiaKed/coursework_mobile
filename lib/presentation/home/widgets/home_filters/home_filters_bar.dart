import 'package:cours_work/presentation/home/cubit/restaurants_cubit.dart';
import 'package:cours_work/presentation/home/widgets/home_filters/filter_dropdown.dart';
import 'package:cours_work/presentation/home/widgets/home_filters/filter_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeFiltersBar extends StatefulWidget {
  const HomeFiltersBar({super.key});

  @override
  State<HomeFiltersBar> createState() => _HomeFiltersBarState();
}

class _HomeFiltersBarState extends State<HomeFiltersBar> {
  bool promoActive = false;
  bool takeawayActive = false;
  bool popularActive = false;

  String? selectedSort;
  String? selectedDeliveryType;

  final List<Map<String, String>> sortOptions = [
    {'label': 'Rating ↑', 'value': 'rating_asc'},
    {'label': 'Rating ↓', 'value': 'rating_desc'},
    {'label': 'Delivery fee ↑', 'value': 'delivery_fee_asc'},
    {'label': 'Delivery fee ↓', 'value': 'delivery_fee_desc'},
    {'label': 'Distance ↑', 'value': 'distance_asc'},
    {'label': 'Distance ↓', 'value': 'distance_desc'},
  ];

  final List<Map<String, String>> deliveryOptions = [
    {'label': 'All types', 'value': 'all'},
    {'label': 'Delivery', 'value': 'delivery'},
    {'label': 'Pickup', 'value': 'pickup'},
  ];

  void _applyTextFilters() {
    final textFilters = <int>[];
    if (promoActive) textFilters.add(1);
    if (takeawayActive) textFilters.add(3);
    if (popularActive) textFilters.add(4);

    context.read<RestaurantsCubit>().applyFilters(
      categoryIds: [],
      textFilterIds: textFilters,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 4),

          FilterToggle(
            text: 'Promotions',
            active: promoActive,
            onTap: () {
              setState(() => promoActive = !promoActive);
              _applyTextFilters();
            },
          ),
          const SizedBox(width: 8),

          FilterToggle(
            text: 'Takeaway',
            active: takeawayActive,
            onTap: () {
              setState(() => takeawayActive = !takeawayActive);
              _applyTextFilters();
            },
          ),
          const SizedBox(width: 8),

          FilterDropdown(
            label: 'Sort by',
            selectedValue: selectedSort,
            options: sortOptions,
            onChanged: (value) {
              setState(() => selectedSort = value);
              if (value != null) {
                context.read<RestaurantsCubit>().sortRestaurants(value);
              }
            },
          ),
          const SizedBox(width: 8),

          FilterDropdown(
            label: 'Delivery type',
            selectedValue: selectedDeliveryType,
            options: deliveryOptions,
            onChanged: (value) {
              setState(() => selectedDeliveryType = value);
              debugPrint('Delivery type: $value');
            },
          ),
          const SizedBox(width: 8),

          FilterToggle(
            text: 'Most popular',
            active: popularActive,
            onTap: () {
              setState(() => popularActive = !popularActive);
              _applyTextFilters();
            },
          ),

          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
