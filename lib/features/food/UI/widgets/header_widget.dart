import 'package:flutter/material.dart';
import '../../../../cores/components/custom_text_widget.dart';
import '../../../../cores/components/image_widget.dart';
import '../../../../cores/constants/asset.dart';
import '../../../../cores/constants/color.dart';
import '../../../../cores/utils/emums.dart';
import '../../../../cores/utils/navigator_service.dart';
import '../../../../cores/utils/route_name.dart';
import '../../../../cores/utils/sizer_utils.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key? key,
    required this.iconData,
    required this.title,
    this.trailing,
  }) : super(key: key);

  const HeaderWidget.appbar(
    this.title,
  )   : iconData = null,
        this.trailing = null;

  final IconData? iconData;
  final Widget? trailing;

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        if (iconData != null)
          InkWell(
            onTap: () =>
                CustomNavigationService().navigateTo(RouteName.profileScreen),
            child: Icon(
              iconData,
              size: sizerSp(17),
              color: Colors.black,
            ),
          )
        else
          InkWell(
            onTap: () => CustomNavigationService().goBack(),
            child: CircleAvatar(
              radius: sizerSp(12),
              backgroundColor: kcPrimaryColor,
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios,
                  size: sizerSp(11),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        CustomTextWidget(
          text: title,
          fontSize: sizerSp(20),
          fontWeight: FontWeight.bold,
        ),
        if (iconData != null)
          CircleAvatar(
            radius: sizerSp(15),
            backgroundColor: kcPrimaryColor,
            child: SizedBox(
              height: sizerSp(15),
              width: sizerSp(15),
              child: const CustomImageWidget(
                imageUrl: Assets.person,
                imageTypes: ImageTypes.asset,
              ),
            ),
          )
        else if (trailing != null)
          Container(child: trailing)
        else
          Container(),
      ],
    );
  }
}

class EdgeInserts {}