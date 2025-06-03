import 'package:flutter/material.dart';
import 'package:yt_save/domain/appcolors.dart';
import 'package:yt_save/widgets/uihelper.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background1,
      body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.background3, AppColors.background4],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                height: MediaQuery.of(context).size.height * 0.27,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            UiHelper.CustomText(
                              text: "YT",
                              color: Color(0xFFFFFFFF),
                              fontfamily: "bold",
                              fontsize: 24,
                            ),
                            UiHelper.CustomText(
                              text: " Save",
                              color: Color(0xFF000000),
                              fontfamily: "bold",
                              fontsize: 24,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            UiHelper.CustomText(
                              text: "Download and view Youtube videos",
                              fontfamily: "bold",
                              color: Color(0xFF181035),
                              fontsize: 13,
                            ),
                            UiHelper.CustomText(
                              text: " Effortlessly",
                              fontfamily: "bold",
                              color: Color(0xFF313131),
                              fontsize: 13,
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            UiHelper.CustomTextField(
                              controller: SearchController(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: UiHelper.CustomText(text: "Your Downloads", color: Colors.white, fontsize: 22)
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    UiHelper.VideoCard(context: context, name: "Video 1", channel: "Channel 1"),
                    UiHelper.VideoCard(context: context, name: "Video 1", channel: "Channel 1"),
                    UiHelper.VideoCard(context: context, name: "Video 1", channel: "Channel 1"),
                    UiHelper.VideoCard(context: context, name: "Video 1", channel: "Channel 1"),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}
