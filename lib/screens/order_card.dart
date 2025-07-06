// ignore_for_file: use_build_context_synchronously

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/helper/api_delete_product_from_cart.dart';
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
    final screen = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: screen.height * 0.01),
        padding: EdgeInsets.symmetric(
          horizontal: screen.width * 0.025,
          vertical: screen.height * 0.015,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: MyColors.background,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              spreadRadius: -8,
              offset: Offset(0, 6),
              color: MyColors.shadow,
            ),
            BoxShadow(
              blurRadius: 4,
              spreadRadius: -8,
              offset: Offset(0, -4),
              color: MyColors.shadow,
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
                width: screen.width * 0.2,
                height: screen.height * 0.09,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    AppStrings.defaultImage,
                    width: screen.width * 0.2,
                    height: screen.height * 0.09,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            SizedBox(width: screen.width * 0.03),

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
                  SizedBox(height: screen.height * 0.01),
                  Text(
                    '${AppStrings.currencyLE} ${orderprice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: screen.width * 0.03),

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
                SizedBox(width: screen.width * 0.015),
                Text(quantity.toString(), style: const TextStyle(fontSize: 16)),
                SizedBox(width: screen.width * 0.015),
                _buildCircleButton(
                  icon: Icons.add,
                  onPressed: () {
                    if (quantity < 10) {
                      onQuantityChanged(quantity + 1);
                    }
                  },
                ),
                SizedBox(width: screen.width * 0.01),

                /// ✅ زر الحذف مع تأكيد
                IconButton(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text(AppStrings.confirmDelete),
                            content: Text(
                              '${AppStrings.deleteMessage} "$ordername"?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text(AppStrings.cancel),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(AppStrings.ok),
                              ),
                            ],
                          ),
                    );

                    if (confirm == true) {
                      try {
                        await DeleteFromCartService.deleteProductFromCart(
                          productId,
                        );
                        onDelete(); // تحديث الواجهة
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${AppStrings.deleteFailed1}: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: screen.width * 0.05,
                  ),
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
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: MyColors.primary,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: Colors.white, size: 16),
        onPressed: onPressed,
      ),
    );
  }
}
