import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/helper/api_delete_product_from_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        margin: EdgeInsets.only(bottom: 5.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
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
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                orderpic,
                width: 80.w,
                height: 70.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
                    width: 80.w,
                    height: 70.h,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            SizedBox(width: 10.w),

            /// ✅ اسم المنتج والسعر
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ordername,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'LE ${orderprice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),

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
                SizedBox(width: 6.w),
                Text(quantity.toString(), style: TextStyle(fontSize: 16.sp)),
                SizedBox(width: 6.w),
                _buildCircleButton(
                  icon: Icons.add,
                  onPressed: () {
                    if (quantity < 10) {
                      onQuantityChanged(quantity + 1);
                    }
                  },
                ),
                SizedBox(width: 3.w),

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
                  icon: Icon(Icons.delete, color: Colors.red, size: 20.sp),
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
      width: 20.w,
      height: 20.h,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blueAccent,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: Colors.white, size: 16.sp),
        onPressed: onPressed,
      ),
    );
  }
}
