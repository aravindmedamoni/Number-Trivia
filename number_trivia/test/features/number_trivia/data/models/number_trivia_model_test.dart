
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture.dart';

void main(){
  final tNumberTriviaModel = NumberTriviaModel(text:"Test Text",number:1);
  
  test("Should be a subclass of number trivia entity", () async{
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });
  
  group("from jSon", (){
    test("should return a valid model when the json model is an integer", () async{
      //arrange
      final Map<String,dynamic> jsonMap = json.decode(fixture('trivia.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, tNumberTriviaModel);
    });
    test("should return a valid model when the json model is an double", () async{
      //arrange
      final Map<String,dynamic> jsonMap = json.decode(fixture('trivia_double.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, tNumberTriviaModel);
    });
  });
  group("toJson", (){
    test("should return a jsonMap containing the proper data", () async{
      //act
      final result = tNumberTriviaModel.toJson();
      //assert
      final expectedJsonMap = {
        "text" : "Test Text",
        "number" : 1
      };
      expect(result, expectedJsonMap);

    });
  });
}