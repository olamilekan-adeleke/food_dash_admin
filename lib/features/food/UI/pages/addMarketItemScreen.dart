import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_dash_admin/cores/components/custom_button.dart';
import 'package:food_dash_admin/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_admin/cores/components/custom_text_widget.dart';
import 'package:food_dash_admin/cores/components/custom_textfiled.dart';
import 'package:food_dash_admin/cores/constants/color.dart';
import 'package:food_dash_admin/cores/utils/sizer_utils.dart';
import 'package:food_dash_admin/cores/utils/snack_bar_service.dart';
import 'package:food_dash_admin/cores/utils/validator.dart';
import 'package:food_dash_admin/features/food/UI/widgets/header_widget.dart';
import 'package:food_dash_admin/features/food/model/market_item_model.dart';
import 'package:food_dash_admin/features/food/repo/rider_repo.dart';
import 'package:images_picker/images_picker.dart';
import 'package:uuid/uuid.dart';

class AddMarketItemScreen extends StatelessWidget {
  const AddMarketItemScreen({Key? key}) : super(key: key);

  static TextEditingController nameTextEditingController =
      TextEditingController();
  static TextEditingController descriptionTextEditingController =
      TextEditingController();
  static TextEditingController categoryTextEditingController =
      TextEditingController();
  static TextEditingController priceTextEditingController =
      TextEditingController();
  static ValueNotifier<bool> loading = ValueNotifier<bool>(false);
  static ValueNotifier<List<Media>> images =
      ValueNotifier<List<Media>>(<Media>[]);

  void upload() async {
    String? url;

    try {
      final List<String> urls = <String>[];
      loading.value = true;

      if (images.value.isNotEmpty) {
        for (final Media item in images.value) {
          url = await RiderRepo().uploadImageToS3(File(item.path));
          urls.add(url!);
        }
      } else {
        CustomSnackBarService.showWarningSnackBar('Select Image!');
        loading.value = false;
        return;
      }

      final MarketItemModel marketItem = MarketItemModel(
        images: urls,
        name: nameTextEditingController.text.trim(),
        category: 'market',
        description: descriptionTextEditingController.text.trim(),
        id: Uuid().v1(),
        price: int.parse(priceTextEditingController.text.trim()),
      );

      await RiderRepo().uploadMarket(marketItem);
      loading.value = false;
      CustomSnackBarService.showSuccessSnackBar('Done!');

      images.value = [];
      nameTextEditingController.clear();
      descriptionTextEditingController.clear();
      priceTextEditingController.clear();
    } catch (e) {
      loading.value = false;
      CustomSnackBarService.showErrorSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const HeaderWidget(
              iconData: null,
              title: 'Add Items',
            ),
            SizedBox(height: sizerSp(10.0)),
            Center(
              child: GestureDetector(
                onTap: () async {
                  List<Media>? res = await ImagesPicker.pick(
                    pickType: PickType.image,
                    count: 10,
                  );

                  if (res == null) return;

                  images.value = res;
                },
                child: ValueListenableBuilder(
                  valueListenable: images,
                  builder: (_, List<Media> files, __) {
                    if (files.isEmpty) {
                      return Container(
                        color: Colors.grey.shade200,
                        height: 200,
                        width: 250,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(sizerSp(5)),
                          child: Icon(Icons.image_sharp),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        SizedBox(
                          height: sizerSp(150),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: files.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_, int index) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: sizerSp(5.0),
                                ),
                                color: Colors.grey.shade200,
                                height: 150,
                                width: 150,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(sizerSp(5)),
                                  child: Image.file(
                                    File(files[index].path),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            List<Media>? res = await ImagesPicker.pick(
                              pickType: PickType.image,
                              count: 10,
                            );

                            if (res == null) return;

                            images.value = res;
                          },
                          child: Container(
                            color: kcPrimaryColor,
                            margin: EdgeInsets.symmetric(
                              horizontal: sizerSp(10),
                              vertical: sizerSp(5.0),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: sizerSp(10),
                              vertical: sizerSp(5.0),
                            ),
                            child: CustomTextWidget(text: 'Re-Select'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            CustomTextField(
              textEditingController: nameTextEditingController,
              hintText: 'Enter name',
              labelText: 'Name',
              validator: (String? text) => formFieldValidator(text, 'Name', 2),
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
              validator: (String? text) => formFieldValidator(text, 'price', 1),
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
                      upload();
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
