import 'package:city/core/utils/mycolors.dart';

import 'package:city/core/widgets/reactions.dart';
import 'package:city/models/socialmedia_post.dart';
import 'package:city/models/socialmedia_user.dart';
import 'package:city/services/get_post.dart';
import 'package:city/services/get_socialmedia_user.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';

class SocialmediaTabView extends StatelessWidget {
  // final String uderId;

  const SocialmediaTabView({super.key /*required this.uderId*/});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SocialmediaPost>(
      future: GetPost().getTenPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Data> posts = snapshot.data!.data;
          //return Center(child: Text(posts.userName!));
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              // ignore: avoid_unnecessary_containers
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
                        padding: const EdgeInsets.fromLTRB(7, 7, 7, 7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                        user.avatar ??
                                            'https://cdn-icons-png.flaticon.com/128/11820/11820229.png',
                                      ),
                                      /*_user.avatar != null
                                      ? NetworkImage(_user.avatar!)
                                      : null,*/
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              2,
                                              5,
                                              4,
                                              0,
                                            ),
                                            child: Text(
                                              user.name,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: MyColors.black,
                                              ),
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              4,
                                              5,
                                              2,
                                              0,
                                            ),
                                            child: Text(
                                              posts[index].date ?? '',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Color.fromRGBO(
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
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          0,
                                          4,
                                          4,
                                          4,
                                        ),
                                        child: Text(posts[index].caption ?? ''),
                                      ),
                                      LayoutBuilder(
                                        builder: (
                                          BuildContext context,
                                          BoxConstraints constraints,
                                        ) {
                                          if (posts[index].media?.isNotEmpty ??
                                              false) {
                                            return Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                    2,
                                                    4,
                                                    2,
                                                    4,
                                                  ),
                                              child: GalleryImage(
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
                                                        .toList(), //هنا الurls بتاعت الصور
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Reactions(
                                          reactionIcon: const Icon(
                                            FluentIcons.heart_circle_16_regular,
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
                                          style: const TextStyle(
                                            color: Color(0xFF9E9E9E),
                                            fontSize: 10,
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
                                          ),
                                          reactionHoverColor: Colors.green
                                              .withOpacity(.3),
                                        ),
                                        Text(
                                          posts[index].saveCount.toString(),
                                          style: const TextStyle(
                                            color: Color(0xFF9E9E9E),
                                            fontSize: 10,
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
                                          posts[index].shareCount.toString(),
                                          style: const TextStyle(
                                            color: Color(0xFF9E9E9E),
                                            fontSize: 10,
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
                      );
                    } else if ((snapshot.hasError)) {
                      return const Center(
                        child: Text('حدث خطأ: '),
                      ); /*CircularProgressIndicator()*/
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              );
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
