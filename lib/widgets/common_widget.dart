import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constant/colors.dart';

double kEditTextCornerRadius = 8.0;
double kBorderRadius = 5.0;
double kButtonCornerRadius = 8.0;
double kCardCornerRadius = 16.0;
double kButtonHeight = 42;
double kDropDownHeight = 32;
double contentSize = 14.0;
double titleSize = 18.0;
double textFiledSize = 16.0;

Widget getBackArrow({Color color = black}) {
  return Container(
    alignment: Alignment.centerLeft,
    margin: const EdgeInsets.only(left: 4, right: 4, top: 4, bottom: 4),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Image.asset(
        'assets/images/ic_back_button.png',
        width: 24,
        height: 24,
        color: color,
      ),
    ),
  );
}

Widget getCloseArrow() {
  return Container(
    alignment: Alignment.centerLeft,
    margin: const EdgeInsets.only(left: 4, right: 4, top: 4, bottom: 4),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Image.asset('assets/images/ic_close.png', width: 24, height: 24),
    ),
  );
}

Widget getTitle(String title, {Color color = black, double fontSize = 16}) {
  return Text(
    title,
    textAlign: TextAlign.start,
    style: TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w600,
    ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  );
}

Widget getTitleMultiline(
  String title, {
  Color color = black,
  double fontSize = 16,
}) {
  return Text(
    title,
    textAlign: TextAlign.start,
    style: TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w600,
    ),
  );
}

getTitleTextStyle() {
  return TextStyle(fontWeight: FontWeight.w300, color: black, fontSize: 16);
}

TextStyle getLightTextStyle({Color color = black, double fontSize = 14}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: FontWeight.w300,
  );
}

TextStyle getRegularTextStyle({Color color = black, double fontSize = 14,FontWeight fontWeight = FontWeight.w400}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
  );
}

TextStyle getMediumTextStyle({Color color = black, double fontSize = 14}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: FontWeight.w500,
  );
}

TextStyle getSemiBoldTextStyle({Color color = black, double fontSize = 14}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: FontWeight.w600,
  );
}

TextStyle getBoldTextStyle({Color color = black, double fontSize = 14}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: FontWeight.w700,
  );
}

Widget getCommonButton(String title, bool isLoading, void Function() onPressed,{double fontSize = 14,Color bgColor = brandColor,Color? textColor,EdgeInsetsGeometry? textPadding}){
  return TextButton(
    onPressed: onPressed,
    style: ButtonStyle(
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      backgroundColor: WidgetStateProperty.all<Color>(bgColor),
    ),
    child: isLoading
        ? Padding(
      padding: const EdgeInsets.only(top: 9,bottom: 8),
      child: SizedBox(width: 17,height: 17,child: CircularProgressIndicator(color: textColor ?? white,strokeWidth: 2)),
    )
        : Padding(
      padding:textPadding ?? const EdgeInsets.only(left: 8,right: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500, color: textColor ?? white, ),
      ),
    ),
  );
}

Widget getCommonButtonWithBorder(
  String title,
  bool isLoading,
  void Function() onPressed, {
  Color color = brandColor,
}) {
  return TextButton(
    onPressed: onPressed,
    style: ButtonStyle(
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(width: 1, color: color),
        ),
      ),
      backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
    ),
    child: isLoading
        ? Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(color: color, strokeWidth: 2),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
  );
}

Widget getCommonButtonWithIcon(String title, String image, bool isLoading, void Function() onPressed, {Color bgColor = brandColor, bool isLeftRightSideIcon = true, bool isSmallFont = false, double imageSize = 20,double borderRadius = 10, EdgeInsets? padding}){
  return TextButton(
    onPressed: onPressed,
    style: ButtonStyle(
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      ),
      backgroundColor: WidgetStateProperty.all<Color>(bgColor),
    ),
    child: isLoading
        ? Padding(
      padding: padding ?? EdgeInsets.only(top: 10,bottom: 10),
      child: SizedBox(width: 16,height: 16,child: CircularProgressIndicator(color: white,strokeWidth: 2)),
    )
        : Padding(
      padding: padding ?? const EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: !isLeftRightSideIcon,
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              child: Image.asset(image, height: imageSize, width: imageSize, color: white,),
            ),
          ),
          Flexible(
            child: Text(
              title,
              style: TextStyle(fontSize: isSmallFont ? 12 : 14, fontWeight: FontWeight.w600, color: white,),
              textAlign: TextAlign.center,
            ),
          ),
          Visibility(
            visible: isLeftRightSideIcon,
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              child: Image.asset(image, height: imageSize, width: imageSize, color: white,),
            ),
          ),
        ],
      ),
    ),
  );
}


Widget commonSearchTextField(
  TextEditingController controller,
  String hintText,
  Function(String)? onChanged,
  Function(String)? onFieldSubmitted,
  VoidCallback? closeTap,
) {
  return TextFormField(
    controller: controller,
    cursorColor: black,
    textInputAction: TextInputAction.search,
    onChanged: onChanged,
    onFieldSubmitted: onFieldSubmitted,
    onTapOutside: (value) {
      FocusManager.instance.primaryFocus?.unfocus();
    },
    decoration: InputDecoration(
      filled: true,
      fillColor: searchColor,
      hintText: hintText,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12),
        child: Icon(Icons.search),
      ),
      suffixIcon: controller.text.isNotEmpty
          ? GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => closeTap?.call(),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Image.asset(
                  'assets/images/ic_close.png',
                  height: 18,
                  width: 18,
                  color: black,
                ),
              ),
            )
          : null,
    ),
  );
}

