import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:food_dash_admin/cores/utils/snack_bar_service.dart';
import 'package:food_dash_admin/features/food/model/food_product_model.dart';
import 'package:food_dash_admin/features/food/model/market_item_model.dart';
import 'package:food_dash_admin/features/food/model/merchant_model.dart';

import '../../../../cores/utils/extenions.dart';
import '../../../../features/auth/model/user_details_model.dart';
import '../../../../features/auth/repo/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../cores/utils/emums.dart';
import 'package:get_it/get_it.dart';

import 'local_database_repo.dart';
import 'package:http/http.dart' as http;

class RiderRepo {
  static AuthenticationRepo authenticationRepo =
      GetIt.instance<AuthenticationRepo>();

  static final LocaldatabaseRepo localdatabaseRepo =
      GetIt.instance<LocaldatabaseRepo>();
  final CollectionReference<Map<String, dynamic>> riderCollectionRef =
      FirebaseFirestore.instance.collection('rider');

  static final CollectionReference<Map<String, dynamic>> orderCollectionRef =
      FirebaseFirestore.instance.collection('orders');

  static final CollectionReference<Map<String, dynamic>> marketCollectionRef =
      FirebaseFirestore.instance.collection('market');

  static final CollectionReference<Map<String, dynamic>>
      constantsCollectionRef =
      FirebaseFirestore.instance.collection('constants');

  static final CollectionReference<Map<String, dynamic>>
      restaurantsCollectionRef =
      FirebaseFirestore.instance.collection('restaurants');

  static final CollectionReference<Map<String, dynamic>> foodItemCollectionRef =
      FirebaseFirestore.instance.collection('food_items');

  Stream<DocumentSnapshot<Map<String, dynamic>>> userWalletStream() async* {
    final String? userUid = authenticationRepo.getUserUid();

    yield* riderCollectionRef.doc(userUid).snapshots();
  }

  Future<void> acceptOrderStatus(String id) async {
    try {
      final RiderDetailsModel? riderDetails =
          await localdatabaseRepo.getUserDataFromLocalDB();
      await orderCollectionRef.doc(id).update(
        {
          'order_status':
              OrderStatusExtension.eumnToString(OrderStatusEunm.accepted),
          'rider_details': riderDetails!.toMap(),
          'rider_id': riderDetails.uid,
        },
      );
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> declineOrderStatus(String id) async {
    try {
      final RiderDetailsModel? riderDetails =
          await localdatabaseRepo.getUserDataFromLocalDB();
      await orderCollectionRef.doc(id).update(
        {
          'decline_list': FieldValue.arrayUnion([riderDetails?.uid]),
        },
      );
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> chagneOrderStatus(String id, String status) async {
    try {
      await orderCollectionRef.doc(id).update({'order_status': status});
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> orderSteam(String id) async* {
    yield* orderCollectionRef.doc(id).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> deliveryFeeStream() async* {
    yield* constantsCollectionRef.doc('delivery_fee_per_kilometer').snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> riderFeeStream() async* {
    yield* constantsCollectionRef.doc('rider_fee').snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> metricStream(
      DateTime dateTime) async* {
    log('l${dateTime.year.toString()}l');
    log('l${dateTime.month.toString()}l');
    log('l${dateTime.day.toString()}l');

    // yield* constantsCollectionRef
    //     .doc('metrics')
    //     .collection(dateTime.year.toString())
    //     .doc(dateTime.month.toString())
    //     .collection('days')
    //     .doc(dateTime.day.toString())
    //     .snapshots();

    yield* constantsCollectionRef
        .doc('metrics')
        .collection('2021')
        .doc(dateTime.month.toString())
        .collection('days')
        .doc(dateTime.day.toString())
        .snapshots();
  }

  Future<String?> uploadImageToS3(File file) async {
    String? imageUrl;

    try {
      Reference ref = FirebaseStorage.instance
          .ref('uploads/images/${DateTime.now().millisecond}');

      UploadTask uploadTask = ref.putFile(file);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print(
            'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
        // loadingPercentage.value =
        //     (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        // print('loadingPercentage.value: ${loadingPercentage.value}');
      });

      await uploadTask;

      imageUrl = await ref.getDownloadURL();
      // loadingPercentage.value = 0;
      // imageCount.value++;

    } on FirebaseException catch (e) {
      print(e);

      // e.g, e.code == 'canceled'
    }

    return imageUrl;
  }

  Future<void> uploadFastFood(MerchantModel merchant) async {
    await restaurantsCollectionRef.doc(merchant.id).set(merchant.toMap());
  }

  Future<void> uploadFood(FoodProductModel foodProduct) async {
    await foodItemCollectionRef.doc(foodProduct.id).set(foodProduct.toMap());
  }

  Future<void> uploadMarket(MarketItemModel marketItem) async {
    await marketCollectionRef.doc(marketItem.id).set(marketItem.toMap());
  }

  Future<void> updateFood(FoodProductModel foodProduct) async {
    await foodItemCollectionRef.doc(foodProduct.id).update(foodProduct.toMap());
  }

  Future<void> deleteFood(String id) async {
    await foodItemCollectionRef.doc(id).delete();
  }

  Future<void> deleteFastFood(String id) async {
    await restaurantsCollectionRef.doc(id).delete();
  }

  Future<void> sendNotification(String heading, String body) async {
    final Map data = {"heading": heading, "body": body};

    try {
      http.Response response = await http.post(
        Uri.parse(
            'https://us-central1-food-dash-4f8d6.cloudfunctions.net/sendOutNotificationToEveryOne'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      final Map _data = json.decode(response.body);

      if (response.statusCode == 200) {
        CustomSnackBarService.showSuccessSnackBar(_data['msg']);
      } else {
        throw _data['msg'];
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> changeDeliveryFee(int fee) async {
    await constantsCollectionRef
        .doc('delivery_fee_per_kilometer')
        .set({'fee': fee});
  }

  Future<void> changeRiderFee(int fee) async {
    await constantsCollectionRef.doc('rider_fee').update({'percentage': fee});
  }
}
