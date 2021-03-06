import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_template/infrastructure/data_sources/users/remote/http_implementation.dart';
import 'package:flutter_app_template/infrastructure/data_sources/users/remote/interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_template/infrastructure/models/user.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group(
    '''

GIVEN a users remote data source''',
    () {
      // External dependencies
      late MockDio mockDio;

      // Remota data source
      late UsersRDSImp usersRDS;

      setUp(
        () {
          mockDio = MockDio();
          usersRDS = UsersRDSImp(
            dio: mockDio,
          );
        },
      );

      test(
        '''

WHEN the users list is requested
THEN a set of remote user models is returned
      ''',
        () async {
          // ARRANGE
          final usersJson = [
            {
              'id': 1,
              'name': 'User 1',
              'username': 'user1',
            },
            {
              'id': 2,
              'name': 'User 2',
              'username': 'user2',
            },
            {
              'id': 3,
              'name': 'User 3',
              'username': 'user3',
            },
          ];
          final users = {
            const UserR(id: 1, name: 'User 1', username: 'user1'),
            const UserR(id: 2, name: 'User 2', username: 'user2'),
            const UserR(id: 3, name: 'User 3', username: 'user3'),
          };

          when(
            () => mockDio.get(
              any(),
            ),
          ).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: ''),
              data: usersJson,
            ),
          );

          // ACT
          final result = await usersRDS.getUsers();

          // ASSERT
          expect(setEquals(result, users), isTrue);
          verify(
            () => mockDio.get(
              '/users',
            ),
          ).called(1);
        },
      );

      test(
        '''

AND no internet connection
WHEN the users list is requested
THEN an exception is thrown
      ''',
        () async {
          // ARRANGE
          when(
            () => mockDio.get(
              any(),
            ),
          ).thenThrow(
            DioError(
              requestOptions: RequestOptions(
                path: '',
              ),
              error: const SocketException(''),
            ),
          );

          // ACT
          Future<void> action() async => usersRDS.getUsers();

          // ASSERT
          expect(
            action,
            throwsA(
              const GetUsersException.offline(),
            ),
          );
          verify(
            () => mockDio.get(
              '/users',
            ),
          ).called(1);
          verifyNoMoreInteractions(mockDio);
        },
      );
    },
  );
}
