import 'package:citio/core/utils/assets_image.dart';
import 'package:citio/core/utils/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

String _baseUrl = 'https://service-provider.runasp.net';

class VendorProfile extends StatelessWidget {
  final String cover;
  final String profilePic;
  final String name;
  final String businessType;
  final double? rating;
  const VendorProfile({
    super.key,
    required this.cover,
    required this.profilePic,
    required this.name,
    required this.businessType,
    this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          ClipRRect(
            // borderRadius: BorderRadius.circular(20),
            child: Container(
              // Adjust radius as needed
              // Optional: Add background color
              child: Image.network(
                cover,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (
                  BuildContext context,
                  Object error,
                  StackTrace? stackTrace,
                ) {
                  return const SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: Image(image: AssetImage(MyAssetsImage.brokenImage)),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 50,
            child: Padding(
              padding: const EdgeInsets.all(9.0),
              child: Card(
                color: MyColors.white,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(7, 12, 12, 7),
                  width: 320,
                  height: 190,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Card(
                                elevation: 5,
                                shadowColor: MyColors.whiteSmoke,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                color: Colors.transparent,
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(
                                    profilePic ??
                                        'https://cdn-icons-png.flaticon.com/128/11820/11820229.png',
                                  ),
                                  /*_user.avatar != null
                                            ? NetworkImage(_user.avatar!)
                                            : null,*/
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              2,
                                              12,
                                              12,
                                              0,
                                            ),
                                            child: Text(
                                              name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: MyColors.black,
                                              ),
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                              2,
                                              12,
                                              12,
                                              0,
                                            ),
                                            child: Text(
                                              'تقييم 5.0',
                                              style: TextStyle(
                                                fontSize: 16,

                                                color: Colors.orangeAccent,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              2,
                                              15,
                                              12,
                                              0,
                                            ),
                                            child: Text(
                                              businessType,
                                              style: const TextStyle(
                                                fontSize: 12,

                                                color: MyColors.gray,
                                              ),
                                              //maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              2,
                                              15,
                                              4,
                                              0,
                                            ),
                                            child: StarRating(
                                              size: 20.0,
                                              rating: rating ?? 0,
                                              color: Colors.orange,
                                              borderColor: Colors.grey,
                                              allowHalfRating: true,
                                              starCount: 5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(children: []),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
