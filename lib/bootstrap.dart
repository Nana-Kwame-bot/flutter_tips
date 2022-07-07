import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tips/tips/tips_bloc.dart';
import 'package:logger/logger.dart';
import 'package:tips_and_tricks_api/tips_and_tricks_api.dart';
import 'package:tips_repository/tips_repository.dart';

final Logger logger = Logger(
  // Customize the printer
  printer: PrettyPrinter(
    methodCount: 0,
    printTime: false,
  ),
);

class BootStrap extends StatelessWidget {
  const BootStrap({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) {
            return TipsAndTricksApiClient()..addInterceptors();
          },
        ),
        RepositoryProvider(
          create: (context) {
            return TipsRepository(
              tipsAndTricksApiClient: context.read<TipsAndTricksApiClient>(),
            );
          },
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              return TipsBloc(
                tipsRepository: context.read<TipsRepository>(),
              );
            },
          )
        ],
        child: child,
      ),
    );
  }
}
