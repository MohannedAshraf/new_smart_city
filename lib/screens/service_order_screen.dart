import 'package:city/core/utils/assets_image.dart';
import 'package:city/core/utils/variables.dart';
import 'package:city/core/widgets/category_circle.dart';
import 'package:city/core/widgets/categorysubcategory.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ServiceOrderScreen extends StatefulWidget {
  const ServiceOrderScreen({super.key});

  @override
  State<ServiceOrderScreen> createState() => _ServiceOrderScreenState();
}

class _ServiceOrderScreenState extends State<ServiceOrderScreen> {
  final List<String> imageList = [
    MyAssetsImage.burger,
    MyAssetsImage.sandwitch,
    MyAssetsImage.drink,
    MyAssetsImage.nescalop,
  ];

  late TextEditingController _controller;
  String searchText = "";
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                controller: _controller,
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search),
                  hintText: "ابحث  عن اي  خدمه ",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CategoryCircle(circlename: "Food"),
                  CategoryCircle(circlename: "Beverages"),
                  CategoryCircle(circlename: "Clothing"),
                  CategoryCircle(circlename: "Eltronics"),
                  CategoryCircle(circlename: "Health&Personal Care "),
                  CategoryCircle(circlename: "Public Services"),
                  CategoryCircle(circlename: "Education"),
                  CategoryCircle(circlename: "Entertainment"),
                  CategoryCircle(circlename: "Furniture"),
                  CategoryCircle(circlename: "Automotive Services "),
                ],
              ),
            ),
            const SizedBox(height: 30),
            CarouselSlider(
              items:
                  imageList.map((imagePath) {
                    return Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  }).toList(),
              options: CarouselOptions(
                height: 190.0,
                autoPlay: true,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  imageList.asMap().entries.map((entry) {
                    return Container(
                      width: 10.0,
                      height: 10.0,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            _currentIndex == entry.key
                                ? const Color(
                                  0xFF3D6643,
                                ) // اللون اللي انت عايزه
                                : Colors.grey,
                      ),
                    );
                  }).toList(),
            ),

            const SizedBox(height: 30),

            const Categorysubcategory(
              category: "Food",
              subcat: "Fast Food",
              subcat1: "Bakeries",
              subcat2: "Seafood",
              subcat3: "Snacks",
              subcat4: "Organic Food",
              subcat5: "Dairy Products",
            ),
            const SizedBox(height: 30),
            const Categorysubcategory(
              category: "Beverages",
              subcat: "Juices",
              subcat1: "Soft Drinks",
              subcat2: "Tea",
              subcat3: "Coffee Beans",
              subcat4: "Energy Drinks",
            ),
            const SizedBox(height: 30),
            const Categorysubcategory(
              category: "Clothing",
              subcat: "Men's Clothing",
              subcat1: "Women's Clothing",
              subcat2: "Children's Clothing",
              subcat3: "Sportswear",
              subcat4: "Accessories",
            ),
            const SizedBox(height: 30),
            const Categorysubcategory(
              category: "Electronics",
              subcat: "Mobile Phones",
              subcat1: "Laptops",
              subcat2: "Gaming Consoles",
              subcat3: "Televisions",
              subcat4: "Accessories",
              subcat5: "Air Conditioners",
              subcat6: "Refrigerators",
              subcat7: "Washing Machines",
              subcat8: "Microwave Ovens",
              subcat9: "Cameras",
            ),
            const SizedBox(height: 30),
            const Categorysubcategory(
              category: "Health & Personal Care",
              subcat: "Hair Salons",
              subcat1: "Fitness Centers",
              subcat2: "Clinics",
              subcat3: "Pharmacies",
              subcat4: "Spas",
            ),
            const SizedBox(height: 30),
            const Categorysubcategory(
              category: "Public Services",
              subcat: "Electricity",
              subcat1: "Water Supply",
              subcat2: "Waste Collection",
              subcat3: "Public Transportation",
              subcat4: "Emergency Services",
              subcat5: "Postal Services",
            ),
            const SizedBox(height: 30),
            const Categorysubcategory(
              category: "Education & Training",
              subcat: "Schools",
              subcat1: "Universities",
              subcat2: "Language Centers",
              subcat3: "Online Courses",
              subcat4: "Skill Development",
            ),
            const SizedBox(height: 30),
            const Categorysubcategory(
              category: "Entertainment",
              subcat: "Cinemas",
              subcat1: "Theme Parks",
              subcat2: "Concerts",
              subcat3: "Gaming Centers",
              subcat4: "Theaters",
            ),
            const SizedBox(height: 30),
            const Categorysubcategory(
              category: "Furniture",
              subcat: "Living Room Furniture",
              subcat1: "Bedroom Furniture",
              subcat2: "Office Furniture",
              subcat3: "Outdoor Furniture",
              subcat4: "Decor",
            ),
            const SizedBox(height: 30),
            const Categorysubcategory(
              category: "Automotive Services",
              subcat: "Car Wash",
              subcat1: "Tire Shops",
              subcat2: "Auto Repair",
              subcat3: "Car Rentals",
              subcat4: "Car Accessories",
            ),
          ],
        ),
      ),
    );
  }
}

// class ServiceOrderScreen extends StatelessWidget {
//   const ServiceOrderScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(
//         centerTitle:  true, 
//         title:  const  Text("Service Order") ,
//         backgroundColor: const Color(0xFF3D6643),


//       ),
//     );
//   }
// }