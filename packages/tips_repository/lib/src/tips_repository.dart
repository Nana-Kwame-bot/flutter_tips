import 'package:dio/dio.dart';
import 'package:tips_and_tricks_api/tips_and_tricks_api.dart';
import 'package:tips_repository/src/models/tip.dart';

class TipsRepository {
  TipsRepository({
    required TipsAndTricksApiClient tipsAndTricksApiClient,
  }) : _tipsAndTricksApiClient = tipsAndTricksApiClient;

  final TipsAndTricksApiClient _tipsAndTricksApiClient;

  Future<String> getTempPathAndSaveCodeTemporarily({
    required String codeUrl,
    required String fileName,
    required CancelToken cancelToken,
  }) {
    return _tipsAndTricksApiClient.downloadCodeTemporarily(
      codeUrl: codeUrl,
      fileName: fileName,
      cancelToken: cancelToken,
    );
  }

  void getAndSaveCodePermanently() {}

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
    })
      ..shuffle();
    return tipsUrls;
  }
}
