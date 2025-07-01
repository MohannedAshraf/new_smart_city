// ignore_for_file: deprecated_member_use, library_private_types_in_public_api, sort_child_properties_last

import 'package:citio/core/utils/variables.dart';

import 'package:citio/core/widgets/reactions.dart';
import 'package:citio/models/socialmedia_post.dart';
import 'package:citio/models/socialmedia_user.dart';
import 'package:citio/services/get_post.dart';
import 'package:citio/services/get_socialmedia_user.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://x.com/home');

class SocialmediaTabView extends StatefulWidget {
  const SocialmediaTabView({super.key});
  @override
  _SocialmediaTabViewState createState() => _SocialmediaTabViewState();
}

class _SocialmediaTabViewState extends State<SocialmediaTabView> {
  bool isButtonPressed = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return FutureBuilder<SocialmediaPost>(
      future: GetPost().getTenPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Data> posts = snapshot.data!.data;
          //return Center(child: Text(posts.userName!));
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: posts.length + 1,
            itemBuilder: (context, index) {
              if (index == posts.length) {
                return Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.1125,
                        color: MyColors.white,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.0475,
                            MediaQuery.of(context).size.height * 0.01875,
                            MediaQuery.of(context).size.width * 0.0475,
                            MediaQuery.of(context).size.height * 0.01875,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.0875,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isButtonPressed = true;
                                });

                                Future.delayed(
                                  const Duration(milliseconds: 200),
                                  () {
                                    setState(() {
                                      isButtonPressed = false;
                                    });
                                  },
                                );
                              },

