import 'package:equatable/equatable.dart';

class Tip extends Equatable {
  const Tip({
    required this.imageUrl,
    required this.codeUrl,
    required this.title,
  });

  final String imageUrl;
  final String codeUrl;
  final String title;

  @override
  bool? get stringify => true;

  @override
  List<Object> get props => [imageUrl, codeUrl, title];
}
