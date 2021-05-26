import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_youtube_ui/data.dart';
import 'package:flutter_youtube_ui/screens/home_screen.dart';
import 'package:flutter_youtube_ui/screens/video_screen.dart';
import 'package:miniplayer/miniplayer.dart';

final selectedVideoProvider = StateProvider<Video?>((ref) => null);

final miniPlayerControllerProvider =
    StateProvider.autoDispose<MiniplayerController>(
        (ref) => MiniplayerController());

class NavScreen extends StatefulWidget {
  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _selectedIndex = 0;

  static const double _playerMinHeight = 60.0;

  final _screens = [
    HomeScreen(),
    const Scaffold(
      body: Center(
        child: Text('Explore'),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text('Ad'),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text('Subscriptions'),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text('Library'),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer(
          builder: (context, watch, _) {
            final selectedVideo = watch(selectedVideoProvider).state;
            final _miniplayerController =
                watch(miniPlayerControllerProvider).state;
            print(selectedVideo);
            return Stack(
              children: _screens
                  .asMap()
                  .map((i, value) => MapEntry(
                      i,
                      Offstage(
                        offstage: _selectedIndex != i,
                        child: value,
                      )))
                  .values
                  .toList()
                    ..add(Offstage(
                      offstage: selectedVideo == null,
                      child: Miniplayer(
                          controller: _miniplayerController,
                          minHeight: _playerMinHeight,
                          maxHeight: MediaQuery.of(context).size.height,
                          builder: (height, percentage) {
                            if (selectedVideo == null) return SizedBox.shrink();
                            if (height <= _playerMinHeight + 80.0)
                              return Container(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Image.network(
                                            selectedVideo.thumbnailUrl,
                                            height: _playerMinHeight - 4.0,
                                            width: 120.0,
                                            fit: BoxFit.cover,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Flexible(
                                                      child: Text(
                                                    selectedVideo.title,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption!
                                                        .copyWith(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                  )),
                                                  Text(
                                                    selectedVideo
                                                        .author.username,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.play_arrow)),
                                          IconButton(
                                              onPressed: () {
                                                context
                                                    .read(selectedVideoProvider)
                                                    .state = null;
                                              },
                                              icon: Icon(Icons.close))
                                        ],
                                      ),
                                      const LinearProgressIndicator(
                                        value: 0.4,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.red),
                                      )
                                    ],
                                  ));
                            return VideoScreen();
                          }),
                    )),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedFontSize: 10.0,
          unselectedFontSize: 10.0,
          onTap: (i) => setState(() => _selectedIndex = i),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined),
                activeIcon: Icon(Icons.explore),
                label: 'Explore'),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline),
                activeIcon: Icon(Icons.add_circle),
                label: 'Add'),
            BottomNavigationBarItem(
                icon: Icon(Icons.subscriptions_outlined),
                activeIcon: Icon(Icons.subscriptions),
                label: 'Subscriptions'),
            BottomNavigationBarItem(
                icon: Icon(Icons.video_library_outlined),
                activeIcon: Icon(Icons.video_library),
                label: 'Library'),
          ],
        ),
      ),
    );
  }
}
