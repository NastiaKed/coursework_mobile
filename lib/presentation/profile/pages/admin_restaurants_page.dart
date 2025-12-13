import 'package:cours_work/data/repositories/admin_repository.dart';
import 'package:cours_work/data/services/local_storage.dart';
import 'package:cours_work/presentation/profile/pages/widgets/edit_restaurant_dialog.dart';
import 'package:cours_work/presentation/profile/pages/widgets/restaurant_card.dart';
import 'package:flutter/material.dart';

class AdminRestaurantsPage extends StatefulWidget {
  const AdminRestaurantsPage({super.key});

  @override
  State<AdminRestaurantsPage> createState() => _AdminRestaurantsPageState();
}

class _AdminRestaurantsPageState extends State<AdminRestaurantsPage> {
  final AdminRepository _repo = AdminRepository();

  bool loading = true;
  List<Map<String, dynamic>> restaurants = [];

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  Future<void> _loadRestaurants() async {
    final isAdmin = await LocalStorage.getIsAdmin();

    if (!isAdmin) {
      if (mounted) {
        setState(() {
          loading = false;
          restaurants = [];
        });
      }
      return;
    }

    try {
      final list = await _repo.fetchRestaurants();
      if (mounted) {
        setState(() {
          restaurants = list;
          loading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading restaurants: $e');
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _deleteRestaurant(int id) async {
    final ok = await _repo.deleteRestaurant(id);
    if (ok) {
      setState(() {
        restaurants.removeWhere((r) => r['id'] == id);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Ресторан видалено'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void _showEditDialog(Map<String, dynamic> restaurant) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => EditRestaurantDialog(
        restaurant: restaurant,
        onSuccess: _loadRestaurants,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LocalStorage.getIsAdmin(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator(color: Colors.black)),
          );
        }

        if (snapshot.data == false) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Text(
                'У вас немає доступу',
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text(
              'Адмін — Ресторани',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
          ),
          body: loading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: restaurants.length,
                  itemBuilder: (_, i) {
                    final r = restaurants[i];
                    return RestaurantCard(
                      restaurant: r,
                      onEdit: () => _showEditDialog(r),
                      onDelete: () {
                        final id = int.tryParse(r['id'].toString());
                        if (id != null) _deleteRestaurant(id);
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
