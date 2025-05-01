import 'package:city/core/utils/mycolors.dart';
import 'package:city/core/widgets/build_boxes.dart';
import 'package:city/core/widgets/custom_card.dart';
import 'package:city/models/available_services.dart';
import 'package:city/models/most_requested_services.dart';
import 'package:city/services/get_most_requested_services.dart';
import 'package:flutter/material.dart';

class GovServicesDatails extends StatelessWidget {
  const GovServicesDatails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.mintgreen,
        title: const Text(
          'جميع الخدمات المتاحة',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: MyColors.green,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: FutureBuilder<List<AvailableServices>>(
        future: MostRequestedServices().getAllServices(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<AvailableServices> services = snapshot.data!;
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: services.length,
              itemBuilder: (context, index) {
                // ignore: avoid_unnecessary_containers
                return Container(
                  child: Card(
                    color: MyColors.white,
                    shadowColor: MyColors.white,
                    surfaceTintColor: MyColors.white,

                    child: Container(
                      padding: const EdgeInsets.fromLTRB(7, 7, 7, 7),
                      height: 100,
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                  iconsGov[services[index].serviceName] ??
                                      'https://www.flaticon.com/free-icon/broken-image_13434972',
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(4, 2, 15, 2),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        services[index].serviceName,
                                        style: const TextStyle(
                                          color: MyColors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // SizedBox(width: 160),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          0,
                                          10,
                                          0,
                                          0,
                                        ),
                                        child: Text(
                                          'يستغرق استخراجه ${services[index].time} بتكلفة  ${services[index].fee} جنيهًا فقط لا غير \n للتواصل: ${services[index].email}',
                                          style: const TextStyle(
                                            color: MyColors.black,
                                            fontSize: 14,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
