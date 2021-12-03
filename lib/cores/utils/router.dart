import 'package:food_dash_admin/features/food/UI/pages/addMarketItemScreen.dart';
import 'package:food_dash_admin/features/food/UI/pages/add_new_food_item.dart';
import 'package:food_dash_admin/features/food/UI/pages/add_new_resaturant.dart';
import 'package:food_dash_admin/features/food/UI/pages/all_orders_page.dart';
import 'package:food_dash_admin/features/food/UI/pages/edit_delivery_fee_screen.dart';
import 'package:food_dash_admin/features/food/UI/pages/edit_rider_fee_screen.dart';
import 'package:food_dash_admin/features/food/UI/pages/fast_foods_screen.dart';
import 'package:food_dash_admin/features/food/UI/pages/metrice_page.dart';
import 'package:food_dash_admin/features/food/UI/pages/selected_fast_food.dart';
import 'package:food_dash_admin/features/food/UI/pages/send_notification.dart';
import 'package:food_dash_admin/features/food/model/merchant_model.dart';

import '../../../../features/food/UI/pages/current_orders_screen.dart';
import '../../../../features/food/UI/pages/eidt_profile_screen.dart';
import '../../../../features/food/UI/pages/oder_history_screen.dart';
import '../../../../features/food/UI/pages/order_screen.dart';
import '../../../../features/food/UI/pages/profile_screen.dart';
import '../../../../features/food/UI/pages/selected_order_screen.dart';
import '../../../../features/food/UI/pages/verify_rider_screen.dart';
import '../../../../features/food/UI/pages/wallet_page.dart';
import '../../../../features/food/UI/pages/withdrawal_history_screen.dart';
import '../../../../features/food/model/order_model.dart';
import 'package:flutter/material.dart';

import '../../../../cores/components/error_navigation_wiget.dart';
import '../../../../cores/utils/route_name.dart';
import '../../../../features/auth/UI/pages/forgot_password_page.dart';
import '../../../../features/auth/UI/pages/login.dart';
import '../../../../features/auth/UI/pages/sig_up_page.dart';
import '../../../../features/auth/UI/pages/wrapper_page.dart';

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteName.inital:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const WrapperPage());

    case RouteName.login:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const LoginPage());

    case RouteName.signup:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const SignUpPage());

    case RouteName.forgotPassword:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const ForgotPasswordPage());

    case RouteName.profileScreen:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const ProfileScreen());

    case RouteName.editAddress:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const EditprofileScreen());

    case RouteName.oderHistoryScreen:
      if (settings.arguments is String) {
        final String id = settings.arguments as String;

        return MaterialPageRoute<Widget>(
            builder: (BuildContext context) => OrderHistoryScreen(id));
      }

      break;

    case RouteName.withdrawalHistoryScreen:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const WithdrawalHistoryScreen());

    case RouteName.addNewFoodScreen:
      if (settings.arguments is MerchantModel) {
        final MerchantModel merchant = settings.arguments as MerchantModel;
        return MaterialPageRoute<Widget>(
            builder: (BuildContext context) => AddNewFoodItemScreen(merchant));
      }
      break;

    case RouteName.addfastFoodScreen:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => AddNewRestaurantScreen());

    case RouteName.sendNotificationPageScreen:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => SendNotificationScreen());

    case RouteName.editDeliveryScreen:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => EditDeliveryScreen());

    case RouteName.editRiderFee:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const EditRiderFeeScreen());

    case RouteName.metric:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const MetricePage());

    case RouteName.wallet:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const WalletScreen());

    case RouteName.oderPageScreen:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const OrderScreen());

    case RouteName.addMarketItemScreen:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const AddMarketItemScreen());

    case RouteName.allOrderScreen:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const AllOrderScreen());

    case RouteName.selectedOderScreen:
      if (settings.arguments is OrderModel) {
        final OrderModel order = settings.arguments as OrderModel;

        return MaterialPageRoute<Widget>(
            builder: (BuildContext context) => SelectedOrderScreen(order));
      }
      break;

    case RouteName.selectedfastFoodScreen:
      if (settings.arguments is MerchantModel) {
        final MerchantModel merchant = settings.arguments as MerchantModel;

        return MaterialPageRoute<Widget>(
            builder: (BuildContext context) =>
                SelectedFastFoodScreen(merchant));
      }
      break;

    case RouteName.verifyRiderScreen:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const VerifyRiderScreen());

    case RouteName.fastFoodScreen:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const FastFoodScreen());

    case RouteName.currentOrders:
      if (settings.arguments is String) {
        final String id = settings.arguments as String;

        return MaterialPageRoute<Widget>(
            builder: (BuildContext context) => CurrentOrders(id));
      }
      break;

    default:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const ErrornavigationWidget());
  }
}
