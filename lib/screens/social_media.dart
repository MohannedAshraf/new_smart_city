// ignore_for_file: library_private_types_in_public_api, avoid_print, deprecated_member_use, unused_element

import 'package:citio/core/utils/variables.dart';
import 'package:citio/core/widgets/reaction_button.dart';
import 'package:citio/core/widgets/reactions.dart';
import 'package:citio/models/socialmedia_post.dart';
import 'package:citio/models/socialmedia_user.dart';
import 'package:citio/services/get_post.dart';
import 'package:citio/services/get_socialmedia_user.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:citio/main.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final Uri _url = Uri.parse('https://x.com/home');

class SocialMedia extends StatefulWidget {
  const SocialMedia({super.key});

  @override
  _SocialMediaState createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  List<Data>? cachedPosts;
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMorePosts = true;
  int currentPage = 1;

  final Map<String, SocialmediaUser> userCache = {};

  @override
  void initState() {
    super.initState();
    _fetchPostsPage(page: currentPage);
  }

  Future<void> _fetchPostsPage({required int page}) async {
    if (!hasMorePosts || isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
    });

    try {
      final postsResult = await GetPost().getPosts(page: page);
      final newPosts = postsResult.data;

      if (newPosts.isEmpty) {
        hasMorePosts = false;
      } else {
        cachedPosts = (cachedPosts ?? []) + newPosts;
        currentPage++;
      }
    } catch (e) {
      print('❌ Error loading page $page: $e');
    }

    setState(() {
      isLoading = false;
      isLoadingMore = false;
    });
  }

  Widget _buildPostUserWidget(
    Data post,
    double screenWidth,
    double screenHeight,
  ) {
    final userId = post.authorId ?? '';
    if (userCache.containsKey(userId)) {
      final user = userCache[userId]!;
      return _buildPostWithUser(post, user, screenWidth, screenHeight);
    } else {
      return FutureBuilder<SocialmediaUser>(
        future: GetSocialmediaUser().getSocialMediaUser(id: userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // تجاهل البوست عند الخطأ
            return const SizedBox.shrink();
          }
          if (!snapshot.hasData) {
            return Container(
              color: MyColors.fadedGrey,
              height: screenHeight * 0.2,
              child: const Center(
                child: CircularProgressIndicator(color: MyColors.gray),
              ),
            );
          }
          final user = snapshot.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!userCache.containsKey(userId)) {
              setState(() {
                userCache[userId] = user;
              });
            }
          });
          return _buildPostWithUser(post, user, screenWidth, screenHeight);
        },
      );
    }
  }

  Widget _buildPostWithUser(
    Data post,
    SocialmediaUser user,
    double screenWidth,
    double screenHeight,
  ) {
    print('Building post with id: ${post.id}');

    final imageUrls =
        post.media?.map((m) => m.url).whereType<String>().toList() ?? [];

    return Padding(
      padding: EdgeInsets.fromLTRB(7.w, 20.h, 20.w, 7.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: screenWidth * 0.075,
                backgroundImage: NetworkImage(
                  (user.avatar != null && user.avatar!.isNotEmpty)
                      ? Urls.socialmediaBaseUrl + user.avatar!
                      : 'https://cdn-icons-png.flaticon.com/128/11820/11820229.png',
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: MyColors.black,
                      ),
                    ),
                    Text(
                      getTimeAgo(post.createdAt ?? ''),
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color.fromRGBO(134, 133, 133, 1),
                      ),
                    ),
                  ],
                ),
              ),
              if (post.adminPost)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 5.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: MyColors.ambulance,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    (post.tags != null && post.tags!.isNotEmpty)
                        ? post.tags![0] ?? ''
                        : '',
                    style: const TextStyle(color: MyColors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(post.postCaption ?? '', softWrap: true),
          if (imageUrls.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child:
                    imageUrls.length == 1
                        ? Image.network(
                          imageUrls[0],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image),
                        )
                        : GalleryImage(
                          imageUrls: imageUrls,
                          numOfShowImages:
                              imageUrls.length > 3 ? 3 : imageUrls.length,
                          titleGallery: 'Citio',
                          imageRadius: 8,
                        ),
              ),
            ),
          SizedBox(
            width: screenWidth - 10,
            height: 2.h,
            child: const ColoredBox(color: MyColors.fadedGrey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ReactionButton(
                postId: post.id ?? '',
                currentUserReaction: post.userReaction,
                totalCount: post.impressionsCount?.total ?? 0,
                onReacted: (reaction, total) {
                  setState(() {
                    post.userReaction = reaction;
                    post.impressionsCount?.total = total;
                  });
                },
              ),
              _buildReactionColumn(
                icon: FluentIcons.comment_28_regular,
                count: post.saveCount,
                hoverColor: Colors.green.withOpacity(0.3),
              ),
              _buildReactionColumn(
                icon: FluentIcons.share_48_regular,
                count: null,
                label: 'مشاركة',
                hoverColor: Colors.blue.withOpacity(0.3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: AppBar(
        backgroundColor: MyColors.white,
        surfaceTintColor: MyColors.white,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: MyColors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HomePage(initialIndex: 0),
              ),
            );
          },
        ),
        toolbarHeight: 50.h,
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: [
              SizedBox(width: screenWidth * 0.13),
              Text(
                'آخر المشاركات',
                style: TextStyle(color: MyColors.black, fontSize: 20.sp),
              ),
              const Spacer(),
              IconButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                    cachedPosts = null;
                    currentPage = 1;
                    hasMorePosts = true;
                  });
                  await _fetchPostsPage(page: currentPage);
                },
                icon: const Icon(Icons.refresh, color: MyColors.gray),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    isLoading = true;
                    cachedPosts = null;
                    currentPage = 1;
                    hasMorePosts = true;
                  });
                  await _fetchPostsPage(page: currentPage);
                },
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (hasMorePosts &&
                        !isLoadingMore &&
                        scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 100) {
                      _fetchPostsPage(page: currentPage);
                      return true;
                    }
                    return false;
                  },
                  child: ListView.builder(
                    itemCount: cachedPosts?.length ?? 0,
                    itemBuilder: (context, index) {
                      final post = cachedPosts![index];
                      return Card(
                        color: MyColors.white,
                        shadowColor: MyColors.white,
                        child: _buildPostUserWidget(
                          post,
                          screenWidth,
                          screenHeight,
                        ),
                      );
                    },
                  ),
                ),
              ),
    );
  }

  Widget _buildReactionColumn({
    required IconData icon,
    int? count,
    String? label,
    required Color hoverColor,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Reactions(reactionIcon: Icon(icon), reactionHoverColor: hoverColor),
            const SizedBox(width: 4),
            if (count != null)
              Text(
                count.toString(),
                style: TextStyle(color: MyColors.gray, fontSize: 10.sp),
              )
            else if (label != null)
              Text(
                label,
                style: TextStyle(color: MyColors.gray, fontSize: 10.sp),
              ),
          ],
        ),
      ],
    );
  }
}
