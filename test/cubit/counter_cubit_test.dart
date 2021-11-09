import 'package:bloc_implementation/cubit/counter_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("CounterCubit", () {
    late CounterCubit counterCubit;

    setUp(() {
      counterCubit = CounterCubit();
    });

    tearDown(() {
      counterCubit.close();
    });

    test("Running test", () {
      expect(counterCubit.state, CounterState(counterValue: 0));
    });
  });
}
