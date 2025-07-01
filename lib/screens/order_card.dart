import 'package:citio/core/utils/mycolors.dart';
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.00625,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.025,
          vertical: MediaQuery.of(context).size.height * 0.0125,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width * 0.025,
          ),
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
              borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * 0.02,
              ),
              child: Image.network(
                orderpic,
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.0875,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.0875,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.025),

            /// ✅ اسم المنتج والسعر
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ordername,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.0175,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.00625,
                  ),
                  Text(
                    'LE ${orderprice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.01875,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.025),

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
                  context: context,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                Text(
                  quantity.toString(),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                _buildCircleButton(
                  icon: Icons.add,
                  onPressed: () {
                    if (quantity < 10) {
                      onQuantityChanged(quantity + 1);
                    }
                  },
                  context: context,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.0075),

                /// ✅ زر الحذف مع رسالة تأكيد
                IconButton(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('تأكيد الحذف'),
                            content: Text('هل تود حذف "$ordername"؟'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('إلغاء'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('موافق'),
                              ),
                            ],
                          ),
                    );

                    if (confirm == true) {
                      try {
                        await DeleteFromCartService.deleteProductFromCart(
                          productId,
                        );
                        onDelete(); // حدث الواجهة بعد الحذف
                      } catch (e) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("فشل الحذف: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: MediaQuery.of(context).size.height * 0.025,
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
    required BuildContext context,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.05,
      height: MediaQuery.of(context).size.height * 0.0250,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blueAccent,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          color: Colors.white,
          size: MediaQuery.of(context).size.height * 0.02,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
