import 'package:flutter/material.dart';
import 'package:food_dash_admin/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_admin/cores/components/custom_text_widget.dart';
import 'package:food_dash_admin/cores/constants/color.dart';
import 'package:food_dash_admin/cores/utils/navigator_service.dart';
import 'package:food_dash_admin/cores/utils/route_name.dart';
import 'package:food_dash_admin/cores/utils/sizer_utils.dart';
import 'package:food_dash_admin/features/food/UI/pages/fast_food_items.dart';
import 'package:food_dash_admin/features/food/UI/pages/wallet_page.dart';
import 'package:food_dash_admin/features/food/UI/widgets/header_widget.dart';
import 'package:food_dash_admin/features/food/model/merchant_model.dart';
import 'package:food_dash_admin/features/food/repo/rider_repo.dart';

class SelectedFastFoodScreen extends StatelessWidget {
  SelectedFastFoodScreen(this.merchant);

  final MerchantModel merchant;

  final RiderRepo riderRepo = RiderRepo();

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            const SizedBox(height: 10),
            HeaderWidget(
              iconData: null,
              title: merchant.name,
            ),
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
            Column(
              children: <Widget>[
                CustomTextWidget(
                  text: merchant.name,
                  fontSize: sizerSp(14),
                  fontWeight: FontWeight.bold,
                ),
                CustomTextWidget(
                  text: merchant.categories.toList().join(', '),
                  fontSize: sizerSp(13),
                  fontWeight: FontWeight.w200,
                ),
                CustomTextWidget(
                  text: merchant.phoneNumber.toString(),
                  fontSize: sizerSp(13),
                  fontWeight: FontWeight.w200,
                ),
                SizedBox(height: sizerSp(40.0)),
                WalletOptionItemWidget(
                  title: 'Add New Food',
                  callback: () => CustomNavigationService().navigateTo(
                    RouteName.addNewFoodScreen,
                    argument: merchant,
                  ),
                ),
                SizedBox(height: sizerSp(10.0)),
                WalletOptionItemWidget(
                  title: 'Items',
                  callback: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FastFoodItem(merchant.id)));
                  },
                ),
                SizedBox(height: sizerSp(10.0)),
                WalletOptionItemWidget(
                  title: 'Delete',
                  callback: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Delete fast Food'),
                          content: Text(
                            'Are You Sure You Want To Delete Store!',
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Close'),
                            ),
                            SizedBox(width: sizerSp(100)),
                            TextButton(
                              onPressed: () async {
                                print('HelloWorld!');
                                await riderRepo.deleteFastFood(merchant.id);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: Text('Delete!'),
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
