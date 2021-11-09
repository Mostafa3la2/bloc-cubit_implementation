part of 'counter_cubit.dart';

@immutable
class CounterState extends Equatable {
  int counterValue;
  bool wasIncremented;
  CounterState(
      {@required this.counterValue = 0, @required this.wasIncremented = false});

  @override
  // TODO: implement props
  List<Object?> get props => [this.counterValue, this.wasIncremented];
}
