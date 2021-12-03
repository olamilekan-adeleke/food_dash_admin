import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_dash_admin/cores/components/custom_button.dart';
import 'package:food_dash_admin/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_admin/cores/components/custom_text_widget.dart';
import 'package:food_dash_admin/cores/components/custom_textfiled.dart';
import 'package:food_dash_admin/cores/constants/color.dart';
import 'package:food_dash_admin/cores/utils/currency_formater.dart';
import 'package:food_dash_admin/cores/utils/locator.dart';
import 'package:food_dash_admin/cores/utils/sizer_utils.dart';
import 'package:food_dash_admin/cores/utils/snack_bar_service.dart';
import 'package:food_dash_admin/cores/utils/validator.dart';
import 'package:food_dash_admin/features/food/UI/widgets/header_widget.dart';
import 'package:food_dash_admin/features/food/repo/rider_repo.dart';

class EditRiderFeeScreen extends StatelessWidget {
  const EditRiderFeeScreen({Key? key}) : super(key: key);

  static final RiderRepo riderRepo = locator<RiderRepo>();
  static TextEditingController feeTextEditingController =
      TextEditingController();
  static final ValueNotifier<bool> loading = ValueNotifier<bool>(false);

  void send(BuildContext context) async {
    if (feeTextEditingController.text.isEmpty) return;

    try {
      loading.value = true;

      int fee = int.parse(feeTextEditingController.text.trim());

      await RiderRepo().changeRiderFee(fee);
      loading.value = false;
      feeTextEditingController.clear();
      FocusScope.of(context).unfocus();

      CustomSnackBarService.showSuccessSnackBar('Updated!');
    } catch (e) {
      loading.value = false;
      CustomSnackBarService.showErrorSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizerSp(10.0)),
        child: Column(
          children: [
            SizedBox(height: sizerSp(20.0)),
            const HeaderWidget(
                iconData: null, title: 'Change Rider Commission'),
            SizedBox(height: sizerSp(30.0)),
            const SizedBox(height: 20.0),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: riderRepo.riderFeeStream(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CustomTextWidget(
                      text: '\u20A6 Loading...',
                      fontWeight: FontWeight.bold,
                      fontSize: sizerSp(30),
                    );
                  } else if (snapshot.hasError) {
                    return CustomTextWidget(
                      text: '\u20A6 Error!',
                      fontWeight: FontWeight.bold,
                      fontSize: sizerSp(30),
                    );
                  }

                  final Map<String, dynamic>? data = snapshot.data?.data();
                  final int fee = data != null ? data['percentage'] : 0;

                  return CustomTextWidget(
                    text: '$fee %',
                    fontWeight: FontWeight.bold,
                    fontSize: sizerSp(30),
                  );
                }),
            const SizedBox(height: 10.0),
            CustomTextWidget(
              text: 'Above is the current Rider Delivery Commission',
              fontWeight: FontWeight.w200,
              fontSize: sizerSp(14),
            ),
            const SizedBox(height: 40.0),
            CustomTextField(
              textEditingController: feeTextEditingController,
              textInputType: TextInputType.number,
              hintText: 'Change Rider Commission',
              labelText: 'Rider Commission',
              validator: (String? text) =>
                  formFieldValidator(text, 'Rider Commission', 1),
            ),
            const Spacer(),
            ValueListenableBuilder(
              valueListenable: loading,
              builder: (_, bool value, ___) {
                if (value) {
                  return const CustomButton.loading();
                }

                return CustomButton(
                  color: kcPrimaryColor,
                  text: 'Send',
                  onTap: () => send(context),
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