                              child: const Center(
                                child: Text(
                                  ' مشاهدة الجميع',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.white,
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: MyColors.fadedGrey,
                                backgroundColor:
                                    isButtonPressed
                                        ? MyColors.inProgress
                                        : MyColors.dodgerBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width * 0.0350,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              // ignore: avoid_unnecessary_containers
              else {
                return Card(
                  color: MyColors.white,
                  shadowColor: MyColors.white,
                  //margin: EdgeInsets.fromLTRB(14, 6, 14, 6),
                  child: FutureBuilder<SocialmediaUser>(
                    future: GetSocialmediaUser().getSocialMediaUser(
                      id: posts[index].userId ?? '',
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        SocialmediaUser user = snapshot.data!;

                        return Container(
                          padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.0175,
                            MediaQuery.of(context).size.height * 0.0250,
                            MediaQuery.of(context).size.width * 0.05,
                            MediaQuery.of(context).size.height * 0.00875,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      CircleAvatar(
                                        radius: screenWidth * .075,
                                        backgroundImage: NetworkImage(
                                          (user.avatar != null &&
                                                  user.avatar!.isNotEmpty)
                                              ? Urls.socialmediaBaseUrl +
                                                  user.avatar!
                                              : 'https://cdn-icons-png.flaticon.com/128/11820/11820229.png',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                            MediaQuery.of(context).size.width *
                                                0.005,
                                            MediaQuery.of(context).size.height *
                                                0.00625,
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                            0.h,
                                          ),
                                          child: Text(
                                            user.name,
                                            style: TextStyle(
                                              fontSize:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.01625,
                                              fontWeight: FontWeight.bold,
                                              color: MyColors.black,
                                            ),
                                          ),
                                        ),

                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                            0.h,
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                            0.h,
                                          ),
                                          child: Text(
                                            posts[index].date ?? '',
                                            style: TextStyle(
                                              fontSize:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.01625,
                                              color: const Color.fromRGBO(
                                                134,
                                                133,
                                                133,
                                                1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  posts[index].adminPost
                                      ? Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                              MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.015,
                                              0.h,
                                              MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.015,
                                              MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.00625,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.03,
                                              vertical:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.01,
                                            ),
                                            decoration: BoxDecoration(
                                              color: MyColors.ambulance,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    MediaQuery.of(
                                                          context,
                                                        ).size.width *
                                                        0.05,
                                                  ),
                                            ),
                                            child: Text(
                                              (posts[index].tags != null &&
                                                      posts[index]
                                                          .tags!
                                                          .isNotEmpty)
                                                  ? posts[index].tags![0]
                                                  : '',
                                              style: const TextStyle(
                                                color: MyColors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                      : const SizedBox(),
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
                                          padding: EdgeInsets.fromLTRB(
                                            0.w,
                                            MediaQuery.of(context).size.height *
                                                0.005,
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                            MediaQuery.of(context).size.height *
                                                0.005,
                                          ),
                                          child: Text(
                                            posts[index].caption ?? '',
                                            softWrap: true,
                                          ),
                                        ),
                                        LayoutBuilder(
                                          builder: (
                                            BuildContext context,
                                            BoxConstraints constraints,
                                          ) {
                                            if (posts[index]
                                                    .media
                                                    ?.isNotEmpty ??
                                                false) {
                                              return Container(
                                                padding: EdgeInsets.fromLTRB(
                                                  MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.005,
                                                  MediaQuery.of(
                                                        context,
                                                      ).size.height *
                                                      0.005,
                                                  MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.005,
                                                  MediaQuery.of(
                                                        context,
                                                      ).size.height *
                                                      0.005,
                                                ),
                                                child: GalleryImage(
                                                  minScale: .5,
                                                  childAspectRatio: .8,
                                                  imageRadius: 12,
                                                  numOfShowImages:
                                                      (posts[index]
                                                                      .media
                                                                      ?.length ??
                                                                  0) >
                                                              3
                                                          ? 3
                                                          : posts[index]
                                                                  .media
                                                                  ?.length ??
                                                              0,

                                                  imageUrls:
                                                      posts[index].media!
                                                          .map((m) => m.url)
                                                          .whereType<String>()
                                                          .toList(),
                                                  titleGallery: 'Citio',
                                                ),
                                              );
                                            } else {
                                              return const SizedBox(
                                                height: 0,
                                                width: 0,
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: screenWidth - 10,
                                height:
                                    MediaQuery.of(context).size.height * 0.0025,
                                child: const ColoredBox(
                                  color: MyColors.fadedGrey,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Reactions(
                                            reactionIcon: const Icon(
                                              Icons.favorite_border_outlined,
                                            ),
                                            reactionHoverColor: Colors.red
                                                .withOpacity(.3),
                                          ),
                                          Text(
                                            (posts[index]
                                                        .impressionsCount
                                                        ?.total ??
                                                    0)
                                                .toString(),
                                            style: TextStyle(
                                              color: MyColors.gray,
                                              fontSize:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.0125,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Reactions(
                                            reactionIcon: const Icon(
                                              FluentIcons.comment_28_regular,

                                              ///commit
                                            ),
                                            reactionHoverColor: Colors.green
                                                .withOpacity(.3),
                                          ),
                                          Text(
                                            posts[index].saveCount.toString(),
                                            style: TextStyle(
                                              color: MyColors.gray,
                                              fontSize:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.0125,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Reactions(
                                            reactionIcon: const Icon(
                                              FluentIcons.share_48_regular,
                                            ),
                                            reactionHoverColor: Colors.blue
                                                .withOpacity(.3),
                                          ),
                                          Text(
                                            'مشاركة',
                                            style: TextStyle(
                                              color: MyColors.gray,
                                              fontSize:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.0125,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // child: Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Row(
                          //       children: [
                          //         Column(
                          //           children: [
                          //             CircleAvatar(
                          //               radius: screenWidth * .075,
                          //               backgroundImage: NetworkImage(
                          //                 (user.avatar != null &&
                          //                         user.avatar!.isNotEmpty)
                          //                     ? Urls.socialmediaBaseUrl +
                          //                         user.avatar!
                          //                     : 'https://cdn-icons-png.flaticon.com/128/11820/11820229.png',
                          //               ),
                          //               /*_user.avatar != null
                          //             ? NetworkImage(_user.avatar!)
                          //             : null,*/
                          //             ),
                          //           ],
                          //         ),
                          //         Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //           children: [
                          //             Padding(
                          //               padding: const EdgeInsets.fromLTRB(
                          //                 2,
                          //                 5,
                          //                 4,
                          //                 0,
                          //               ),
                          //               child: Text(
                          //                 user.name,
                          //                 style: const TextStyle(
                          //                   fontSize: 13,
                          //                   fontWeight: FontWeight.bold,
                          //                   color: MyColors.black,
                          //                 ),
                          //               ),
                          //             ),

                          //             Padding(
                          //               padding: const EdgeInsets.fromLTRB(
                          //                 4,
                          //                 0,
                          //                 4,
                          //                 0,
                          //               ),
                          //               child: Text(
                          //                 posts[index].date ?? '',
                          //                 style: const TextStyle(
                          //                   fontSize: 13,
                          //                   color: Color.fromRGBO(
                          //                     134,
                          //                     133,
                          //                     133,
                          //                     1,
                          //                   ),
                          //                 ),
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //         /////////////////hena
                          //       ],
                          //     ), /////////////////////
                          //     Row(
                          //       children: [
                          //         Column(
                          //           children: [
                          //             Padding(
                          //               padding: const EdgeInsets.fromLTRB(
                          //                 0,
                          //                 4,
                          //                 4,
                          //                 4,
                          //               ),
                          //               child: Text(posts[index].caption ?? ''),
                          //             ),
                          //             LayoutBuilder(
                          //               builder: (
                          //                 BuildContext context,
                          //                 BoxConstraints constraints,
                          //               ) {
                          //                 if (posts[index].media?.isNotEmpty ??
                          //                     false) {
                          //                   return Container(
                          //                     padding:
                          //                         const EdgeInsets.fromLTRB(
                          //                           2,
                          //                           4,
                          //                           2,
                          //                           4,
                          //                         ),
                          //                     child: GalleryImage(
                          //                       numOfShowImages:
                          //                           (posts[index]
                          //                                           .media
                          //                                           ?.length ??
                          //                                       0) >
                          //                                   3
                          //                               ? 3
                          //                               : posts[index]
                          //                                       .media
                          //                                       ?.length ??
                          //                                   0,

                          //                       imageUrls:
                          //                           posts[index].media!
                          //                               .map((m) => m.url)
                          //                               .whereType<String>()
                          //                               .toList(), //هنا الurls بتاعت الصور
                          //                       titleGallery: 'Citio',
                          //                     ),
                          //                   );
                          //                 } else {
                          //                   return const SizedBox(
                          //                     height: 0,
                          //                     width: 0,
                          //                   );
                          //                 }
                          //               },
                          //             ),
                          //           ],
                          //         ),
                          //       ],
                          //     ),
                          //     Row(
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceAround,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: [
                          //         Column(
                          //           children: [
                          //             Row(
                          //               children: [
                          //                 Reactions(
                          //                   reactionIcon: const Icon(
                          //                     FluentIcons
                          //                         .heart_circle_16_regular,
                          //                   ),
                          //                   reactionHoverColor: Colors.red
                          //                       .withOpacity(.3),
                          //                 ),
                          //                 Text(
                          //                   (posts[index]
                          //                               .impressionsCount
                          //                               ?.total ??
                          //                           0)
                          //                       .toString(),
                          //                   style: const TextStyle(
                          //                     color: Color(0xFF9E9E9E),
                          //                     fontSize: 10,
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ],
                          //         ),
                          //         Column(
                          //           children: [
                          //             Row(
                          //               children: [
                          //                 Reactions(
                          //                   reactionIcon: const Icon(
                          //                     FluentIcons.comment_28_regular,

                          //                     ///commit
                          //                   ),
                          //                   reactionHoverColor: Colors.green
                          //                       .withOpacity(.3),
                          //                 ),
                          //                 Text(
                          //                   posts[index].saveCount.toString(),
                          //                   style: const TextStyle(
                          //                     color: Color(0xFF9E9E9E),
                          //                     fontSize: 10,
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ],
                          //         ),
                          //         Column(
                          //           children: [
                          //             Row(
                          //               children: [
                          //                 Reactions(
                          //                   reactionIcon: const Icon(
                          //                     FluentIcons.share_48_regular,
                          //                   ),
                          //                   reactionHoverColor: Colors.blue
                          //                       .withOpacity(.3),
                          //                 ),
                          //                 Text(
                          //                   posts[index].shareCount.toString(),
                          //                   style: const TextStyle(
                          //                     color: Color(0xFF9E9E9E),
                          //                     fontSize: 10,
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ],
                          //         ),
                          //       ],
                          //     ),
                          //   ],
                          // ),
                        );
                      } else if ((snapshot.hasError)) {
                        return const Center(
                          child: Text('حدث خطأ: '),
                        ); /*CircularProgressIndicator()*/
                      } else {
                        return Container(
                          color: MyColors.fadedGrey,
                          height: screenheight * .2,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: MyColors.gray,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                );
              }
            },
          );
        } else if ((snapshot.hasError)) {
          return const Center(
            child: Text('حدث خطأ: '),
          ); /*CircularProgressIndicator()*/
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class PopUpDialog extends StatelessWidget {
  const PopUpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('سيتم تحويلك خارج  citio'),
      content: const Text('هل أنت متأكد بأنك ترغب بالرحيل'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('الغاء'),
        ),
        TextButton(
          onPressed: () {
            launchUrl(_url, mode: LaunchMode.inAppWebView);
          },
          child: const Text('نعم'),
        ),
      ],
    );
  }
}
