import 'package:flutter/material.dart';
import 'package:yt_save/domain/appcolors.dart';

import '../screens/searchresult/searchresultscreen.dart';

class UiHelper {
  static CustomImage({required String img}) {
    return Image.asset("assets/images/$img");
  }

  static CustomText({
    required String text,
    required Color color,
    String? fontfamily,
    required double fontsize,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontsize,
        fontFamily: fontfamily ?? "regular",
        color: color,
      ),
    );
  }

  static CustomTextField({
    required TextEditingController controller,
    required BuildContext context,
  }) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Search or paste link",
          hintStyle: TextStyle(fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          suffixIcon: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchResultScreen()),
              );
            },
            child: UiHelper.CustomImage(img: "Search.png"),
          ),
        ),
      ),
    );
  }

  static CustomTextFieldTwo({
    required TextEditingController controller,
    required BuildContext context,
  }) {
    return Container(
      height: 35,
      margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Color(0xFFAFAFAF), width: 0.5),
        color: Color(0xFF2B2B2B),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Search or paste link",
          hintStyle: TextStyle(fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 11, horizontal: 12),
          suffixIcon: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchResultScreen()),
              );
            },
            icon: UiHelper.CustomImage(img: "Search.png"),
          ),
        ),
      ),
    );
  }

  static DownloadOptions({
    required String type,
    required String quality,
    required String size,
    required BuildContext context
}) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                UiHelper.CustomText(text: type, color: Colors.white, fontsize: 16),
                UiHelper.CustomText(text: quality, color: Color(0xFF9C9C9C), fontsize: 12)
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    UiHelper.CustomText(text: size, color: Color(0xFF9C9C9C), fontsize: 12),
                    SizedBox(width: 10),
                    ElevatedButton(onPressed: () {
                      print("download");
                    },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.all(0)
                        ),
                        child: UiHelper.CustomImage(img: "Download.png"))
                  ],
                )
              ],
            )
          ],
        ),
      );
  }

  static Widget VideoCard({
    required BuildContext context,
    required String name,
    required String channel,
    required bool home
  }) {
    return Container(
      height: 133,
      width: MediaQuery.of(context).size.width * 0.95,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background5,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(
          color: Colors.black,
          blurRadius: 6.2,
          offset: Offset(1, 2)
        )]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 120,
            width: (MediaQuery.of(context).size.width * 0.95) / 2.3,
            decoration: BoxDecoration(
              color: Color(0xFF535353),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // UiHelper.CustomImage(img: "SplashLogo.png"),
                UiHelper.CustomImage(img: "Play.png"),
              ],
            ),
          ),
          SizedBox(
            width: (MediaQuery.of(context).size.width * 0.95) / 1.9,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      UiHelper.CustomText(
                        text: name,
                        color: Colors.white,
                        fontfamily: "bold",
                        fontsize: 14,
                      ),
                      home?
                      UiHelper.CustomText(
                        text: "MP4",
                        color: Color(0xFFDBDF60),
                        fontfamily: "bold",
                        fontsize: 12,
                      ) : SizedBox.shrink(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      UiHelper.CustomText(
                        text: channel,
                        color: Colors.white,
                        fontsize: 12,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Color(0XFFDBDF5B),
                  //     borderRadius: BorderRadius.circular(20),
                  //   ),
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(6.0),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         home?
                  //         UiHelper.CustomText(
                  //           text: "Go to file location",
                  //           color: Colors.black,
                  //           fontsize: 10,
                  //         ) :
                  //         UiHelper.CustomText(
                  //           text: "Download",
                  //           color: Colors.black,
                  //           fontsize: 10,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  home?
                  SizedBox(
                    width: (MediaQuery.of(context).size.width * 0.95) / 1.9,
                    height: 30,
                    child: ElevatedButton(onPressed: () {
                      print("hi");
                    },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0XFFDBDF5B),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.all(4.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        )
                      ),
                      child: UiHelper.CustomText(
                                text: "Go to location",
                                color: Colors.black,
                                fontsize: 10,)
                                ),
                  ) : SizedBox(
                    width: (MediaQuery.of(context).size.width * 0.95) / 1.9,
                    height: 30,
                    child: ElevatedButton(onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20)
                            )
                          ),
                          builder: (context) => Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20)
                              ),
                              color: Color(0xFF282828),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 6,),
                                Container(width: 70, height: 3,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF4B4B4B),
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                ),
                                SizedBox(height: 20),
                                UiHelper.CustomText(text: "Download Options", color: Colors.white, fontsize: 16),
                                SizedBox(height: 15),
                                Divider(
                                  color: Color(0xFF5C5C5C),
                                  thickness: 1,
                                  indent: 20,
                                  endIndent: 20,
                                ),
                                UiHelper.DownloadOptions(type: "Video - MP4", quality: "480p", size: "80 MB", context: context),
                                SizedBox(height: 15),
                                Divider(
                                  color: Color(0xFF5C5C5C),
                                  thickness: 1,
                                  indent: 20,
                                  endIndent: 20,
                                ),
                                UiHelper.DownloadOptions(type: "Video - MP4", quality: "720p", size: "100 MB", context: context),
                                SizedBox(height: 15),
                                Divider(
                                  color: Color(0xFF5C5C5C),
                                  thickness: 1,
                                  indent: 20,
                                  endIndent: 20,
                                ),
                                UiHelper.DownloadOptions(type: "Video - MP4", quality: "1080p", size: "200 MB", context: context),
                                SizedBox(height: 15),
                                Divider(
                                  color: Color(0xFF5C5C5C),
                                  thickness: 1,
                                  indent: 20,
                                  endIndent: 20,
                                ),
                                UiHelper.DownloadOptions(type: "Audio - MP3", quality: "128 Kbps", size: "10 MB", context: context),
                                SizedBox(height: 15),
                                Divider(
                                  color: Color(0xFF5C5C5C),
                                  thickness: 1,
                                  indent: 20,
                                  endIndent: 20,
                                ),
                                UiHelper.DownloadOptions(type: "Audio - MP3", quality: "320 Kbps", size: "20 MB", context: context),
                                SizedBox(height: 15),
                                Divider(
                                  color: Color(0xFF5C5C5C),
                                  thickness: 1,
                                  indent: 20,
                                  endIndent: 20,
                                ),
                              ],
                            ),
                          ));
                    },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0XFFDBDF5B),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.all(4.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            )
                        ),
                        child: UiHelper.CustomText(
                          text: "Download",
                          color: Colors.black,
                          fontsize: 10,)
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
