import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_youtube_ui/data.dart';
import 'package:flutter_youtube_ui/screens/nav_screen.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:flutter_youtube_ui/widgets/widgets.dart';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context
          .read(miniPlayerControllerProvider)
          .state
          .animateToHeight(state: PanelState.MAX),
      child: Scaffold(
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: CustomScrollView(
            controller: _scrollController,
            shrinkWrap: true,
            slivers: [
              SliverToBoxAdapter(
                child: Consumer(
                  builder: (context, watch, _) {
                    final selectedVideo = watch(selectedVideoProvider).state;
                    return SafeArea(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.network(
                                    selectedVideo!.thumbnailUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover),
                              ),
                              Positioned(
                                child: IconButton(
                                    onPressed: () => context
                                        .read(miniPlayerControllerProvider)
                                        .state
                                        .animateToHeight(state: PanelState.MIN),
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    iconSize: 30.0),
                                top: 0,
                                left: 0,
                              )
                            ],
                          ),
                          const LinearProgressIndicator(
                            value: 0.4,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                          VideoInfo(video: selectedVideo)
                        ],
                      ),
                    );
                  },
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                final video = suggestedVideos[index];
                return VideoCard(
                    video: video,
                    hasPadding: true,
                    ontap: () => _scrollController!.animateTo(0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn));
              }, childCount: suggestedVideos.length))
            ],
          ),
        ),
      ),
    );
  }
}
