import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_dash_admin/cores/components/custom_button.dart';
import 'package:food_dash_admin/cores/components/custom_text_widget.dart';
import 'package:food_dash_admin/cores/components/custom_textfiled.dart';
import 'package:food_dash_admin/cores/constants/color.dart';
import 'package:food_dash_admin/cores/utils/sizer_utils.dart';
import 'package:food_dash_admin/cores/utils/snack_bar_service.dart';
import 'package:food_dash_admin/cores/utils/validator.dart';
import 'package:food_dash_admin/features/food/model/merchant_model.dart';
import 'package:food_dash_admin/features/food/repo/rider_repo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddNewRestaurantScreen extends StatefulWidget {
  AddNewRestaurantScreen();

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController addressTextEditingController = TextEditingController();
  TextEditingController numberTextEditingController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ValueNotifier<bool> loading = ValueNotifier<bool>(false);

  @override
  _AddNewRestaurantScreenState createState() => _AddNewRestaurantScreenState();
}

class _AddNewRestaurantScreenState extends State<AddNewRestaurantScreen> {
  final ImagePicker _picker = ImagePicker();

  XFile? image;

  void upload() async {
    String? url;

    try {
      widget.loading.value = true;

      if (image != null) {
        url = await RiderRepo().uploadImageToS3(File(image!.path));
      } else {
        CustomSnackBarService.showWarningSnackBar('Select Image!');
        widget.loading.value = false;
        return;
      }

      final MerchantModel merchant = MerchantModel(
        categories: ['fastfood', 'restaurants'],
        id: Uuid().v1(),
        image: url,
        name: widget.nameTextEditingController.text.trim(),
        numberOfRating: 0,
        rating: 0.0,
        address: widget.addressTextEditingController.text.trim(),
        phoneNumber: widget.numberTextEditingController.text.trim(),
      );

      await RiderRepo().uploadFastFood(merchant);
      widget.loading.value = false;
      CustomSnackBarService.showSuccessSnackBar('Done!');
      widget.formKey.currentState!.reset();
      image = null;
      setState(() {});
    } catch (e) {
      widget.loading.value = false;
      CustomSnackBarService.showErrorSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 50.0),
                CustomTextWidget(
                  text: 'Add A New \nRestaurant',
                  fontSize: sizerSp(28),
                  textColor: kcPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 50.0),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      image =
                          await _picker.pickImage(source: ImageSource.gallery);
                      setState(() {});
                    },
                    child: CircleAvatar(
                      backgroundColor: kcPrimaryColor,
                      radius: sizerSp(35),
                      child: image == null
                          ? Icon(
                              Icons.person,
                              size: sizerSp(40),
                              color: Colors.grey.shade100,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(sizerSp(35)),
                              child: Image.file(File(image!.path)),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                CustomTextField(
                  textEditingController: widget.nameTextEditingController,
                  hintText: 'Enter name',
                  labelText: 'Name',
                  validator: (String? text) =>
                      formFieldValidator(text, 'Name', 2),
                ),
                const SizedBox(height: 20.0),
                CustomTextField(
                  textEditingController: widget.emailTextEditingController,
                  hintText: 'Enter address',
                  labelText: 'address',
                  validator: (String? text) =>
                      formFieldValidator(text, 'address', 3),
                ),
                const SizedBox(height: 20.0),
                CustomTextField(
                  textEditingController: widget.numberTextEditingController,
                  hintText: 'Enter Phone Number',
                  labelText: 'Phone Number',
                  textInputType: TextInputType.number,
                  validator: (String? text) =>
                      formFieldValidator(text, 'Phone Number', 10),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomTextWidget(
                      text: 'By procceding, you agree to our ',
                      fontSize: sizerSp(11),
                      fontWeight: FontWeight.w600,
                    ),
                    CustomTextWidget(
                      text: 'Terms And Conditions',
                      fontSize: sizerSp(11),
                      fontWeight: FontWeight.w600,
                      textColor: Colors.red,
                    ),
                  ],
                ),
                const SizedBox(height: 50.0),
                ValueListenableBuilder(
                    valueListenable: widget.loading,
                    builder: (_, bool value, ___) {
                      if (value) {
                        return const CustomButton.loading();
                      }

                      return CustomButton(
                        text: 'Proceed',
                        onTap: () {
                          if (widget.formKey.currentState!.validate()) {
                            upload();
                          }
                        },
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
