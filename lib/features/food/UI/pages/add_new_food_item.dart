import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_dash_admin/cores/components/custom_button.dart';
import 'package:food_dash_admin/cores/components/custom_text_widget.dart';
import 'package:food_dash_admin/cores/components/custom_textfiled.dart';
import 'package:food_dash_admin/cores/constants/color.dart';
import 'package:food_dash_admin/cores/utils/sizer_utils.dart';
import 'package:food_dash_admin/cores/utils/snack_bar_service.dart';
import 'package:food_dash_admin/cores/utils/validator.dart';
import 'package:food_dash_admin/features/food/model/food_product_model.dart';
import 'package:food_dash_admin/features/food/model/merchant_model.dart';
import 'package:food_dash_admin/features/food/repo/rider_repo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddNewFoodItemScreen extends StatefulWidget {
  AddNewFoodItemScreen(this.merchant);

  final MerchantModel merchant;

  @override
  _AddNewFoodItemScreenState createState() => _AddNewFoodItemScreenState();
}

class _AddNewFoodItemScreenState extends State<AddNewFoodItemScreen> {
  TextEditingController descriptionTextEditingController =
      TextEditingController();
  TextEditingController passwordTextEditingController =
      TextEditingController();
  TextEditingController nameTextEditingController =
      TextEditingController();
  TextEditingController categoryTextEditingController =
      TextEditingController();
  TextEditingController priceTextEditingController =
      TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ValueNotifier<bool> loading = ValueNotifier<bool>(false);
  final ImagePicker _picker = ImagePicker();
  XFile? image;

  void upload() async {
    String? url;

    try {
      loading.value = true;

      if (image != null) {
        url = await RiderRepo().uploadImageToS3(File(image!.path));
      } else {
        CustomSnackBarService.showWarningSnackBar('Select Image!');
        loading.value = false;
        return;
      }

      final FoodProductModel foodProductModel = FoodProductModel(
        image: url!,
        name: nameTextEditingController.text.trim(),
        category: categoryTextEditingController.text.trim(),
        description: descriptionTextEditingController.text.trim(),
        fastFoodId: widget.merchant.id,
        id: Uuid().v1(),
        fastFoodname: widget.merchant.name,
        price: int.parse(priceTextEditingController.text.trim()),
      );

      await RiderRepo().uploadFood(foodProductModel);
      loading.value = false;
      CustomSnackBarService.showSuccessSnackBar('Done!');
      formKey.currentState!.reset();
      image = null;
      setState(() {});
    } catch (e) {
      loading.value = false;
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
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 50.0),
                CustomTextWidget(
                  text: 'Add A New \nFood Item',
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
                    child: Container(
                      color: Colors.grey.shade200,
                      height: 200,
                      width: 250,
                      child: image == null
                          ? Icon(
                              Icons.food_bank_rounded,
                              size: sizerSp(40),
                              color: Colors.grey.shade600,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(sizerSp(5)),
                              child: Image.file(
                                File(image!.path),
                                fit: BoxFit.fill,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                CustomTextField(
                  textEditingController: nameTextEditingController,
                  hintText: 'Enter name',
                  labelText: 'Name',
                  validator: (String? text) =>
                      formFieldValidator(text, 'Name', 2),
                ),
                const SizedBox(height: 20.0),
                CustomTextField(
                  textEditingController: descriptionTextEditingController,
                  hintText: 'Enter description',
                  labelText: 'description',
                  validator: (String? text) =>
                      formFieldValidator(text, 'description', 3),
                ),
                const SizedBox(height: 20.0),
                CustomTextField(
                  textEditingController: priceTextEditingController,
                  hintText: 'Enter price',
                  labelText: 'price',
                  textInputType: TextInputType.number,
                  validator: (String? text) =>
                      formFieldValidator(text, 'price', 1),
                ),
                const SizedBox(height: 20.0),
                CustomTextField(
                  textEditingController: categoryTextEditingController,
                  hintText: 'Enter category',
                  labelText: 'category',
                  validator: (String? text) =>
                      formFieldValidator(text, 'category', 1),
                ),
                const SizedBox(height: 20.0),
                ValueListenableBuilder(
                    valueListenable: loading,
                    builder: (_, bool value, ___) {
                      if (value) {
                        return const CustomButton.loading();
                      }

                      return CustomButton(
                        text: 'Proceed',
                        onTap: () {
                          if (formKey.currentState!.validate()) {
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
