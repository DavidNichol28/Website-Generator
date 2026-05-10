import 'package:flutter/material.dart';
import 'package:markdown_renderer/markdown_renderer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MarkdownRenderer(configPath: 'assets/processed_data/');
  }
}
