import 'dart:core';

import 'package:city/core/utils/mycolors.dart';
import 'package:city/core/widgets/reactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:multi_image_layout/multi_image_layout.dart';

class Post extends StatelessWidget {
  Post({
    required this.userName,
    required this.name,
    required this.date,
    this.data,
    required this.likeCount,
    required this.shareCount,
    required this.commentCount,
    this.media,
    required this.avatar,
    super.key,
  });
  final List<String>? media;
  final String avatar;

  String userName;
  String name;
  String date;
  String? data;
  int likeCount;
  int shareCount;
  int commentCount;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      color: MyColors.white,
      shadowColor: MyColors.white,
      //margin: EdgeInsets.fromLTRB(14, 6, 14, 6),
      child: Container(
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
                      backgroundImage: NetworkImage(avatar),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(2, 5, 4, 0),
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: MyColors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(2, 5, 2, 0),
                            child: Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 13,
                                // fontWeight: FontWeight.normal,
                                color: Color.fromRGBO(134, 133, 133, 1),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(2, 5, 2, 0),
                            child: Text(
                              date,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color.fromRGBO(134, 133, 133, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                        child: Text(data!),
                      ),
                      LayoutBuilder(
                        builder: (
                          BuildContext context,
                          BoxConstraints constraints,
                        ) {
                          if (media != null) {
                            return Container(
                              padding: const EdgeInsets.fromLTRB(2, 4, 2, 4),
                              child: GalleryImage(
                                numOfShowImages:
                                    (media?.length ?? 0) > 3
                                        ? 3
                                        : media?.length ?? 0,
                                imageUrls: media!, //هنا الurls بتاعت الصور
                                titleGallery: 'Citio',
                              ),
                            );
                          } else {
                            return const SizedBox(height: 0, width: 0);
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
                            Icons.favorite_border_outlined,
                          ),
                          reactionHoverColor: Colors.red.withOpacity(.3),
                        ),
                        Text(
                          likeCount.toString(),
                          style: TextStyle(
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
                          reactionIcon: const Icon(Icons.comment_outlined),
                          reactionHoverColor: Colors.green.withOpacity(.3),
                        ),
                        Text(
                          commentCount.toString(),
                          style: TextStyle(
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
                          reactionIcon: Icon(Icons.repeat_rounded),
                          reactionHoverColor: Colors.blue.withOpacity(.3),
                        ),
                        Text(
                          shareCount.toString(),
                          style: TextStyle(
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
      ),
    );
  }
}
