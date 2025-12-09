import 'package:cours_work/data/repositories/admin_repository.dart';
import 'package:flutter/material.dart';

class EditRestaurantDialog extends StatefulWidget {
  final Map<String, dynamic> restaurant;
  final VoidCallback onSuccess;

  const EditRestaurantDialog({
    required this.restaurant,
    required this.onSuccess,
    super.key,
  });

  @override
  State<EditRestaurantDialog> createState() => _EditRestaurantDialogState();
}

class _EditRestaurantDialogState extends State<EditRestaurantDialog> {
  final AdminRepository _repo = AdminRepository();

  late TextEditingController nameCtrl;
  late TextEditingController descCtrl;
  late TextEditingController imgCtrl;
  late TextEditingController ratingCtrl;
  late TextEditingController timeCtrl;
  late TextEditingController feeCtrl;
  late TextEditingController minOrderCtrl;
  late TextEditingController distanceCtrl;

  late bool isActive;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final r = widget.restaurant;
    nameCtrl = TextEditingController(text: r['name']?.toString() ?? '');
    descCtrl = TextEditingController(text: r['description']?.toString() ?? '');
    imgCtrl = TextEditingController(text: r['image_url']?.toString() ?? '');
    ratingCtrl = TextEditingController(text: (r['rating'] ?? 0).toString());
    timeCtrl = TextEditingController(text: (r['delivery_time'] ?? 0).toString());
    feeCtrl = TextEditingController(text: (r['delivery_fee'] ?? 0).toString());
    minOrderCtrl = TextEditingController(text: (r['min_order'] ?? 0).toString());
    distanceCtrl = TextEditingController(text: (r['distance'] ?? 0).toString());

    isActive = r['is_active'] == 1 || r['is_active'] == true;
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    descCtrl.dispose();
    imgCtrl.dispose();
    ratingCtrl.dispose();
    timeCtrl.dispose();
    feeCtrl.dispose();
    minOrderCtrl.dispose();
    distanceCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => isLoading = true);
    try {
      final id = int.tryParse(widget.restaurant['id'].toString()) ?? 0;

      await _repo.updateRestaurant(
        id: id,
        name: nameCtrl.text,
        description: descCtrl.text,
        imageUrl: imgCtrl.text,
        rating: double.tryParse(ratingCtrl.text) ?? 0,
        deliveryTime: int.tryParse(timeCtrl.text) ?? 0,
        deliveryFee: double.tryParse(feeCtrl.text) ?? 0,
        minOrder: double.tryParse(minOrderCtrl.text) ?? 0,
        distance: double.tryParse(distanceCtrl.text) ?? 0,
        isActive: isActive,
      );

      if (!mounted) return;
      widget.onSuccess();
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Помилка: $e")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 800),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Редагувати ресторан',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 24),
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(nameCtrl, 'Назва ресторану'),
                      const SizedBox(height: 16),
                      _buildTextField(descCtrl, 'Опис', maxLines: 3),
                      const SizedBox(height: 16),
                      _buildTextField(imgCtrl, 'Посилання на фото'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildTextField(ratingCtrl, 'Рейтинг', isNumber: true)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildTextField(timeCtrl, 'Час (хв)', isNumber: true)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildTextField(feeCtrl, 'Доставка ₴', isNumber: true)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildTextField(minOrderCtrl, 'Мін. зам. ₴', isNumber: true)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(distanceCtrl, 'Відстань (км)', isNumber: true),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Активний', style: TextStyle(fontWeight: FontWeight.w600)),
                          activeColor: Colors.black,
                          value: isActive,
                          onChanged: (v) => setState(() => isActive = v),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[600],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Скасувати', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: isLoading ? null : _save,
                      child: isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                          : const Text('Зберегти', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label, {
        int maxLines = 1,
        bool isNumber = false,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[700]),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(fontWeight: FontWeight.w500),
          cursorColor: Colors.black,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}