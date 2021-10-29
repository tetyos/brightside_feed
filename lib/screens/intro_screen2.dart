import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/navigation/nexth_route_paths.dart';
import 'package:nexth/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class IntroScreen2 extends StatelessWidget {

  static TextStyle titleTextStyle = TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold);
  static EdgeInsets marginTitle = const EdgeInsets.only(
      top: 50.0, bottom: 30.0, left: 20.0, right: 20.0);

  final List<Slide> pageViewModels = [
    Slide(
      widgetTitle: Text(
        "Welcome on Nera-News!",
        style: titleTextStyle,
        textAlign: TextAlign.center,
      ),
      description: "On Nera you will find news on events, tech and other things that help to advance our society into a new era...",
      pathImage: 'images/intro2.png',
      backgroundColor: kColorPrimary,
    ),
    Slide(
      widgetTitle: Text(
        "Community driven",
        style: titleTextStyle,
        textAlign: TextAlign.center,
      ),
      description:

//      "You read an inspiring article? Add your own content, by providing the "
      "Add fitting content by providing links to it."
          "\n\n Or browse through already collected news and help to filter the one that inspire the most.",
      pathImage: 'images/intro3.png',
      backgroundColor: kColorPrimary,
    ),
    // Slide(
    //   title: "A new era?",
    //   widgetDescription: Text(
    //       "Most of us are pretty aware of the numerous challenges of today and the decades to come. "
    //       "But while it is good to know what we are up against, it is just as important to remember what we are fighting for."
    //       "\n\nEven though it seems unlikely at the moment - there is a chance for our society to advance into an utopian-like civilization. One, in which it will not be so relevant anymore in which nation you are born or which gender you are of."
    //       // "\n\nEven though it seems unlikely at the moment - there is a chance for our society to advance into an utopian-like civilization. One, in which it will not be so relevant anymore in which nation you are born or which gender you are of. In which access food, energy, transportation, information, and shelter are a fundamental right. "
    //       "\n\nGoal of this project is to highlight the progress of our society that is made possible by millions of people around the globe. "
    //       "\n\nFor more information why such a new era is more likely that one might think, check out the report by the think tank: RethinkX.",
    //     textAlign: TextAlign.justify,
    //     style: TextStyle(color: Colors.white, fontSize: 18.0, fontStyle: FontStyle.italic),
    //   )
    //       ,
    //   pathImage: 'images/intro1.png',
    //   backgroundColor: kColorPrimary,
    // ),
    Slide(
      widgetTitle: Text(
        "A new era?",
        style: titleTextStyle,
        textAlign: TextAlign.center,
      ),
      marginTitle: marginTitle,
      widgetDescription: Text(
        "Most of us are aware of the numerous challenges of today and the decades to come. "
        "These challenges make it easy to overlook that we are also living in times that offer enormous possibilities."
        "\n\nGoal of this project is to highlight the progress that our society makes everyday - enabled by millions of people around the globe.",
        textAlign: TextAlign.justify,
        style: TextStyle(color: Colors.white, fontSize: 18.0, fontStyle: FontStyle.italic),
      ),
      pathImage: 'images/intro1.png',
      backgroundColor: kColorPrimary,
    ),
    Slide(
      widgetTitle: Text(
        "The chances of our time",
        style: titleTextStyle,
        textAlign: TextAlign.center,
      ),
      centerWidget: getYoutubePlayer(),
      widgetDescription: Text(
        "The think tank RethinkX has summarized the chances and their implications in a series of short-clips. "
        "Even though the clips are a bit over-dramatic - they get across the point.",
        textAlign: TextAlign.justify,
        style: TextStyle(color: Colors.white, fontSize: 18.0, fontStyle: FontStyle.italic),
      )
          ,
      // pathImage: 'images/intro1.png',
      backgroundColor: kColorPrimary,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: pageViewModels,
      onDonePress: () {
        bool isDataLoading = Provider.of<AppState>(context, listen: false).isDataLoading;
        if (!isDataLoading) {
          Provider.of<AppState>(context, listen: false).currentRoutePath = NexthHomePath();
        } else {
          Provider.of<AppState>(context, listen: false).currentRoutePath = LoadingScreen2Path();
        }
      },
      backgroundColorAllSlides: kColorPrimary,
    );
  }

  static Widget getYoutubePlayer() {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: 'ZPMNmZjdgz0',
      params: YoutubePlayerParams(
        showControls: false,
        showFullscreenButton: true,
        endAt: Duration(seconds: 195),
      ),
    );

   return YoutubePlayerIFrame(
      controller: _controller,
    );
  }

}
