import 'package:flutter/material.dart';
import '../../../../cores/components/custom_scaffold_widget.dart';
import '../../../../cores/components/custom_text_widget.dart';
import '../../../../cores/utils/locator.dart';
import '../../../../cores/utils/navigator_service.dart';
import '../../../../cores/utils/route_name.dart';
import '../../../../cores/utils/sizer_utils.dart';
import '../../../../features/auth/model/user_details_model.dart';
import '../../../../features/auth/repo/auth_repo.dart';
import '../../../../features/food/UI/pages/wallet_page.dart';
import '../../../../features/food/UI/widgets/header_widget.dart';
import '../../../../features/food/repo/local_database_repo.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen();

  static final LocaldatabaseRepo localdatabaseRepo =
      locator<LocaldatabaseRepo>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizerSp(10)),
        child: Column(
          children: <Widget>[
            SizedBox(height: sizerSp(20.0)),
            const HeaderWidget(iconData: null, title: 'Profile '),
            SizedBox(height: sizerSp(10.0)),
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              radius: sizerSp(45),
              child: Icon(
                Icons.person,
                size: sizerSp(40),
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: sizerSp(20.0)),
            ValueListenableBuilder<RiderDetailsModel?>(
              valueListenable: LocaldatabaseRepo.userDetail,
              builder: (
                BuildContext context,
                RiderDetailsModel? user,
                Widget? child,
              ) {
                if (user == null) {
                  return Container();
                }

                return Column(
                  children: <Widget>[
                    CustomTextWidget(
                      text: user.fullName,
                      fontSize: sizerSp(14),
                      fontWeight: FontWeight.bold,
                    ),
                    CustomTextWidget(
                      text: user.email,
                      fontSize: sizerSp(13),
                      fontWeight: FontWeight.w200,
                    ),
                    CustomTextWidget(
                      text: user.phoneNumber.toString(),
                      fontSize: sizerSp(13),
                      fontWeight: FontWeight.w200,
                    ),
                    SizedBox(height: sizerSp(40.0)),
                    // WalletOptionItemWidget(
                    //   title: 'Edit Profile',
                    //   callback: () => CustomNavigationService()
                    //       .navigateTo(RouteName.editProfileScreen),
                    //   color: Colors.white,
                    // ),
                    SizedBox(height: sizerSp(10.0)),
                    // WalletOptionItemWidget(
                    //   title: 'Delivery History',
                    //   callback: () => CustomNavigationService().navigateTo(
                    //     RouteName.oderHistoryScreen,
                    //     argument: user.uid,
                    //   ),
                    // ),
                    // SizedBox(height: sizerSp(10.0)),
                    // WalletOptionItemWidget(
                    //   title: 'Chnage Password',
                    //   callback: () => CustomNavigationService()
                    //       .navigateTo(RouteName.forgotPassword),
                    // ),
                    // SizedBox(height: sizerSp(40.0)),
                    WalletOptionItemWidget(
                      title: 'Log Out',
                      callback: () => AuthenticationRepo().signOut(),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
