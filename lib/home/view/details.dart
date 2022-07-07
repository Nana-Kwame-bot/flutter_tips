import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class Details extends StatelessWidget {
  const Details({super.key});

  static Route<void> route() {
    return CupertinoPageRoute(
      // fullscreenDialog: true,
      builder: (context) {
        return const Details();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const MacosScaffold(
      toolBar: ToolBar(
        title: Text('Details'),
      ),
    );
  }
}
