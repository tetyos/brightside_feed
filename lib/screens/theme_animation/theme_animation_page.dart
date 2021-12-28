import 'package:flutter/material.dart';
import 'package:nexth/screens/theme_animation/application/theme_service.dart';
import 'package:nexth/screens/theme_animation/widgets/moon.dart';
import 'package:nexth/screens/theme_animation/widgets/star.dart';
import 'package:nexth/screens/theme_animation/widgets/sun.dart';
import 'package:provider/provider.dart';

class ThemeAnimationPage extends StatelessWidget {
  const ThemeAnimationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(builder: (context, themeService, child) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).appBarTheme.color,
          title: Text("Theme Animation"),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Material(
              borderRadius: BorderRadius.circular(15),
              elevation: 20,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: Container(
                  height: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: themeService.isDarkModeOn
                          ? const [
                              Color(0xFF94A9FF),
                              Color(0xFF6B66CC),
                              Color(0xFF200F75),
                            ]
                          : [
                              Color(0xDDFFFA66),
                              Color(0xDDFFA057),
                              Color(0xDD940B99),
                            ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                          top: 70,
                          right: 50,
                          child: AnimatedOpacity(
                              duration: Duration(milliseconds: 200),
                              opacity: themeService.isDarkModeOn ? 1 : 0,
                              child: Star())),
                      Positioned(
                          top: 50,
                          left: 50,
                          child: AnimatedOpacity(
                              duration: Duration(milliseconds: 200),
                              opacity: themeService.isDarkModeOn ? 1 : 0,
                              child: Star())),
                      Positioned(
                          top: 100,
                          right: 200,
                          child: AnimatedOpacity(
                              duration: Duration(milliseconds: 200),
                              opacity: themeService.isDarkModeOn ? 1 : 0,
                              child: Star())),
                      Positioned(
                          top: 70,
                          left: 100,
                          child: AnimatedOpacity(
                              duration: Duration(milliseconds: 200),
                              opacity: themeService.isDarkModeOn ? 1 : 0,
                              child: Star())),
                      Positioned(
                          top: 20,
                          right: 100,
                          child: AnimatedOpacity(
                              duration: Duration(milliseconds: 200),
                              opacity: themeService.isDarkModeOn ? 1 : 0,
                              child: Star())),
                      AnimatedPadding(
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.only(
                            top: themeService.isDarkModeOn ? 100 : 50),
                        child: Center(child: Sun()),
                      ),
                      AnimatedPositioned(
                          duration: Duration(milliseconds: 400),
                          top: themeService.isDarkModeOn ? 100 : 130,
                          right: themeService.isDarkModeOn ? 100 : -40,
                          child: AnimatedOpacity(
                              duration: Duration(milliseconds: 200),
                              opacity: themeService.isDarkModeOn ? 1 : 0,
                              child: Moon())),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 225,
                          decoration: BoxDecoration(
                              color: themeService.isDarkModeOn
                                  ? Theme.of(context).appBarTheme.color
                                  : Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Test Heading",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(fontSize: 16),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                "Test body",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontSize: 14),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Dark Theme:",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(fontSize: 14),
                                  ),
                                  Switch(
                                      value: themeService.isDarkModeOn,
                                      onChanged: (value) {
                                        Provider.of<ThemeService>(context,
                                                listen: false)
                                            .toggleTheme();
                                      }),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
