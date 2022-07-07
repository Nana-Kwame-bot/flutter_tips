import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:tips_and_tricks_api/src/api_interceptor.dart';
import 'package:tips_and_tricks_api/src/exceptions.dart';
// https://raw.githubusercontent.com/vandadnp/flutter-tips-and-tricks/main/README.md

const _rawBlobRoot =
    'https://raw.githubusercontent.com/vandadnp/flutter-tips-and-tricks/main/';

class TipsAndTricksApiClient {
  TipsAndTricksApiClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://bit.ly',
                connectTimeout: 5000,
                receiveTimeout: 3000,
              ),
            );

  final Dio _dio;

  void addInterceptors() {
    _dio.interceptors
      ..add(LoggerInterceptor())
      ..add(RetryInterceptor(
        dio: _dio,
        logPrint: (String log) {
          logger.w(log);
        }, // specify log function (optional)
        retries: 3, // retry count (optional)
        retryDelays: const [
          // set delays between retries (optional)
          Duration(seconds: 1), // wait 1 sec before first retry
          Duration(seconds: 2), // wait 2 sec before second retry
          Duration(seconds: 3), // wait 3 sec before third retry
        ],
      ));
  }

  Future<Response<String>> getData() async {
    try {
      return await _dio.get<String>("/2V1GKsC");
    } on DioError catch (e) {
      throw DioException.fromDioError(dioError: e);
    } catch (_) {
      throw const DioException();
    }
  }

  List<String> getMarkdownUrls({required String responseData}) {
    final split = responseData.split('\n').map((e) => e.trim()).toList()
      ..retainWhere((element) => element.endsWith(".md)"));

    final firstCleaning = split.map((e) => e.replaceAll("](", "+"));
    final secondCleaning =
        firstCleaning.map((e) => e.substring(e.indexOf("+")));
    final thirdCleaning = secondCleaning.map((e) => e.replaceAll("+", ""));
    final fourthCleaning = thirdCleaning.map((e) => e.replaceAll(")", ""));

    return fourthCleaning.toList();
  }

  List<String> getImageUrls({required List<String> urls}) {
    final markdownUrls = urls;

    final firstCleaning = markdownUrls.map((e) => e.replaceAll(".md", ".jpg"));

    final secondCleaning = firstCleaning.map((e) => _rawBlobRoot + e);

    return secondCleaning.toList();
  }

  List<String> getSourceCodeUrls({required List<String> urls}) {
    final markdownUrls = urls;

    final firstCleaning = markdownUrls.map((e) => e.replaceAll(".md", ".dart"));
    final secondCleaning = firstCleaning.map((e) => _rawBlobRoot + e);

    return secondCleaning.toList();
  }

// Future<String> _getPath(String fileName) async {
//   Directory appDocDir = await getApplicationDocumentsDirectory();
//   String appDocPath = appDocDir.path;
//   return "$appDocPath/$fileName";
// }
}
