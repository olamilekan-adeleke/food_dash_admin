import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_dash_admin/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_admin/cores/components/custom_text_widget.dart';
import 'package:food_dash_admin/cores/utils/currency_formater.dart';
import 'package:food_dash_admin/cores/utils/locator.dart';
import 'package:food_dash_admin/cores/utils/sizer_utils.dart';
import 'package:food_dash_admin/features/food/UI/widgets/header_widget.dart';
import 'package:food_dash_admin/features/food/repo/rider_repo.dart';

class MetricePage extends StatelessWidget {
  const MetricePage({Key? key}) : super(key: key);

  static DateTime selectedDate = DateTime.now();
  static TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  static ValueNotifier<bool> loading = ValueNotifier<bool>(false);

  Future _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      loading.value = true;
      selectedDate = picked;
      await Future.delayed(Duration(milliseconds: 500));
      loading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            HeaderWidget(
              iconData: null,
              title: 'Metrics',
              trailing: GestureDetector(
                onTap: () => _selectDate(context),
                child: Icon(Icons.date_range_outlined),
              ),
            ),
            SizedBox(height: sizerSp(10.0)),
            ValueListenableBuilder(
              valueListenable: loading,
              builder: (_, bool value, __) {
                if (value) {
                  return CircularProgressIndicator();
                }

                return MetricStreamWidget(selectedDate);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MetricStreamWidget extends StatelessWidget {
  const MetricStreamWidget(this.dateTime, {Key? key}) : super(key: key);

  static final RiderRepo riderRepo = locator<RiderRepo>();
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: riderRepo.metricStream(dateTime),
      builder: (
        BuildContext context,
        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CustomTextWidget(
              text: 'Loading...',
              fontWeight: FontWeight.bold,
              fontSize: sizerSp(30),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: CustomTextWidget(
              text: 'Error! ${snapshot.error}',
              fontWeight: FontWeight.bold,
              fontSize: sizerSp(30),
            ),
          );
        }

        final Map<String, dynamic> data = snapshot.data?.data() ?? {};

        log(data.toString());

        final int totalAmount =
            data['total_amount'] != null ? data['total_amount'] : 0;
        final int totalOrder =
            data['total_order'] != null ? data['total_order'] : 0;
        final int totalCompltedOrder = data['total_completed_order'] != null
            ? data['total_completed_order']
            : 0;

        return Column(
          children: [
            CustomTextWidget(
              text: totalOrder.toString(),
              fontWeight: FontWeight.bold,
              fontSize: sizerSp(30),
            ),
            CustomTextWidget(
              text: 'Total number of order for today',
              fontWeight: FontWeight.w300,
              fontSize: sizerSp(15),
            ),
            SizedBox(height: sizerSp(20.0)),
            CustomTextWidget(
              text: totalCompltedOrder.toString(),
              fontWeight: FontWeight.bold,
              fontSize: sizerSp(30),
            ),
            CustomTextWidget(
              text: 'Total number of completed order for today',
              fontWeight: FontWeight.w300,
              fontSize: sizerSp(15),
            ),
            SizedBox(height: sizerSp(20.0)),
            CustomTextWidget(
              text: '\u20A6 ${currencyFormatter(totalAmount)}',
              fontWeight: FontWeight.bold,
              fontSize: sizerSp(30),
            ),
            CustomTextWidget(
              text: 'Total amount made today',
              fontWeight: FontWeight.w300,
              fontSize: sizerSp(15),
            ),
            SizedBox(height: sizerSp(20.0)),
          ],
        );
      },
    );
  }
}
