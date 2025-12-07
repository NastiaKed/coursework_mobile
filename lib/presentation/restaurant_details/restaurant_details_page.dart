import 'package:cours_work/data/models/restaurant.dart';
import 'package:cours_work/data/repositories/cart_repository.dart';
import 'package:cours_work/data/repositories/restaurants_repository.dart';
import 'package:cours_work/data/services/local_storage.dart';
import 'package:cours_work/presentation/cart/state/cart_counter.dart';
import 'package:cours_work/presentation/restaurant_details/widgets/details_app_bar.dart';
import 'package:cours_work/presentation/restaurant_details/widgets/details_header.dart';
import 'package:cours_work/presentation/restaurant_details/widgets/dishes_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RestaurantDetailsPage extends StatefulWidget {
  final int restaurantId;

  const RestaurantDetailsPage({required this.restaurantId, super.key});

  @override
  State<RestaurantDetailsPage> createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> {
  final RestaurantsRepository _restaurantsRepo = RestaurantsRepository();
  final CartRepository _cartRepo = CartRepository();

  Restaurant? restaurant;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadRestaurant();
  }

  Future<void> _loadRestaurant() async {
    try {
      final data = await _restaurantsRepo.fetchRestaurantById(
        widget.restaurantId,
      );

      if (!mounted) return;
      setState(() {
        restaurant = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> addToCart(int dishId, String name) async {
    final userId = await LocalStorage.getUserId();
    if (userId == null) return;

    try {
      HapticFeedback.lightImpact();
      await _cartRepo.addDishToCart(userId: userId, dishId: dishId);
      cartCounter.increment();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$name додано в кошик'),
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.black)),
      );
    }

    if (restaurant == null) {
      return const Scaffold(
        body: Center(child: Text('Помилка завантаження ресторану')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          DetailsAppBar(restaurant: restaurant!),
          DetailsHeader(description: restaurant!.description),
          DishesList(dishes: restaurant!.dishes, onAdd: addToCart),
        ],
      ),
    );
  }
}
