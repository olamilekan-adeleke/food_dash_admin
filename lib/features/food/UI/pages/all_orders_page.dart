import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_dash_admin/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_admin/cores/components/custom_text_widget.dart';
import 'package:food_dash_admin/cores/utils/extenions.dart';
import 'package:food_dash_admin/cores/utils/locator.dart';
import 'package:food_dash_admin/features/auth/repo/auth_repo.dart';
import 'package:food_dash_admin/features/food/UI/widgets/header_widget.dart';
import 'package:food_dash_admin/features/food/model/cart_model.dart';
import 'package:food_dash_admin/features/food/model/order_model.dart';
import 'package:food_dash_admin/features/food/repo/rider_repo.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import '../../../../cores/utils/sizer_utils.dart';

class AllOrderScreen extends StatelessWidget {
  const AllOrderScreen();

  static final AuthenticationRepo authenticationRepo =
      locator<AuthenticationRepo>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizerSp(10)),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            // shrinkWrap: true,
            children: <Widget>[
              SizedBox(height: sizerSp(20.0)),
              const HeaderWidget(iconData: null, title: 'Orders'),
              SizedBox(height: sizerSp(10.0)),
              Expanded(
                // height: MediaQuery.of(context).size.height * 0.70,
                child: PaginateFirestore(
                  itemBuilder: (
                    int index,
                    BuildContext context,
                    DocumentSnapshot<Object?> documentSnapshot,
                  ) {
                    final Map<String, dynamic>? data =
                        documentSnapshot.data() as Map<String, dynamic>?;

                    final OrderModel order = OrderModel.fromMap(data!);

                    return OrderItemsWidegt(order);
                  },
                  emptyDisplay: Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: sizerSp(15)),
                        CustomTextWidget(
                          text: 'You Are Now \nAvailbale To Deliver',
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.center,
                          fontSize: sizerSp(15),
                        ),
                        SizedBox(height: sizerSp(15)),
                        Icon(
                          Icons.access_time,
                          size: 200,
                          color: Colors.grey.shade600,
                        ),
                        SizedBox(height: sizerSp(15)),
                        CustomTextWidget(
                          text: 'Waiting for order...',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  query: RiderRepo.orderCollectionRef
                      .orderBy('timestamp', descending: true),
                  itemBuilderType: PaginateBuilderType.listView,
                  // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //   crossAxisCount: 1,
                  //   mainAxisExtent: MediaQuery.of(context).size.width * 0.85,
                  //   mainAxisSpacing: 10,
                  // ),
                  itemsPerPage: 10,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  // scrollDirection: Axis.horizontal,
                  // pageController: PageController(viewportFraction: 0.9),
                  isLive: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderItemsWidegt extends StatelessWidget {
  const OrderItemsWidegt(this.order, {Key? key}) : super(key: key);

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final List<String> foodNameList =
        order.items.map((CartModel cart) => cart.name).toList();
    final List<String?> fastFoodNameList =
        order.items.map((CartModel cart) => cart.fastFoodName).toList();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      margin: const EdgeInsets.symmetric(horizontal: 6.0),
      // alignment: Alignment.center,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 5.0,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sizerSp(5.0),
                vertical: sizerSp(5.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: double.infinity),
                  CustomTextWidget(
                    text: 'Delivery of ${foodNameList.join(', ')}',
                    textAlign: TextAlign.center,
                    fontSize: sizerSp(14),
                    fontWeight: FontWeight.w400,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: sizerSp(20)),
                  CustomTextWidget(
                    text: 'Customer',
                    fontSize: sizerSp(12),
                    fontWeight: FontWeight.w600,
                  ),
                  CustomTextWidget(
                    text: order.userDetails.fullName,
                    fontSize: sizerSp(12),
                    fontWeight: FontWeight.w200,
                  ),
                  SizedBox(height: sizerSp(10)),
                  CustomTextWidget(
                    text: 'Restaurants',
                    fontSize: sizerSp(12),
                    fontWeight: FontWeight.w600,
                  ),
                  CustomTextWidget(
                    text: fastFoodNameList.join(', '),
                    fontSize: sizerSp(12),
                    fontWeight: FontWeight.w200,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: sizerSp(5)),
                  CustomTextWidget(
                    text: 'Address',
                    fontSize: sizerSp(12),
                    fontWeight: FontWeight.w600,
                  ),
                  CustomTextWidget(
                    text: order.userDetails.address.toString(),
                    fontSize: sizerSp(12),
                    fontWeight: FontWeight.w200,
                  ),
                  SizedBox(height: sizerSp(5)),
                  CustomTextWidget(
                    text: 'Region',
                    fontSize: sizerSp(12),
                    fontWeight: FontWeight.w600,
                  ),
                  CustomTextWidget(
                    text: order.userDetails.region.toString(),
                    fontSize: sizerSp(12),
                    fontWeight: FontWeight.w200,
                  ),
                  SizedBox(height: sizerSp(10)),
                  CustomTextWidget(
                    text: 'Phone number',
                    fontSize: sizerSp(12),
                    fontWeight: FontWeight.w600,
                  ),
                  CustomTextWidget(
                    text: order.userDetails.phoneNumber.toString(),
                    fontSize: sizerSp(12),
                    fontWeight: FontWeight.w200,
                  ),
                  SizedBox(height: sizerSp(10)),
                  CustomTextWidget(
                    text: 'Delivery Charges',
                    fontSize: sizerSp(12),
                    fontWeight: FontWeight.w600,
                  ),
                  CustomTextWidget(
                    text: '${order.deliveryFee}',
                    fontSize: sizerSp(12),
                    fontWeight: FontWeight.w200,
                  ),
                  SizedBox(height: sizerSp(10)),
                  CustomTextWidget(
                    text: 'Order Status',
                    fontSize: sizerSp(12),
                    fontWeight: FontWeight.w600,
                  ),
                  CustomTextWidget(
                    text:
                        '${OrderStatusExtension.eumnToString(order.orderStatus!)}',
                    fontSize: sizerSp(12),
                    fontWeight: FontWeight.w200,
                  ),
                  SizedBox(height: sizerSp(10)),
                  CustomTextWidget(
                    text: 'Confirmation Status',
                    fontSize: sizerSp(12),
                    fontWeight: FontWeight.w600,
                  ),
                  CustomTextWidget(
                    text: (order.payStatus == null || order.payStatus == '')
                        ? 'pending'
                        : order.payStatus.toString(),
                    fontSize: sizerSp(12),
                    fontWeight: FontWeight.w200,
                  ),
                  SizedBox(height: sizerSp(10)),
                  CustomTextWidget(
                    text: 'Date Time',
                    fontSize: sizerSp(12),
                    fontWeight: FontWeight.w600,
                  ),
                  CustomTextWidget(
                    text: '${order.timestamp!.toDate().toString()}',
                    fontSize: sizerSp(12),
                    fontWeight: FontWeight.w200,
                  ),
                  SizedBox(height: sizerSp(10)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
