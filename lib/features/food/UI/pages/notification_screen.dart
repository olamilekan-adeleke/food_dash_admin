import 'package:flutter/material.dart';
import '../../../../cores/components/custom_text_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:  Center(child: CustomTextWidget(text: 'Notification Screem')),
    );
  }
}