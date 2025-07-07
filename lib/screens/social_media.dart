// ignore_for_file: library_private_types_in_public_api, avoid_print, deprecated_member_use, unused_element

import 'package:citio/core/utils/mycolors.dart';
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
import 'package:citio/screens/new_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:citio/models/socialmedia_user_minimal.dart';
import 'package:citio/services/get_my_user_minimal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:citio/core/utils/project_strings.dart';

class SocialMedia extends StatefulWidget {
  static SocialmediaUserMinimal? cachedUserMinimal;
  const SocialMedia({super.key});

  @override
  _SocialMediaState createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  SocialmediaUserMinimal? myUserMinimal;
  bool isUserLoading = true;
  List<Data>? cachedPosts;
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMorePosts = true;
  int currentPage = 1;

  final Map<String, SocialmediaUser> userCache = {};

  @override
  void initState() {
    super.initState();
    if (SocialMedia.cachedUserMinimal != null) {
      myUserMinimal = SocialMedia.cachedUserMinimal;
      isUserLoading = false;
    } else {
      _loadMyUser();
    }
    _fetchPostsPage(page: currentPage);
  }

  Future<void> _loadMyUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null) {
        final user = await GetMyUserMinimalService().fetchMyUser(token);
        if (mounted) {
          setState(() {
            myUserMinimal = user;
            SocialMedia.cachedUserMinimal = user;
            isUserLoading = false;
          });
        }
      } else {
        setState(() => isUserLoading = false);
      }
    } catch (e) {
      print("❌ Error loading minimal user: $e");
      setState(() => isUserLoading = false);
    }
  }

  Future<void> _fetchPostsPage({required int page}) async {
    if (!hasMorePosts || isLoadingMore) return;
    setState(() => isLoadingMore = true);
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
          if (snapshot.hasError) return const SizedBox.shrink();
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
              setState(() => userCache[userId] = user);
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
    final imageUrls =
        post.media?.map((m) => m.url).whereType<String>().toList() ?? [];
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 20, 20, 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          Row(
            children: [
              CircleAvatar(
                radius: screenWidth * 0.075,
                backgroundImage: NetworkImage(
                  (user.avatar != null && user.avatar!.isNotEmpty)
                      ? Urls.socialmediaBaseUrl + user.avatar!
                      : AppStrings.noAvatarUrl,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: MyColors.black,
                      ),
                    ),
                    Text(
                      getTimeAgo(post.createdAt ?? ''),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color.fromRGBO(134, 133, 133, 1),
                      ),
                    ),
                  ],
                ),
              ),
              if (post.adminPost)
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 5,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: MyColors.ambulance,
                    borderRadius: BorderRadius.circular(20),
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
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
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
                          titleGallery: AppStrings.appGalleryTitle,
                          imageRadius: 8,
                        ),
              ),
            ),

          SizedBox(
            width: screenWidth - 10,
            height: 2,
            child: const ColoredBox(color: MyColors.fadedGrey),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ReactionButton(
                postId: post.id ?? '',
                currentUserReaction: post.userReaction,
                totalCount: post.impressionsCount?.total ?? 0,
                onReacted: (reaction, _) {
                  setState(() => post.userReaction = reaction);
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
                label: AppStrings.postShared,
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const HomePage(initialIndex: 0),
              ),
            );
          },
        ),
        toolbarHeight: 50, // Removed .h, fixed value
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              SizedBox(width: screenWidth * 0.13),
              const Text(
                AppStrings.latestPosts,
                style: TextStyle(color: MyColors.black, fontSize: 20),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.add, color: MyColors.gray),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NewPostScreen(user: myUserMinimal!),
                    ),
                  );
                },
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
                style: const TextStyle(color: MyColors.gray, fontSize: 10),
              )
            else if (label != null)
              Text(
                label,
                style: const TextStyle(color: MyColors.gray, fontSize: 10),
              ),
          ],
        ),
      ],
    );
  }
}
