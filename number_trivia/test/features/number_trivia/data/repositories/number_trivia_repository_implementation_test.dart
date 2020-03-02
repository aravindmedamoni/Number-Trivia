
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_implementation.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource{}
class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource{}
class MockNetworkInfo extends Mock implements NetworkInfo{}

void main(){
  NumberTriviaRepositoryImplementation repositoryImplementation;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp((){
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImplementation = NumberTriviaRepositoryImplementation(
      remoteDataSource:mockRemoteDataSource,
      localDataSource:mockLocalDataSource,
      networkInfo:mockNetworkInfo
    );
  });

  void runTestsOnline(Function body){
    group("device is online", (){
      setUp((){
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
    body();
    });
  }
  void runTestsOffline(Function body){
    group("device is offline", (){
      setUp((){
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }
  
  group("getConcreteNumberTrivia", (){
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(text: "test trivia", number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test("should check if the device is online", () async{
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repositoryImplementation.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockNetworkInfo.isConnected);
    },);
    runTestsOnline( (){
      test("should return remote data when call to the remote data is success", () async{
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((_) async=> tNumberTriviaModel);
        //act
        final result = await repositoryImplementation.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });

      test("should cache data locally when call to the remote data is success", () async{
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((_) async=> tNumberTriviaModel);
        //act
        await repositoryImplementation.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test("should return server failure when call to the remote data is unsuccess", () async{
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenThrow(ServerException());
        //act
        final result = await repositoryImplementation.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });

    });
    runTestsOffline((){
      test("should return last locally data when the cached data is present", () async{
        //arrange
        when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async=> tNumberTriviaModel);
        //act
        final result = await repositoryImplementation.getConcreteNumberTrivia(tNumber);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test("should return cach failure when there is no cached data is present", () async{
        //arrange
        when(mockLocalDataSource.getLastNumberTrivia()).thenThrow(ServerException());
        //act
        final result = await repositoryImplementation.getConcreteNumberTrivia(tNumber);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(left(ServerFailure())));
      });
      
    });
  });

  group("getConcreteNumberTrivia", (){
    final tNumberTriviaModel = NumberTriviaModel(text: "test trivia", number: 12);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test("should check if the device is online", () async{
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repositoryImplementation.getRandomNumberTrivia();
      //assert
      verify(mockNetworkInfo.isConnected);
    },);
    runTestsOnline( (){
      test("should return remote data when call to the remote data is success", () async{
        //arrange
        when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async=> tNumberTriviaModel);
        //act
        final result = await repositoryImplementation.getRandomNumberTrivia();
        //assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test("should cache data locally when call to the remote data is success", () async{
        //arrange
        when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async=> tNumberTriviaModel);
        //act
        await repositoryImplementation.getRandomNumberTrivia();
        //assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test("should return server failure when call to the remote data is unsuccess", () async{
        //arrange
        when(mockRemoteDataSource.getRandomNumberTrivia()).thenThrow(ServerException());
        //act
        final result = await repositoryImplementation.getRandomNumberTrivia();
        //assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });

    });
    runTestsOffline((){
      test("should return last locally data when the cached data is present", () async{
        //arrange
        when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async=> tNumberTriviaModel);
        //act
        final result = await repositoryImplementation.getRandomNumberTrivia();
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test("should return cach failure when there is no cached data is present", () async{
        //arrange
        when(mockLocalDataSource.getLastNumberTrivia()).thenThrow(ServerException());
        //act
        final result = await repositoryImplementation.getRandomNumberTrivia();
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(left(ServerFailure())));
      });

    });
  });
}