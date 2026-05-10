import 'package:flutter/material.dart';
import 'src/build/website_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarkdownRenderer extends StatelessWidget {
  // Path the the processed MD
  final String configPath;

  const MarkdownRenderer({super.key, required this.configPath });

  @override
  Widget build(BuildContext context) {
      return ProviderScope(
      child: WebsiteHandler(
        configPath: configPath,
      )
    );
  }
}
