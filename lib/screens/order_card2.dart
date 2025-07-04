import 'package:citio/core/utils/mycolors.dart';
import 'package:flutter/material.dart';

class OrderCard2 extends StatelessWidget {
  const OrderCard2({
    super.key,
    required this.ordername,
    required this.orderprice,
    required this.quantity,
    required this.orderpic,
  });

  final String ordername;
  final double orderprice;
  final int quantity;
  final String orderpic;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 17, top: 10, bottom: 7, right: 17),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.26,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: MyColors.backgroundColor,
        boxShadow: const [
          BoxShadow(
            blurRadius: 14,
            spreadRadius: -8,
            offset: Offset(0, 6),
            color: MyColors.shadow,
          ),
          BoxShadow(
            blurRadius: 9,
            spreadRadius: -7,
            offset: Offset(0, -4),
            color: MyColors.shadow,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  orderpic,
                  width: MediaQuery.of(context).size.width * 0.345,
                  height: MediaQuery.of(context).size.height * 0.154,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
                      width: MediaQuery.of(context).size.width * 0.345,
                      height: MediaQuery.of(context).size.height * 0.154,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),

              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      ordername,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(width: 15),
                        Text(
                          " $quantity",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),

                        const Spacer(),
                        Text(
                          'LE ${orderprice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Row(children: [SizedBox(width: 80)]),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: MyColors.gray),
          Row(
            children: [
              const Text(
                "Total Order:",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
              ),
              const Spacer(),
              Text(
                'LE ${(orderprice * quantity).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
