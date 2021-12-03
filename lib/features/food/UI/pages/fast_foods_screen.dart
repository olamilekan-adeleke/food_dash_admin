import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_dash_admin/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_admin/cores/components/custom_text_widget.dart';
import 'package:food_dash_admin/cores/components/image_widget.dart';
import 'package:food_dash_admin/cores/constants/color.dart';
import 'package:food_dash_admin/cores/utils/emums.dart';
import 'package:food_dash_admin/cores/utils/navigator_service.dart';
import 'package:food_dash_admin/cores/utils/route_name.dart';
import 'package:food_dash_admin/cores/utils/sizer_utils.dart';
import 'package:food_dash_admin/features/food/UI/widgets/header_widget.dart';
import 'package:food_dash_admin/features/food/model/merchant_model.dart';
import 'package:food_dash_admin/features/food/repo/rider_repo.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class FastFoodScreen extends StatelessWidget {
  const FastFoodScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizerSp(10)),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(height: sizerSp(20.0)),
            const HeaderWidget(iconData: null, title: 'Fast Foods'),
            SizedBox(height: sizerSp(10.0)),
            SizedBox(
              // height: MediaQuery.of(context).size.height * 0.70,
              child: PaginateFirestore(
                itemBuilder: (
                  int index,
                  BuildContext context,
                  DocumentSnapshot<Object?> documentSnapshot,
                ) {
                  final Map<String, dynamic>? data =
                      documentSnapshot.data() as Map<String, dynamic>?;

                  final MerchantModel merchant = MerchantModel.fromMap(
                    data!,
                    documentSnapshot.id,
                  );

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: sizerSp(5.0)),
                    child: ListTile(
                      onTap: () => CustomNavigationService().navigateTo(
                        RouteName.selectedfastFoodScreen,
                        argument: merchant,
                      ),
                      leading: SizedBox(
                        height: 80,
                        width: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: CustomImageWidget(
                            imageTypes: merchant.image== null ? ImageTypes.none : ImageTypes.network,
                            imageUrl: merchant.image ?? '',
                          ),
                        ),
                      ),
                      title: CustomTextWidget(
                        text: merchant.name,
                        fontWeight: FontWeight.w400,
                        fontSize: sizerSp(15),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomTextWidget(
                            text: merchant.categories.toList().join(', '),
                            fontWeight: FontWeight.w200,
                            fontSize: sizerSp(12),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CustomTextWidget(
                                    text: merchant.rating.toString(),
                                    fontWeight: FontWeight.w200,
                                    fontSize: sizerSp(12),
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 15,
                                    color: kcPrimaryColor,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  CustomTextWidget(
                                    text: merchant.numberOfRating.toString(),
                                    fontWeight: FontWeight.w200,
                                    fontSize: sizerSp(12),
                                  ),
                                  CustomTextWidget(
                                    text: ' Ratings',
                                    fontWeight: FontWeight.w200,
                                    fontSize: sizerSp(12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                emptyDisplay: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: sizerSp(15)),
                      CustomTextWidget(
                        text: 'No Restaurants Found',
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                        fontSize: sizerSp(15),
                      ),
                      SizedBox(height: sizerSp(15)),
                      Icon(
                        Icons.shopping_bag,
                        size: 200,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
                query: RiderRepo.restaurantsCollectionRef.orderBy('name'),
                itemBuilderType: PaginateBuilderType.listView,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisExtent: MediaQuery.of(context).size.width * 0.75,
                  mainAxisSpacing: 10,
                ),
                itemsPerPage: 10,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                // scrollDirection: Axis.horizontal,
                // isLive: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
