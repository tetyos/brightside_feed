import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatelessWidget {

  final List<PageViewModel> pageViewModels = [
    PageViewModel(
      title: "Welcome to Nera-News!",
      body: "Here you will find news of events, initiatives and more things that help to advance our society into a new era...",
      image: Image.asset('images/intro1.png'),
    ),
    PageViewModel(
      title: "A new era?",
      body:
          "Most of us are pretty aware of the numerous challenges of today and of the decades to come."
          "But while it is good to know what we are up against, it is just as important to remember what we are fighting for.\n "
          "Goal of this project is to highlight the progress of our society that is made possible by millions of people around the globe. "
          "Even though it seems unlikely at the moment - there is a chance for our society to advance into an utopian-like civilization. One, in which it will not be so relevant anymore in which nation you are born or which gender you are of. In which access food, energy, transportation, information, and shelter are a fundamental right. "
          "For more information why this is a possibility, check out the report by the think tank: RethinkX.",
      image: Image.asset('images/intro2.png'),
    ),
    PageViewModel(
      title: "Community driven",
      body: "You can add your own content by providing links to the news that you think fit here. Or you can just browse through a large number of automatically collected news and help to filter the one that inspires the most.",
      image: Image.asset('images/intro3.png'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: pageViewModels,
      onDone: () {
        // When done button is press
      },
      showNextButton: false,
      showSkipButton: true,
      skip: const Text("Skip"),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
