// ignore_for_file: library_private_types_in_public_api

import 'package:citio/core/utils/variables.dart';
import 'package:citio/core/widgets/reaction_button.dart';
import 'package:citio/core/widgets/reactions.dart';
import 'package:citio/models/socialmedia_post.dart';
import 'package:citio/models/socialmedia_user.dart';
import 'package:citio/services/get_post.dart';
import 'package:citio/services/get_socialmedia_user.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:url_launcher/url_launcher.dart';
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
  static List<Data>? _persistedPosts; // ✅ كاش مؤقت
  List<Data>? cachedPosts;
  bool isLoading = true;
  bool isButtonPressed = false;

  final Map<String, SocialmediaUser> userCache = {};

  @override
  void initState() {
    super.initState();
    _fetchPostsOnce();
  }

  Future<void> _fetchPostsOnce() async {
    try {
      if (_persistedPosts != null && _persistedPosts!.isNotEmpty) {
        print('📦 Using cached posts');
        setState(() {
          cachedPosts = _persistedPosts;
          isLoading = false;
        });
        return;
      }

      print('🌐 Fetching posts from API...');
      final postsResult = await GetPost().getTenPosts();
      print('📥 API Response: ${postsResult.data}');

      if (postsResult.data.isEmpty) {
        print('⚠️ No posts received');
        setState(() {
          cachedPosts = [];
          _persistedPosts = [];
          isLoading = false;
        });
        return;
      }

      _persistedPosts = postsResult.data;
      setState(() {
        cachedPosts = _persistedPosts;
        isLoading = false;
      });
    } catch (e) {
      print('❌ Error fetching posts: $e');
      setState(() {
        cachedPosts = [];
        isLoading = false;
      });
    }
  }

  Widget _buildPostUserWidget(
    Data post,
    double screenWidth,
    double screenHeight,
  ) {
    final userId = post.authorId ?? ''; // استخدم authorId حسب نموذج البيانات
    if (userCache.containsKey(userId)) {
      final user = userCache[userId]!;
      return _buildPostWithUser(post, user, screenWidth, screenHeight);
    } else {
      return FutureBuilder<SocialmediaUser>(
        future: GetSocialmediaUser().getSocialMediaUser(id: userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('حدث خطأ في جلب المستخدم'));
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
                child: imageUrls.length == 1
                    ? Image.network(
                        imageUrls[0],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
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
                    _persistedPosts = null; // امسح الكاش
                  });
                  await _fetchPostsOnce(); // حمل جديد
                },
                icon: const Icon(Icons.refresh, color: MyColors.gray),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                _persistedPosts = null;
                await _fetchPostsOnce();
              },
              child: ListView.builder(
                itemCount: cachedPosts!.length + 1,
                itemBuilder: (context, index) {
                  if (index == cachedPosts!.length) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 19.w,
                        vertical: 15.h,
                      ),
                      child: SizedBox(
                        height: 70.h,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() => isButtonPressed = true);
                            Future.delayed(
                              const Duration(milliseconds: 200),
                              () {
                                setState(() => isButtonPressed = false);
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isButtonPressed
                                ? MyColors.inProgress
                                : MyColors.dodgerBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          child: const Text(
                            ' مشاهدة الجميع',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: MyColors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

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

class PopUpDialog extends StatelessWidget {
  const PopUpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('سيتم تحويلك خارج citio'),
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
