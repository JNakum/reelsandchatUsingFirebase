import 'package:flutter/material.dart';
import 'package:reels/pages/videoplayer.dart';

class VideoReels extends StatefulWidget {
  const VideoReels({super.key});

  @override
  _VideoReelsState createState() => _VideoReelsState();
}

class _VideoReelsState extends State<VideoReels> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  // void _signOut(BuildContext context) async {
  //   try {
  //     await _auth.signOut();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Logout Successful')),
  //     );

  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (context) => Login()));
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error during logout: $e')),
  //     );
  //   }
  // }

  final List<String> videoUrls = [
    'https://cdn.pixabay.com/video/2024/08/30/228847_large.mp4',
    'https://cdn.pixabay.com/video/2023/11/19/189692-886572510_large.mp4',
    'https://cdn.pixabay.com/video/2023/03/15/154787-808530571_large.mp4',
    'https://sample-videos.com/video321/mp4/480/big_buck_bunny_480p_1mb.mp4',
    'https://test-videos.co.uk/vids/bigbuckbunny/mp4/av1/360/Big_Buck_Bunny_360_10s_1MB.mp4',
    'https://cdn.pixabay.com/video/2022/07/24/125314-733046618_large.mp4',
    'https://videocdn.cdnpk.net/videos/5c6fa12c-d6d8-5a69-ab5a-44b53ec741c3/horizontal/previews/watermarked/large.mp4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     // actions: [
      //     //   IconButton(
      //     //       onPressed: () {
      //     //         _signOut(context);
      //     //       },
      //     //       icon: Icon(Icons.logout))
      //     // ],
      //     ),
      body: Container(
        // height: MediaQuery.of(context).size.height,
        // width: double.infinity,
        child: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: videoUrls.length,
          itemBuilder: (context, index) {
            return VideoPlayerScreen(videoUrl: videoUrls[index]);
          },
        ),
      ),
    );
  }
}
