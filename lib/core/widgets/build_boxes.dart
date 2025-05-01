// ignore_for_file: deprecated_member_use

import 'package:city/core/utils/mycolors.dart';
import 'package:city/models/most_requested_services.dart';
import 'package:city/services/get_most_requested_services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
Map<String, String> icons = {
  "إصدار جواز سفر": 'https://cdn-icons-png.flaticon.com/128/4774/4774004.png',
  "رخصة قيادة": 'https://cdn-icons-png.flaticon.com/128/18395/18395873.png',
  "شهادة ميلاد": 'https://cdn-icons-png.flaticon.com/128/14236/14236286.png',
  "شهادة زواج": 'https://cdn-icons-png.flaticon.com/128/9835/9835447.png',
  "تأمين صحي": 'https://cdn-icons-png.flaticon.com/128/6512/6512351.png',
};

class BuildBoxes extends StatelessWidget {
  //BuildContext context;
  final List<MostRequested> items;
  final String title;
  final double width;
  final String details;
  final double height;

  final double imageHeight;
  final double imageWidth;
  final BoxFit fit;
  final EdgeInsetsGeometry imagePadding;
  // final int itemCount;
  final Widget destination;

  const BuildBoxes({
    super.key,
    required this.title,
    required this.items,
    required this.details,
    required this.destination,
    required this.fit,
    required this.height,

    required this.imageHeight,
    required this.imagePadding,
    required this.imageWidth,
    //  required this.itemCount,
    required this.width,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'عرض الجميع',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 99, 167, 222),
                              fontSize: 12,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => destination,
                                      ),
                                    );
                                  },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // const SizedBox(height: 10.0),
        SizedBox(
          height: height,

          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ServiceDetailsScreen(
                              serviceName: items[index].serviceName,
                            ),
                      ),
                    ),
                child: ServiceBox(
                  title: items[index].serviceName,
                  width: width,
                  details:
                      'يستغرق استخراجه ${items[index].time} بتكلفة  ${items[index].fee} جنيهًا فقط لا غير',
                  image:
                      icons[items[index].serviceName] ??
                      'https://cdn-icons-png.flaticon.com/128/13434/13434972.png',
                  imageHeight: imageHeight,
                  imageWidth: imageWidth,
                  fit: fit,
                  imagePadding: imagePadding,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
}

class ServiceBox extends StatelessWidget {
  final String title;
  final String details;
  final double width;
  final String image;
  final double imageHeight;
  final double imageWidth;
  final BoxFit? fit;
  final EdgeInsetsGeometry imagePadding;
  const ServiceBox({
    super.key,
    required this.title,
    required this.width,
    required this.details,
    required this.image,
    required this.imageHeight,
    required this.imageWidth,
    required this.imagePadding,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.fromLTRB(4, 2, 4, 2),
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            // ignore: deprecated_member_use
            color: MyColors.whiteSmoke,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Padding(
              padding: imagePadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.network(
                    width: imageWidth,
                    height: imageHeight,
                    image,
                    fit: fit,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    maxLines: 2,
                    details,
                    style: const TextStyle(
                      color: Color.fromARGB(221, 59, 58, 58),
                      fontSize: 12.0,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceDetailsScreen extends StatelessWidget {
  final String serviceName;
  const ServiceDetailsScreen({super.key, required this.serviceName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(serviceName)),
      body: Center(
        child: Text(
          'تفاصيل الخدمة: $serviceName',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
