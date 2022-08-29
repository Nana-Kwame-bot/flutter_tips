import 'package:dio/dio.dart';
import 'package:tips_and_tricks_api/tips_and_tricks_api.dart';
import 'package:tips_repository/tips_repository.dart';

class TipsRepository {
  TipsRepository({
    required TipsAndTricksApiClient tipsAndTricksApiClient,
  }) : _tipsAndTricksApiClient = tipsAndTricksApiClient;

  final TipsAndTricksApiClient _tipsAndTricksApiClient;

  Future<String> getTempPathAndSaveCodeTemporarily({
    required String codeUrl,
    required String fileName,
    required CancelToken cancelToken,
  }) async {
    return _tipsAndTricksApiClient.downloadCodeTemporarily(
      codeUrl: codeUrl,
      fileName: fileName,
      cancelToken: cancelToken,
    );
  }

  Future<SavedTip> saveTipPermanently({
    required String codeUrl,
    required String imageUrl,
    required String imageFileName,
    required String codeFileName,
    required String title,
    required CancelToken cancelToken,
  }) async {
    final codePath = await _tipsAndTricksApiClient.downloadCodePermanently(
      codeUrl: codeUrl,
      codeFileName: codeFileName,
      cancelToken: cancelToken,
    );
    final imagePath = await _tipsAndTricksApiClient.downloadImagePermanently(
      imageUrl: imageUrl,
      imageFileName: imageFileName,
      cancelToken: cancelToken,
    );

    return SavedTip(
      imagePath: imagePath,
      codePath: codePath,
      title: title,
    );
  }

  Future<List<Tip>> getTips() async {
    final responseData = await _tipsAndTricksApiClient.getData();
    final data = responseData.data as String;

    final rawData = _tipsAndTricksApiClient.getRawData(responseData: data);

    final markdownUrls = _tipsAndTricksApiClient.getMarkdownUrls(urls: rawData);

    final titles = _tipsAndTricksApiClient.getTitles(urls: rawData);

    final imageUrls = _tipsAndTricksApiClient.getImageUrls(urls: markdownUrls);
    final codeUrls =
        _tipsAndTricksApiClient.getSourceCodeUrls(urls: markdownUrls);

    final tipsUrls = List<Tip>.generate(imageUrls.length, (index) {
      return Tip(
        imageUrl: imageUrls[index],
        codeUrl: codeUrls[index],
        title: titles[index],
      );
    });
    return tipsUrls;
  }
}
