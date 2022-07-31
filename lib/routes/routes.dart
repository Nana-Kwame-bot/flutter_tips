import 'package:flutter/cupertino.dart';
import 'package:flutter_tips/app/views/main_view.dart';
import 'package:flutter_tips/tip_details/view/tip_details.dart';
import 'package:go_router/go_router.dart';

final goRouter = GoRouter(
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
        name: MainView.name,
        path: MainView.path,
        pageBuilder: (context, state) => CupertinoPage(
              child: const MainView(),
              key: state.pageKey,
              restorationId: state.pageKey.value,
            ),
        routes: [
          GoRoute(
            name: TipDetails.name,
            path: TipDetails.path,
            pageBuilder: (context, state) => CupertinoPage(
              key: state.pageKey,
              restorationId: state.pageKey.value,
              child: const TipDetails(),
            ),
            redirect: (state) {
              final atHome = state.subloc == MainView.path;
              return atHome ? TipDetails.path : null;
              // final goingToDetails = state.subloc == TipDetails.path;
              // return goingToDetails ? null : TipDetails.path;
            },
          ),
        ],),
  ],
);