Widget commonSearchTextFieldVoter(
  TextEditingController controller,
  String hintText,
  Function(String)? onChanged,
  Function(String)? onFieldSubmitted,
  VoidCallback? closeTap, {
  FocusNode? focusNode,
}) {
  return Container(
    height: 55,
    color: white,
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      height: 45,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        cursorColor: black,
        focusNode: focusNode,
        textInputAction: TextInputAction.search,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: white,
          hintText: hintText,
          hintStyle: getRegularTextStyle(fontSize: 12, color: searchColor),
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          // prefixIcon: Padding(
          //   padding: const EdgeInsets.all(6),
          //   child: Icon(Icons.search),
          // ),
          suffixIcon: controller.text.isNotEmpty
              ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => closeTap?.call(),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Image.asset(
                      'assets/images/ic_close.png',
                      height: 18,
                      width: 18,
                      color: Colors.black,
                    ),
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomLeft: Radius.circular(4),
            ),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomLeft: Radius.circular(4),
            ),
            borderSide: BorderSide(color: colorSearchBorder),
          ),
        ),
      ),
    ),
  );
}

Widget getBottomSheetHeaderWithoutButton(BuildContext context, String title) {
  return Container(
    margin: EdgeInsets.only(top: 6),
    width: MediaQuery.of(context).size.width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 2,
          width: 50,
          alignment: Alignment.center,
          color: gray,
          margin: const EdgeInsets.only(top: 6, bottom: 6),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: brandColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

Widget getBottomSheetHeaderWithButton(BuildContext context, String title) {
  return Container(
    width: MediaQuery.of(context).size.width,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // GestureDetector(onTap: ()=>Navigator.pop(context),child: Image.asset("assets/images/ic_close.png",height: 20,width: 20,))
      ],
    ),
  );
}

Widget getBottomSheetItemWithoutSelection(String title,bool isSelected,bool isDividerVisible) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isSelected ? brandColor : black,
            fontSize: 14,
          ),
        ),
      ),
      Container(
        height: 1,
        color: isDividerVisible ? Colors.transparent : borderGray,
      ),
    ],
  );
}

int? extractLeadingNumber(String input) {
  final RegExp regExp = RegExp(r'^\d+');
  final Match? match = regExp.firstMatch(input);

  if (match != null) {
    return int.parse(match.group(0)!);
  }

  // Return null if no number is found at the beginning
  return null;
}

Future<void> launchDialer(String phoneNumber) async {
  final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);

  if (await canLaunchUrl(telUri)) {
    await launchUrl(telUri);
  } else {
    throw 'Could not launch $telUri';
  }
}



Future<bool> openWhatsApp(String phone, String message) async {
  final Uri appUrl = Uri.parse("whatsapp://send?phone=$phone&text=${Uri.encodeFull(message)}");
  final Uri webUrl = Uri.parse("https://wa.me/$phone?text=${Uri.encodeFull(message)}");

  try {
    if (await launchUrl(appUrl, mode: LaunchMode.externalApplication)) {
      return true;
    } else {
      if (await launchUrl(webUrl, mode: LaunchMode.externalApplication)) {
        return true;
      }
    }
  } catch (e) {
    try {
      if (await launchUrl(webUrl, mode: LaunchMode.externalApplication)) {
        return true;
      }
    } catch (e) {
      print("Cannot open WhatsApp web either: $e");
    }
  }
  return false;
}

getCommonCardWithoutShadow(color,{double borderRadius = 8}){
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(kCardCornerRadius),
  );
}

getCommonCard({Border? border,Color bgColor = white,double? borderRadius,BoxShape shape = BoxShape.rectangle,}){
  return BoxDecoration(
    color: bgColor,
    borderRadius: shape == BoxShape.rectangle
        ? BorderRadius.circular(borderRadius ?? kCardCornerRadius)
        : null,
    border:border,
    shape: shape,
    boxShadow: [
      BoxShadow(
        color: cardBgColor, //color of shadow
        spreadRadius: 5, //spread radius
        blurRadius: 9, // blur radius
        offset: const Offset(0, 2), // changes position of shadow
      )
    ],
  );
}


Widget circularProgress({Color progressColor = gray, double circlePadding = 16, double size = 18}){
  return Container(
    height: size,
    width: size,
    padding: EdgeInsets.all(circlePadding),
    child: CircularProgressIndicator(color: progressColor, strokeWidth: 2,),
  );
}

Widget getFilterChip(String title, String matchedTitle, VoidCallback? onCloseClick, {bool isDisplayClose = true}){
  return Container(
    alignment: Alignment.center,
    margin: const EdgeInsets.only(right: 6),
    decoration: BoxDecoration(
      color: matchedTitle != title ? brandColor.withValues(alpha: 0.1) : white,
      borderRadius: const BorderRadius.all(Radius.circular(32)),
      border: Border.all(color: matchedTitle != title ? brandColor : borderGray, width: 2),
    ),
    padding: const EdgeInsets.only(left: 12),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: getMediumTextStyle(fontSize: 12, color: matchedTitle != title ? brandColor : gray),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),
        const Gap(8),
        matchedTitle == title
            ? Image.asset("assets/images/ic_down.png", height: 18, width: 18, color: gray)
            : isDisplayClose ?
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            onCloseClick?.call();
          },
          child: Image.asset("assets/images/ic_close.png", height: 16, width: 16, color: black,),
        ) : Image.asset("assets/images/ic_down.png", height: 18, width: 18, color: gray),
        const Gap(8),
      ],
    ),
  );
}
