import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_dash_admin/cores/components/custom_button.dart';
import 'package:food_dash_admin/cores/components/custom_text_widget.dart';
import 'package:food_dash_admin/cores/components/custom_textfiled.dart';
import 'package:food_dash_admin/cores/components/image_widget.dart';
import 'package:food_dash_admin/cores/utils/emums.dart';
import 'package:food_dash_admin/cores/utils/sizer_utils.dart';
import 'package:food_dash_admin/cores/utils/snack_bar_service.dart';
import 'package:food_dash_admin/cores/utils/validator.dart';
import 'package:food_dash_admin/features/food/UI/widgets/header_widget.dart';
import 'package:food_dash_admin/features/food/model/food_product_model.dart';
import 'package:food_dash_admin/features/food/repo/rider_repo.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class FastFoodItem extends StatelessWidget {
  const FastFoodItem(this.id, {Key? key}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: sizerSp(20.0)),
          const HeaderWidget(iconData: null, title: 'Fast Food Items'),
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

                final FoodProductModel foodItem =
                    FoodProductModel.fromMap(data!, documentSnapshot.id);

                return Container(
                  margin: EdgeInsets.symmetric(vertical: sizerSp(5.0)),
                  padding: EdgeInsets.symmetric(vertical: sizerSp(5.0)),
                  child: ExpansionTile(
                    leading: SizedBox(
                      height: 80,
                      width: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: CustomImageWidget(
                          imageTypes: ImageTypes.network,
                          imageUrl: foodItem.image,
                        ),
                      ),
                    ),
                    title: CustomTextWidget(
                      text: foodItem.name,
                      fontWeight: FontWeight.w400,
                      fontSize: sizerSp(15),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CustomTextWidget(
                          text: '\u20A6 ${foodItem.price.toString()}',
                          fontWeight: FontWeight.w200,
                          fontSize: sizerSp(12),
                        ),
                        CustomTextWidget(
                          text: foodItem.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w200,
                          fontSize: sizerSp(12),
                        ),
                      ],
                    ),
                    children: [EditWidget(foodItem)],
                  ),
                );
              },
              emptyDisplay: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.shopping_bag,
                      size: 200,
                      color: Colors.grey.shade600,
                    ),
                    CustomTextWidget(
                      text: 'No Food item Found',
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                      fontSize: sizerSp(15),
                    ),
                    SizedBox(height: sizerSp(55)),
                  ],
                ),
              ),
              query: RiderRepo.foodItemCollectionRef
                  .where('fast_food_id', isEqualTo: id)
                  .orderBy('name'),
              itemBuilderType: PaginateBuilderType.listView,
              itemsPerPage: 10,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              isLive: true,
            ),
          ),
        ],
      ),
    );
  }
}

class EditWidget extends StatelessWidget {
  EditWidget(this.foodProduct, {Key? key}) : super(key: key);

  final FoodProductModel foodProduct;
  static final ValueNotifier<bool> loading = ValueNotifier<bool>(false);
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController priceTextEditingController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController descriptionTextEditingController =
      TextEditingController();

  bool firstTime = true;

  Future<void> delete() async {
    try {
      loading.value = true;

      await RiderRepo().deleteFood(foodProduct.id);
      loading.value = false;
      CustomSnackBarService.showSuccessSnackBar('Deleted!');
    } catch (e) {
      loading.value = false;
      CustomSnackBarService.showErrorSnackBar(e.toString());
    }
  }

  Future<void> update() async {
    try {
      loading.value = true;

      final FoodProductModel _foodProductModel = FoodProductModel(
        image: foodProduct.image,
        name: nameTextEditingController.text.trim(),
        category: foodProduct.category,
        description: descriptionTextEditingController.text.trim(),
        fastFoodId: foodProduct.fastFoodId,
        id: foodProduct.id,
        fastFoodname: foodProduct.fastFoodname,
        price: int.parse(priceTextEditingController.text.trim()),
      );

      await RiderRepo().updateFood(_foodProductModel);
      loading.value = false;
      CustomSnackBarService.showSuccessSnackBar('Updated!');
    } catch (e) {
      loading.value = false;
      CustomSnackBarService.showErrorSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (firstTime) {
      nameTextEditingController.text = foodProduct.name;
      priceTextEditingController.text = foodProduct.price.toString();
      descriptionTextEditingController.text = foodProduct.description;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20.0),
            CustomTextField(
              textEditingController: nameTextEditingController,
              hintText: foodProduct.name,
              labelText: 'Name',
              validator: (String? text) => formFieldValidator(text, 'Name', 2),
            ),
            const SizedBox(height: 20.0),
            CustomTextField(
              textEditingController: priceTextEditingController,
              hintText: foodProduct.price.toString(),
              labelText: 'Price',
              validator: (String? text) => formFieldValidator(text, 'Price', 1),
            ),
            const SizedBox(height: 20.0),
            CustomTextField(
              textEditingController: descriptionTextEditingController,
              hintText: foodProduct.description,
              labelText: 'description',
              validator: (String? text) =>
                  formFieldValidator(text, 'description', 2),
            ),
            const SizedBox(height: 40.0),
            ValueListenableBuilder(
              valueListenable: loading,
              builder: (_, bool value, ___) {
                if (value) {
                  return const CustomButton.loading();
                }

                return Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        color: Colors.red,
                        text: 'Delete',
                        onTap: () => delete(),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: CustomButton(
                        color: Colors.green,
                        text: 'Update',
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            update();
                          }
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
