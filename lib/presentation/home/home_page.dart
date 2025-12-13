import 'package:cours_work/presentation/home/cubit/restaurants_cubit.dart';
import 'package:cours_work/presentation/home/widgets/home_categories.dart';
import 'package:cours_work/presentation/home/widgets/home_filters/home_filters_bar.dart';
import 'package:cours_work/presentation/home/widgets/home_restaurants_list.dart';
import 'package:cours_work/presentation/home/widgets/home_subscribe_brands.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    const categories = [
      'Pizza',
      'Burger',
      'Kebab',
      'Breakfast',
      'Sweet',
      'Baking',
      'Sushi',
      'Italian cuisine',
    ];

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Explore Menu',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),

                    Align(
                      child: Image.asset(
                        'assets/images/home_illustration.png',
                        height: 170,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: HomeCategories(
                  categories: categories,
                  selectedIndex: _selectedCategoryId,
                  onCategorySelected: (categoryId) async {
                    setState(() {
                      _selectedCategoryId = _selectedCategoryId == categoryId
                          ? null
                          : categoryId;
                    });

                    final cubit = context.read<RestaurantsCubit>();

                    if (_selectedCategoryId == null) {
                      await cubit.applyFilters(
                        categoryIds: [],
                        textFilterIds: [],
                      );
                    } else {
                      await cubit.applyFilters(
                        categoryIds: [_selectedCategoryId!],
                        textFilterIds: [],
                      );
                    }
                  },
                ),
              ),

              const SizedBox(height: 25),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: HomeFiltersBar(),
              ),

              const SizedBox(height: 25),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: HomeSubscribeBrands(),
              ),

              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BlocBuilder<RestaurantsCubit, RestaurantsState>(
                  builder: (context, state) {
                    if (state is RestaurantsLoading) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.black),
                        ),
                      );
                    } else if (state is RestaurantsLoaded) {
                      return HomeRestaurantsList(
                        restaurants: state.restaurants,
                      );
                    } else if (state is RestaurantsError) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Text(
                          'Error: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text(
                          'No restaurants found',
                          style: TextStyle(color: Colors.black54, fontSize: 16),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
