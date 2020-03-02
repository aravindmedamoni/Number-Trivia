
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/network/network_info.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker{}

void main(){
  MockDataConnectionChecker dataConnectionChecker;
  NetworkInfoImplementation networkInfoImplementation;
  
  setUp((){
    dataConnectionChecker = MockDataConnectionChecker();
    networkInfoImplementation = NetworkInfoImplementation(dataConnectionChecker);
  });
  
  group("is Connected", (){
    test("should forward the call to the dataConnectionchecker.hasConnection", () async{
      //arrange
      final tHasConnection = Future.value(true);
      when(dataConnectionChecker.hasConnection).thenAnswer((_)  => tHasConnection);
      //act
      final result = networkInfoImplementation.isConnected;
      //assert
      verify(dataConnectionChecker.hasConnection);
      expect(result, tHasConnection);
    });
  });
}
