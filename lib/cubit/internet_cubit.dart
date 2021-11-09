import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_implementation/constants/enums.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  StreamSubscription? connectivityStreamSubscription;
  final Connectivity? connectivity;

  InternetCubit({@required this.connectivity}) : super(InternetLoading()) {
    connectivityStreamSubscription =
        connectivity!.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult == ConnectivityResult.wifi) {
        emitInternetConnected(ConnectionType.wifi);
      } else if (connectivityResult == ConnectivityResult.mobile) {
        emitInternetConnected(ConnectionType.mobile);
      } else if (connectivityResult == ConnectivityResult.none) {
        emitInternetDisconnected();
      }
    });
  }

  void emitInternetConnected(ConnectionType _connectionType) =>
      emit(InternetConnected(connectionType: _connectionType));
  void emitInternetDisconnected() => emit(InternetDisconnected());

  @override
  Future<void> close() {
    // TODO: implement close
    connectivityStreamSubscription!.cancel();
    return super.close();
  }
}
