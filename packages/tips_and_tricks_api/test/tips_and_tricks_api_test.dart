import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:tips_and_tricks_api/tips_and_tricks_api.dart';

class MockDio extends Mock implements Dio {}

class MockResponse extends Mock implements Response {}

class MockError extends Mock implements DioError {}

class FakeUri extends Fake implements Uri {}

void main() {
  group("TipsAndTricksApi", () {
    late Dio dio;
    late TipsAndTricksApiClient tipsAndTricksApiClient;

    setUpAll(() {
      registerFallbackValue(FakeUri);
    });

    setUp(() {
      dio = MockDio();
      tipsAndTricksApiClient = TipsAndTricksApiClient();
    });

    group('Constructor', () {
      test('does not require dio', () {
        expect(TipsAndTricksApiClient(), isNotNull);
      });
    });

    group("tips search", () {
      test("makes correct http request", () async {
        try {
          await tipsAndTricksApiClient.getData();
        } catch (_) {}
        verify(() {
          dio.get<String>("/2V1GKsC");
        }).called(1);
      });

      test('throws DioException on DioError with an error message', () {
        when(() => dio.get(any())).thenThrow(DioError);
        expect(
          tipsAndTricksApiClient.getData(),
          throwsA(isA<DioException>().having((e) {
            return e.errorMessage;
          }, "error message", isNotNull)),
        );
      });

      test("has intercepters added", () {
        // when(() => tipsAndTricksApiClient.addInterceptors());
        expect(dio.interceptors, Interceptors().isNotEmpty);
      });
    });
  });
}
