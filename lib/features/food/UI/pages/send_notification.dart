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
import 'package:food_dash_admin/features/food/repo/rider_repo.dart';

class SendNotificationScreen extends StatelessWidget {
  const SendNotificationScreen({Key? key}) : super(key: key);
  static final ValueNotifier<bool> loading = ValueNotifier<bool>(false);
  static TextEditingController headingTextEditingController =
      TextEditingController();
  static TextEditingController bodyTextEditingController =
      TextEditingController();
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void send() async {
    try {
      loading.value = true;

      await RiderRepo().sendNotification(
        headingTextEditingController.text.trim(),
        bodyTextEditingController.text.trim(),
      );
      loading.value = false;
      headingTextEditingController.text = '';
      bodyTextEditingController.text = '';
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
          children: <Widget>[
            SizedBox(height: sizerSp(20.0)),
            const HeaderWidget(iconData: null, title: 'Send Notification'),
            SizedBox(height: sizerSp(30.0)),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  CustomTextWidget(
                    text: 'Send notification to all your users',
                    fontWeight: FontWeight.bold,
                    fontSize: sizerSp(15),
                  ),
                  CustomTextWidget(
                    text:
                        'the notification sent will be received by all user almost instantly or when they come online',
                    fontWeight: FontWeight.w200,
                    fontSize: sizerSp(14),
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextField(
                    textEditingController: headingTextEditingController,
                    hintText: 'heading',
                    labelText: 'heading',
                    validator: (String? text) =>
                        formFieldValidator(text, 'heading', 3),
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextField(
                    textEditingController: bodyTextEditingController,
                    hintText: 'body',
                    labelText: 'body',
                    validator: (String? text) =>
                        formFieldValidator(text, 'body', 6),
                    maxLine: null,
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
            Spacer(),
            ValueListenableBuilder(
              valueListenable: loading,
              builder: (_, bool value, ___) {
                if (value) {
                  return const CustomButton.loading();
                }

                return CustomButton(
                  color: kcPrimaryColor,
                  text: 'Send',
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      send();
                    }
                  },
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
