import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/helper/api_delete_product_frome_cart.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.ordername,
    required this.orderprice,
    required this.quantity,
    required this.orderpic,
    required this.productId,
    required this.onQuantityChanged,
    required this.onDelete,
  });

  final int productId;
  final Function(int) onQuantityChanged;
  final Function() onDelete;
  final String ordername;
  final double orderprice;
  final int quantity;
  final String orderpic;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: MyAppColors.background,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              spreadRadius: -8,
              offset: Offset(0, 6),
              color: MyAppColors.shadow,
            ),
            BoxShadow(
              blurRadius: 4,
              spreadRadius: -8,
              offset: Offset(0, -4),
              color: MyAppColors.shadow,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// ✅ صورة المنتج
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                orderpic,
                width: 80,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
                    width: 80,
                    height: 70,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(width: 10),

            /// ✅ اسم المنتج والسعر
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ordername,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'LE ${orderprice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            /// ✅ العداد وزر الحذف
            Row(
              children: [
                _buildCircleButton(
                  icon: Icons.remove,
                  onPressed: () {
                    if (quantity > 1) {
                      onQuantityChanged(quantity - 1);
                    }
                  },
                ),
                const SizedBox(width: 6),
                Text(quantity.toString(), style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                _buildCircleButton(
                  icon: Icons.add,
                  onPressed: () {
                    if (quantity < 10) {
                      onQuantityChanged(quantity + 1);
                    }
                  },
                ),
                const SizedBox(width: 3),

                /// ✅ زر الحذف
                IconButton(
                  onPressed: () async {
                    try {
                      await DeleteFromCartService.deleteProductFromCart(
                        productId,
                      );
                      onDelete(); // حدث الواجهة بعد الحذف
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("فشل الحذف: $e"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blueAccent,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: Colors.white, size: 16),
        onPressed: onPressed,
      ),
    );
  }
}
