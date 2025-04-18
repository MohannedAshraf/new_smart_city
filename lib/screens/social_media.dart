import 'package:city/core/utils/variables.dart';
import 'package:city/core/widgets/post.dart';

import 'package:city/core/widgets/tab_item.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

final Uri _url = Uri.parse('https://x.com/home');
final Uri videourl = Uri.parse(
  'https://videos.pexels.com/video-files/31585574/13459823_360_640_30fps.mp4',
);
const List<String> urls = [
  'https://t3.ftcdn.net/jpg/02/38/58/46/240_F_238584633_pqi96ixQ7g9iSSw5mxFRDk7IEDNtT7g9.jpg',
  'https://t3.ftcdn.net/jpg/02/50/50/98/240_F_250509856_bTdvNHM8TpqnCGS6s4u5B6MkNq4j9F7b.jpg',
  'https://t4.ftcdn.net/jpg/03/06/17/11/240_F_306171176_4z4nxYjiJjW1TFkutzD3PGI1GpY6SDBN.jpg',
  'https://t3.ftcdn.net/jpg/02/73/95/48/240_F_273954804_pQ7U2a5hdOZLoek2Ail0BhAlC7o9uq2a.jpg',
  'https://t4.ftcdn.net/jpg/02/30/50/25/240_F_230502578_HSzHuSDSknowd20km40bezErY6ORnifu.jpg',
];

class SocialMedia extends StatefulWidget {
  @override
  _SocialMediaState createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  //const SocialMedia({super.key});
  late VideoPlayerController _videoPlayerController;
  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.networkUrl(videourl)
      ..initialize().then((_) {
        _videoPlayerController.play();
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed:
              () => showDialog<String>(
                context: context,
                builder:
                    (BuildContext context) => AlertDialog(
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
                    ),
              ),
          backgroundColor: MyColors.cardcolor,
          label: const Text(
            maxLines: 1,
            textAlign: TextAlign.center,
            'Show all',
            style: TextStyle(fontSize: 18, color: MyColors.fontcolor),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Icon(
            Icons.groups_2_outlined,
            color: MyColors.themecolor,
          ),
          centerTitle: true,
          //  excludeHeaderSemantics: true,
          backgroundColor: MyColors.white,
          bottom: const TabBar(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: MyColors.themecolor,
            indicatorColor: MyColors.themecolor,
            labelColor: MyColors.fontcolor,
            unselectedLabelColor: Colors.black,
            tabs: [
              TabItem(title: 'الأكثر رواجا'),
              TabItem(title: 'الأحدث'),
              TabItem(title: 'الأشخاص'),
              TabItem(title: 'الوسائط'),
              TabItem(title: 'الأخبار'),
              TabItem(title: 'الرياضة'),
              TabItem(title: 'Entertainment'),
            ],
          ),
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Post(
              avatar:
                  'https://t3.ftcdn.net/jpg/02/83/76/16/240_F_283761660_jGDMgzgTdNbQKhNTD5hzPLBBJyXOLGvv.jpg',
              userName: '@hawhaw',
              name: 'HawHaw',
              likeCount: 50,
              shareCount: 2,
              commentCount: 1,
              date: '2h',
              media: const [
                'https://t3.ftcdn.net/jpg/04/04/43/30/240_F_404433072_8eV4kJgs0klW0IqTCexBOJWMUltISAuQ.jpg',
                'https://t4.ftcdn.net/jpg/02/25/32/73/240_F_225327340_D2K1Bkbr6nFWgc06tqLhs2X8E3sUM3fQ.jpg',
                'https://t3.ftcdn.net/jpg/02/88/66/64/240_F_288666465_1nkhsjAd3zMt6xM6paEaO0WIdv4oVfiM.jpg',
                'https://t3.ftcdn.net/jpg/02/38/58/46/240_F_238584633_pqi96ixQ7g9iSSw5mxFRDk7IEDNtT7g9.jpg',
                'https://t3.ftcdn.net/jpg/02/38/58/54/240_F_238585403_qCBruRkh5GGUNJYo7fFQ9ktSM6ZJfxiL.jpg',
              ],
              data:
                  'esidence certainly elsewhere something she preferred cordially law. Age his surprise formerly mrs perceive few stanhill moderate. Of in power match on truth worse voice would. Large an it sense shall an match learn. By expect it result silent in formal of. Ask eat questions abilities described elsewhere assurance. Appetite in unlocked advanced breeding position concerns as. Cheerful get shutters yet for repeated screened. An no am cause hopes at three. Prevent behaved fertile he is mistake on.',
            ),
            Post(
              avatar:
                  'https://t3.ftcdn.net/jpg/02/83/76/16/240_F_283761660_jGDMgzgTdNbQKhNTD5hzPLBBJyXOLGvv.jpg',
              userName: '@hawhaw',
              name: 'HawHaw',
              likeCount: 50,
              shareCount: 2,
              commentCount: 1,
              date: '2h',
              media: const [
                'https://t3.ftcdn.net/jpg/02/38/58/46/240_F_238584633_pqi96ixQ7g9iSSw5mxFRDk7IEDNtT7g9.jpg',
                'https://t3.ftcdn.net/jpg/02/38/58/54/240_F_238585403_qCBruRkh5GGUNJYo7fFQ9ktSM6ZJfxiL.jpg',
              ],
              data:
                  'esidence certainly elsewhere something she preferred cordially law. Age his surprise formerly mrs perceive few stanhill moderate. Of in power match on truth worse voice would. Large an it sense shall an match learn. By expect it result silent in formal of. Ask eat questions abilities described elsewhere assurance. Appetite in unlocked advanced breeding position concerns as. Cheerful get shutters yet for repeated screened. An no am cause hopes at three. Prevent behaved fertile he is mistake on.',
            ),

            Post(
              avatar:
                  'https://t3.ftcdn.net/jpg/02/83/76/16/240_F_283761660_jGDMgzgTdNbQKhNTD5hzPLBBJyXOLGvv.jpg',
              userName: '@hawhaw',
              name: 'HawHaw',
              likeCount: 50,
              shareCount: 2,
              commentCount: 1,
              date: '2h',
              media: const [
                'https://t3.ftcdn.net/jpg/04/04/43/30/240_F_404433072_8eV4kJgs0klW0IqTCexBOJWMUltISAuQ.jpg',
              ],
              data:
                  'esidence certainly elsewhere something she preferred cordially law. Age his surprise formerly mrs perceive few stanhill moderate. Of in power match on truth worse voice would. Large an it sense shall an match learn. By expect it result silent in formal of. Ask eat questions abilities described elsewhere assurance. Appetite in unlocked advanced breeding position concerns as. Cheerful get shutters yet for repeated screened. An no am cause hopes at three. Prevent behaved fertile he is mistake on.',
            ),
            Post(
              avatar:
                  'https://pbs.twimg.com/profile_images/1880960574491627520/bfxtwwYq_400x400.jpg',
              userName: '@hozifaa8',
              name: 'حذيفة',
              likeCount: 50,
              shareCount: 2,
              commentCount: 1,
              date: '2 jul',
              data:
                  'esidence certainly elsewhere something she preferred cordially law. Age his surprise formerly mrs perceive few stanhill moderate. Of in power match on truth worse voice would. Large an it sense shall an match learn. By expect it result silent in formal of. Ask eat questions abilities described elsewhere assurance. Appetite in unlocked advanced breeding position concerns as. Cheerful get shutters yet for repeated screened. An no am cause hopes at three. Prevent behaved fertile he is mistake on.',
            ),
          ],
        ),
      ),
    );
  }
}
