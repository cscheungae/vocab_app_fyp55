import 'package:equatable/equatable.dart';

class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationStateUnauthorized extends AuthenticationState {}
class AuthenticationStateAuthorized extends AuthenticationState {}
class AuthenticationStateLoading extends AuthenticationState {}
class AuthenticationStateInitializing extends AuthenticationState {}