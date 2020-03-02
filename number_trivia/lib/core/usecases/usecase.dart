
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:number_trivia/core/error/failures.dart';

abstract class Usecase<Type,Params>{
  Future<Either<Failure,Type>> call(Params params);
}

class NoParams extends Equatable{}
class Params extends Equatable{
  Params({@required this.number}):super([number]);
  final int number;
}