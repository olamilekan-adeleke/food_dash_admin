import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../../../cores/utils/extenions.dart';
import '../../../../cores/utils/locator.dart';
import '../../../../features/food/repo/rider_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../cores/utils/emums.dart';

part 'rider_event.dart';
part 'rider_state.dart';

class RiderBloc extends Bloc<RiderEvent, RiderState> {
  RiderBloc() : super(RiderInitial());

  static final RiderRepo riderRepo = locator<RiderRepo>();

  @override
  Stream<RiderState> mapEventToState(
    RiderEvent event,
  ) async* {
    if (event is ChangeOrderStatusEvent) {
      try {
        yield ChangeOrderStatusLoadingState();
        await riderRepo.chagneOrderStatus(
          event.id,
          OrderStatusExtension.eumnToString(event.orderStatus),
        );
        yield ChangeOrderStatusLoadedState();
      } on Exception catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield ChangeOrderStatusErrorState(e.toString());
      }
    } else if (event is AcceptOrderEvent) {
      try {
        yield AcceptOrderStatusLoadingState(event.orderId);
        await riderRepo.acceptOrderStatus(event.orderId);
        yield AcceptOrderStatusLoadedState();
      } on Exception catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield AcceptOrderStatusErrorState(e.toString());
      }
    } else if (event is DeclineOrderEvent) {
      try {
        yield DeclineOrderStatusLoadingState(event.orderId);
        await riderRepo.declineOrderStatus(event.orderId);
        yield DeclineOrderStatusLoadedState();
      } on Exception catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield DeclineOrderStatusErrorState(e.toString());
      }
    }
  }
}
