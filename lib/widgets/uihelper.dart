import 'package:flutter/material.dart';
import 'package:yt_save/domain/appcolors.dart';

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

  static CustomTextField ({required TextEditingController controller}) {
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
          suffixIcon: UiHelper.CustomImage(img: "Search.png")
        ),
      ),
    );
  }

  static Widget VideoCard({required BuildContext context, required String name, required String channel}) {
    return Container(
      height: 133,
      width: MediaQuery.of(context).size.width * 0.95,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background5,
        borderRadius: BorderRadius.circular(10)
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
              borderRadius: BorderRadius.circular(5)
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
                      UiHelper.CustomText(text: name, color: Colors.white, fontfamily: "bold", fontsize: 14),
                      UiHelper.CustomText(text: "MP4", color: Color(0xFFDBDF60), fontfamily: "bold", fontsize: 12)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      UiHelper.CustomText(text: channel, color: Colors.white, fontsize: 12)
                    ],
                  ),
                  SizedBox(height: 20,),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0XFFDBDF5B),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          UiHelper.CustomText(text: "Go to file location", color: Colors.black, fontsize: 10),
                        ],
                      ),
                    )
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
