import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:brightside_feed/navigation/app_state.dart';
import 'package:brightside_feed/navigation/route_paths.dart';
import 'package:brightside_feed/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class IntroScreen2 extends StatefulWidget {

  @override
  State<IntroScreen2> createState() => _IntroScreen2State();
}

class _IntroScreen2State extends State<IntroScreen2> {

  final TextStyle titleTextStyle =
      TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold);

  final EdgeInsets marginTitle =
      const EdgeInsets.only(top: 50.0, bottom: 30.0, left: 20.0, right: 20.0);

  final Image image1 = Image.asset( 'images/intro1_blue.jpg', height: 180);
  final Image image3 = Image.asset( 'images/intro3.png', height: 220);
  final Image image4 = Image.asset( 'images/intro4.png');

  YoutubePlayerController _youtubePlayerController = YoutubePlayerController(
    initialVideoId: 'ZPMNmZjdgz0',
    params: YoutubePlayerParams(
      showControls: false,
      showFullscreenButton: true,
      endAt: Duration(seconds: 195),
    ),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(image1.image, context);
    precacheImage(image3.image, context);
    precacheImage(image4.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: getSlides(),
      onDonePress: () => onDone(context),
      onSkipPress: () => navigateToNextScreen(context),
      backgroundColorAllSlides: kColorPrimary,
    );
  }

  @override
  void dispose() {
    _youtubePlayerController.close();
    super.dispose();
  }

  void onDone(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(kLocalStorageIntroWatched, true);
    navigateToNextScreen(context);
  }

  void navigateToNextScreen(BuildContext context) {
    bool isDataLoading = Provider.of<AppState>(context, listen: false).isDataLoading;
    bool isUserLoggedIn = Provider.of<AppState>(context, listen: false).isUserLoggedIn;
    if (!isUserLoggedIn) {
      Provider.of<AppState>(context, listen: false).currentRoutePath = LoginScreenPath();
    } else if (!isDataLoading) {
      Provider.of<AppState>(context, listen: false).currentRoutePath = HomePath();
    } else {
      Provider.of<AppState>(context, listen: false).currentRoutePath = LoadingScreen2Path();
    }
  }

  List<Slide> getSlides() {
    return [
      Slide(
        widgetTitle: Text(
          "Welcome to the Brightside-Feed!",
          style: titleTextStyle,
          textAlign: TextAlign.center,
        ),
        marginTitle: marginTitle,
        description:
        "Here you will find news on events, tech and other things that help to advance our society into a brighter age...",
        centerWidget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.elliptical(4000, 1200)),
            child: image4,
          ),
        ),
        // pathImage: 'images/intro2.png',
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
          "A brighter age..?",
          style: titleTextStyle,
          textAlign: TextAlign.center,
        ),
        marginTitle: marginTitle,
        widgetDescription: Text(
          "The numerous challenges of today make it easy to overlook that we are also living in times that offer enormous possibilities for our future."
              "\n\nGoal of this project is to highlight the progress that our society makes everyday - a progress enabled by millions of people around the globe.",


          // "Most of us are aware of the numerous challenges of today and the decades to come. "
          // "These challenges make it easy to overlook that we are also living in times that offer enormous possibilities for our future."
          // "\n\nGoal of this project is to highlight the progress that our society makes everyday - a progress enabled by millions of people around the globe.",

          // "These challenges make it easy to overlook that we are also living in times of rapid advances in many areas - which in turn offer enormous possibilities for our future."
          // "\n\n'Some app name' highlights the progress that our society makes everyday. Hope behind that: If more people know what we are working for (and not only what we are fighting against), it may raise the chances of getting there.",
          textAlign: TextAlign.justify,
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        // centerWidget: Image.asset( 'images/intro1.jpg'),
        centerWidget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            //borderRadius: BorderRadius.all(Radius.elliptical(300, 50)),
            child: image1,
          ),
        ),
        backgroundColor: kColorPrimary,
      ),
      // Slide(
      //   widgetTitle: Text(
      //     "The chances of our time",
      //     style: titleTextStyle,
      //     textAlign: TextAlign.center,
      //   ),
      //   centerWidget: YoutubePlayerIFrame(
      //     controller: _youtubePlayerController,
      //   ),
      //   widgetDescription: Text(
      //     "The think tank RethinkX has summarized the chances and their implications in a series of short-clips. "
      //     "Even though the clips are a bit over-dramatic - they get across the point.",
      //     textAlign: TextAlign.justify,
      //     style: TextStyle(color: Colors.white, fontSize: 18.0, fontStyle: FontStyle.italic),
      //   ),
      //   // pathImage: 'images/intro1.png',
      //   backgroundColor: kColorPrimary,
      // ),
      Slide(
        widgetTitle: Text(
          "Community driven",
          style: titleTextStyle,
          textAlign: TextAlign.center,
        ),
        marginTitle: marginTitle,
        description:
        "You stumbled upon an inspiring article? Share it with the rest of the community.",
        //  "Add fitting content by providing links to it."
        //  "\n\n Or browse through already collected news and help to filter the one that inspire the most.",
        centerWidget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            //borderRadius: BorderRadius.all(Radius.elliptical(300, 50)),
            child: image3,
          ),
        ),
        backgroundColor: kColorPrimary,
      ),
    ];
  }
}
