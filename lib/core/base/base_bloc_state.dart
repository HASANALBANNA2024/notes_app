import 'package:equatable/equatable.dart';

abstract class BaseEvent extends Equatable {
  const BaseEvent();
  @override
  List<Object?> get props => [];
}

class FetchDataEvent extends BaseEvent {}

abstract class BaseState extends Equatable {
  const BaseState();
  @override
  List<Object?> get props => [];
}

class BaseInitialState extends BaseState {}

class BaseLoadingState extends BaseState {}

class BaseSuccessState<T> extends BaseState {
  final T data;
  const BaseSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class BaseFailureState extends BaseState {
  final String errorMessage;
  const BaseFailureState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
