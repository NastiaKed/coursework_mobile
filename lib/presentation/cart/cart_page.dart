import 'package:cours_work/data/models/cart.dart';
import 'package:cours_work/data/repositories/cart_repository.dart';
import 'package:cours_work/data/services/local_storage.dart';
import 'package:cours_work/data/services/notification_service.dart';
import 'package:cours_work/navigation/app_routes.dart';
import 'package:cours_work/presentation/cart/state/cart_counter.dart';
import 'package:cours_work/presentation/cart/widgets/address_section.dart';
import 'package:cours_work/presentation/cart/widgets/cart_item_tile.dart';
import 'package:cours_work/presentation/cart/widgets/cart_summary_card.dart';
import 'package:cours_work/presentation/cart/widgets/delivery_section.dart';
import 'package:cours_work/presentation/cart/widgets/edit_address_dialog.dart';
import 'package:cours_work/presentation/cart/widgets/payment_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartRepository _cartRepo = CartRepository();

  static const double _fixedDeliveryFee = 40;

  List<CartItem> _cart = [];
  bool _loading = true;
  String _address = '';
  String _paymentMethod = 'card';
  DeliveryType _deliveryType = DeliveryType.courier;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([_loadCart(), _loadLocalPrefs()]);
  }

  Future<void> _loadCart() async {
    final int? userId = await LocalStorage.getUserId();

    if (userId == null) {
      debugPrint('❌ userId == null — користувач не авторизований');
      setState(() => _loading = false);
      return;
    }

    final data = await _cartRepo.fetchCart(userId);

    if (mounted) {
      setState(() {
        _cart = data;
        _loading = false;
      });
    }
  }

  Future<void> _loadLocalPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _address = prefs.getString('address') ?? 'вул. Антоновича 1488';
        _paymentMethod = prefs.getString('payment') ?? 'card';
      });
    }
  }

  Future<void> _updateAddress() async {
    final newAddress = await showEditAddressDialog(context, _address);
    if (newAddress != null && mounted) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('address', newAddress);
      setState(() => _address = newAddress);
    }
  }

  Future<void> _changePayment(String? value) async {
    if (value == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('payment', value);
    setState(() => _paymentMethod = value);
  }

  Future<void> _checkout() async {
    final int? userId = await LocalStorage.getUserId();
    if (!mounted) return;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Помилка: користувач не авторизований')),
      );
      return;
    }

    HapticFeedback.mediumImpact();

    final ok = await _cartRepo.checkout(userId);

    if (!mounted) return;

    if (ok) {
      cartCounter.reset();
      _startNotifications();
      Navigator.pushNamed(context, AppRoutes.success);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Помилка оформлення')),
      );
    }
  }

  void _startNotifications() {
    NotificationService.showNotification(
      id: 1,
      title: 'Замовлення прийнято',
      body: 'Ми вже працюємо над вашим замовленням ❤️',
      delaySeconds: 5,
    );
    NotificationService.showNotification(
      id: 2,
      title: 'Готуємо вашу страву',
      body: 'Шеф вже чарує над нею 👨‍🍳🔥',
      delaySeconds: 12,
    );
    NotificationService.showNotification(
      id: 5,
      title: 'Замовлення доставлено',
      body: 'Смачного! 😍',
      delaySeconds: 50,
    );
  }

  double get _foodSum {
    return _cart.fold(0, (sum, item) => sum + (item.dishPrice * item.quantity));
  }

  double get _currentDeliveryPrice {
    return _deliveryType == DeliveryType.courier ? _fixedDeliveryFee : 0.0;
  }

  double get _totalSum => _foodSum + _currentDeliveryPrice;

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Colors.black)),
      );
    }

    if (_cart.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text('Кошик', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
              const SizedBox(height: 16),
              const Text('Кошик порожній', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Кошик',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          _buildSectionTitle('Замовлення'),
          Container(
            decoration: _boxDecoration(),
            child: Column(
              children: [
                ..._cart.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: CartItemTile(item: item),
                      ),
                      if (index != _cart.length - 1)
                        Divider(height: 1, color: Colors.grey[200], indent: 16, endIndent: 16),
                    ],
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 24),

          _buildSectionTitle('Доставка'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _boxDecoration(),
            child: Column(
              children: [
                DeliverySection(
                  selectedType: _deliveryType,
                  deliveryFee: _fixedDeliveryFee,
                  onTypeChanged: (type) => setState(() => _deliveryType = type),
                ),
                if (_deliveryType == DeliveryType.courier) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Divider(height: 1, color: Colors.grey[200]),
                  ),
                  AddressSection(address: _address, onTap: _updateAddress),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          _buildSectionTitle('Оплата'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _boxDecoration(),
            child: PaymentSection(
              selectedMethod: _paymentMethod,
              onChanged: _changePayment,
            ),
          ),

          const SizedBox(height: 32),

          CartSummaryCard(
            totalSum: _totalSum,
            bonus: _foodSum * 0.05,
            onCheckout: _checkout,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}