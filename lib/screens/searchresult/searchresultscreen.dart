import 'package:flutter/material.dart';
import 'package:yt_save/domain/appcolors.dart';
import 'package:yt_save/widgets/uihelper.dart';

class SearchResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background1,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
            height: 140,
            decoration: BoxDecoration(
              color: Color(0xFF2B2B2B),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 8.3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 11),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: UiHelper.CustomImage(img: "Back.png"),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.88,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFFAFAFAF), width: 1),
                  ),
                  child: TextField(
                    controller: SearchController(),
                    decoration: InputDecoration(
                      hintText: "Search or paste link",
                      hintStyle: TextStyle(fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 13,
                        horizontal: 12,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchResultScreen(),
                            ),
                          );
                        },
                        child: UiHelper.CustomImage(img: "SearchOnly.png"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: UiHelper.CustomText(
                      text: "Search Results",
                      color: Colors.white,
                      fontsize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  UiHelper.VideoCard(
                    context: context,
                    name: "Video 1",
                    channel: "Channel 1",
                    home: false,
                  ),
                  UiHelper.VideoCard(
                    context: context,
                    name: "Video 1",
                    channel: "Channel 1",
                    home: false,
                  ),
                  UiHelper.VideoCard(
                    context: context,
                    name: "Video 1",
                    channel: "Channel 1",
                    home: false,
                  ),
                  UiHelper.VideoCard(
                    context: context,
                    name: "Video 1",
                    channel: "Channel 1",
                    home: false,
                  ),
                  UiHelper.VideoCard(
                    context: context,
                    name: "Video 1",
                    channel: "Channel 1",
                    home: false,
                  ),
                  UiHelper.VideoCard(
                    context: context,
                    name: "Video 1",
                    channel: "Channel 1",
                    home: false,
                  ),
                  SizedBox(height: 50)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
