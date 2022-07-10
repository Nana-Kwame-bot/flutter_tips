import 'package:equatable/equatable.dart';

class TipUrl extends Equatable {
  TipUrl({
    required this.imageUrl,
    required this.codeUrl,
  });

  final String imageUrl;
  final String codeUrl;

  @override
  bool? get stringify => true;

  @override
  List<Object> get props => [imageUrl, codeUrl];
}
