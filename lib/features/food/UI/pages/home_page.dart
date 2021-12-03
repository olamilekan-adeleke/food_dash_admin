import '../../../../cores/constants/color.dart';
import '../../../../cores/utils/navigator_service.dart';
import '../../../../cores/utils/route_name.dart';
import '../../../../features/auth/model/user_details_model.dart';
import '../../../../features/food/UI/pages/wallet_page.dart';
import '../../../../features/food/repo/local_database_repo.dart';
import 'package:flutter/material.dart';
import '../../../../cores/components/custom_scaffold_widget.dart';
import '../../../../cores/components/custom_text_widget.dart';
import '../../../../cores/utils/sizer_utils.dart';

import '../../../../features/food/UI/widgets/header_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            const SizedBox(height: 10),
            const HeaderWidget(iconData: Icons.menu_outlined, title: 'Home'),
            SizedBox(height: sizerSp(10.0)),
            CircleAvatar(
              backgroundColor: kcPrimaryColor,
              radius: sizerSp(45),
              child: Icon(
                Icons.person,
                size: sizerSp(40),
                color: Colors.grey.shade100,
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
                    Row(
                      children: [
                        Expanded(
                          child: WalletOptionItemWidget(
                            title: 'All Orders',
                            callback: () => CustomNavigationService()
                                .navigateTo(RouteName.allOrderScreen),
                          ),
                        ),
                        SizedBox(width: sizerSp(10.0)),
                        Expanded(
                          child: WalletOptionItemWidget(
                            title: 'Metrics',
                            callback: () => CustomNavigationService()
                                .navigateTo(RouteName.metric),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: sizerSp(10.0)),
                    Row(
                      children: [
                        Expanded(
                          child: WalletOptionItemWidget(
                            title: 'Restaurants',
                            callback: () => CustomNavigationService()
                                .navigateTo(RouteName.fastFoodScreen),
                          ),
                        ),
                        SizedBox(width: sizerSp(10.0)),
                        Expanded(
                          child: WalletOptionItemWidget(
                            title: 'Add New Fast Food',
                            callback: () => CustomNavigationService()
                                .navigateTo(RouteName.addfastFoodScreen),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: sizerSp(10.0)),
                    Row(
                      children: [
                        Expanded(
                          child: WalletOptionItemWidget(
                            title: 'Send Notification',
                            callback: () => CustomNavigationService()
                                .navigateTo(
                                    RouteName.sendNotificationPageScreen),
                          ),
                        ),
                        SizedBox(width: sizerSp(10.0)),
                        Expanded(
                          child: WalletOptionItemWidget(
                            title: 'Add Market Item',
                            callback: () => CustomNavigationService()
                                .navigateTo(RouteName.addMarketItemScreen),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: sizerSp(10.0)),
                    Row(
                      children: [
                        Expanded(
                          child: WalletOptionItemWidget(
                            title: 'Edit Delivery Fee',
                            callback: () => CustomNavigationService()
                                .navigateTo(RouteName.editDeliveryScreen),
                          ),
                        ),
                        SizedBox(width: sizerSp(10.0)),
                        Expanded(
                          child: WalletOptionItemWidget(
                            title: 'Edit Rider Fee',
                            callback: () => CustomNavigationService()
                                .navigateTo(RouteName.editRiderFee),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: sizerSp(10.0)),
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
