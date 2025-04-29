import 'package:city/core/utils/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:item_count_number_button/item_count_number_button.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.image,
    required this.ordername,
    required this.orderrate,
    required this.orderprice,
    required this.orderoldprice,
  });
  final String image;
  final String ordername;
  final String orderrate;
  final String orderprice;
  final String orderoldprice;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 17, top: 10, bottom: 7, right: 17),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.26,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: MyAppColors.background,
        boxShadow: const [
          BoxShadow(
            blurRadius: 14,
            spreadRadius: -8,
            offset: Offset(0, 6),
            color: MyAppColors.shadow,
          ),
          BoxShadow(
            blurRadius: 9,
            spreadRadius: -7,
            offset: Offset(0, -4),
            color: MyAppColors.shadow,
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
              Container(
                margin: const EdgeInsets.only(left: 1),
                width: MediaQuery.of(context).size.width * 0.345,
                height: MediaQuery.of(context).size.height * 0.154,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ordername,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(orderrate),
                      const Icon(Icons.star, color: MyAppColors.yellow),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        orderoldprice,
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: MyAppColors.pricegray,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 40),
                      Text(
                        orderprice,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const SizedBox(width: 80),
                      ItemCount(
                        color: MyAppColors.red,
                        initialValue: 1,
                        step: 1,
                        minValue: 1,
                        maxValue: 10,
                        decimalPlaces: 0,
                        onChanged: (value) {
                          //using cubit to change the  value
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const Text(
            style: TextStyle(color: MyAppColors.gray),
            "_______________________________________________",
          ),

          Row(
            children: [
              const Text(
                "Total Order :",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
              ),
              const SizedBox(width: 170),
              Text(
                orderprice,
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
