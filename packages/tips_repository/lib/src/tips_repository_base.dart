import 'package:tips_and_tricks_api/tips_and_tricks_api.dart';
import 'package:tips_repository/src/models/tip_url.model.dart';

class TipsRepository {
  TipsRepository({
    required TipsAndTricksApiClient tipsAndTricksApiClient,
  }) : _tipsAndTricksApiClient = tipsAndTricksApiClient;

  final TipsAndTricksApiClient _tipsAndTricksApiClient;

  Future<List<TipUrl>> getTips() async {
    final responseData = await _tipsAndTricksApiClient.getData();
    final data = responseData.data as String;

    final markdownUrls =
        _tipsAndTricksApiClient.getMarkdownUrls(responseData: data);

    final imageUrls = _tipsAndTricksApiClient.getImageUrls(urls: markdownUrls);
    final codeUrls =
        _tipsAndTricksApiClient.getSourceCodeUrls(urls: markdownUrls);

    final tipsUrls = List<TipUrl>.generate(imageUrls.length, (index) {
      return TipUrl(imageUrl: imageUrls[index], codeUrl: codeUrls[index]);
    });
    return tipsUrls;
  }
}
