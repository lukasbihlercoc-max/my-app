// glass_page_widget
import 'package:flutter/material.dart';
import 'package:my_app/views/widgets/background_widget.dart';

class GlassPage extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;

  const GlassPage({
    super.key,
    this.appBar,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: body,
      ),
    );
  }
}

