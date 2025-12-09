import 'package:cours_work/data/models/restaurant.dart';
import 'package:cours_work/navigation/app_routes.dart';
import 'package:flutter/material.dart';

class HomeRestaurantsList extends StatelessWidget {
  final List<Restaurant> restaurants;

  const HomeRestaurantsList({required this.restaurants, super.key});

  void _openRestaurantDetails(BuildContext context, Restaurant restaurant) {
    Navigator.pushNamed(
      context,
      AppRoutes.restaurantDetails,
      arguments: restaurant.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (restaurants.isEmpty) {
      return const Center(
        child: Text(
          'No restaurants available',
          style: TextStyle(color: Colors.black54, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: restaurants.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemBuilder: (context, index) {
        final r = restaurants[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _openRestaurantDetails(context, r),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12, width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: r.imageUrl.startsWith('http')
                        ? Image.network(
                            r.imageUrl,
                            height: 170,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                              'assets/images/food.png',
                              height: 170,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            r.imageUrl,
                            height: 170,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Text(
                      r.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.pedal_bike,
                          size: 16,
                          color: Colors.black87,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${r.deliveryTime} min',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(width: 16),

                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          r.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),

                        const Spacer(),

                        Text(
                          r.deliveryFee == 0
                              ? 'Free'
                              : '${r.deliveryFee.toStringAsFixed(0)}₴',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
