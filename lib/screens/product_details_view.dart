import 'package:city/core/utils/assets_image.dart';
import 'package:city/core/utils/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:item_count_number_button/item_count_number_button.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  int itemCount = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () {},
        child: SvgPicture.asset(
          "assets/icon/actionbutton.svg",
          width: 80, // حجم مناسب للزر
          height: 60,
        ),
      ),

      appBar: AppBar(centerTitle: true, title: const Text("اسم المنتج ")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 16),
              margin: const EdgeInsets.only(
                // left: 10,
                top: 30,
                bottom: 30,
                // right: 30,
              ),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 16, right: 12),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                    //  margin: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: AssetImage(MyAssetsImage.nescalop),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  // Align(
                  //   alignment: AlignmentDirectional.topEnd,
                  //   child: SvgPicture.asset("assets/icon/redheart.svg"),
                  // ),
                ],
              ),
            ),
            const Row(
              children: [
                Text(
                  " اسم المنتج",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 160),
                Text(
                  " اسم المالك",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text(
              " الوصف",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: [
                  const Text(
                    "150 ج",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  ItemCount(
                    color: Colors.red,
                    initialValue: itemCount,
                    step: 1,

                    minValue: 1,
                    maxValue: 10,
                    decimalPlaces: 0,
                    onChanged: (value) {
                      setState(() {
                        itemCount = value.toInt();
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.064,
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.red,
              ),
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تم إضافة $itemCount منتج إلى العربة بنجاح!',
                      ),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "أضف إلي العربه ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
