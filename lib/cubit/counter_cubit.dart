import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_implementation/constants/enums.dart';
import 'package:bloc_implementation/cubit/internet_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  StreamSubscription? internetStreamSub;
  final InternetCubit? internetCubit;

  CounterCubit({@required this.internetCubit}) : super(CounterState()) {
    internetStreamSub = internetCubit!.stream.listen((internetState) {
      if (internetState is InternetConnected &&
          internetState.connectionType == ConnectionType.wifi) {
        increment();
      } else if (internetState is InternetConnected &&
          internetState.connectionType == ConnectionType.mobile) {
        decrement();
      }
    });
  }

  void increment() => emit(CounterState(
      counterValue: state.counterValue += 1, wasIncremented: true));
  void decrement() => emit(CounterState(
      counterValue: state.counterValue -= 1, wasIncremented: false));

  @override
  Future<void> close() {
    // TODO: implement close
    internetStreamSub!.cancel();
    return super.close();
  }
}
