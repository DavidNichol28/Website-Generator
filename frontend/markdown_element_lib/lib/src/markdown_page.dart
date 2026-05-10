import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:toml/toml.dart';
import 'package:flutter/services.dart';
import 'package:markdown_element_style_lib/markdown_element_style_lib.dart';
import 'markdown_line_element.dart';
import 'markdown_token.dart';

class MarkdownPageRenderer extends StatelessWidget {
  final List<MarkdownLineElement> markdownPageContent;
  Widget? navBar;
  BackgroundColorStyleSet? backgroundColorStyleSet;

  MarkdownPageRenderer({
      super.key,
      required this.markdownPageContent,
      required this.navBar,
      required this.backgroundColorStyleSet,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: backgroundColorStyleSet != null ? backgroundColorStyleSet!.main : Colors.blue,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          navBar ?? SizedBox.shrink(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0
              ),
              child:ListView(
                children: markdownPageContent as List<Widget>,
              )
            ),
          ),
        ]
      )
    );
  }
}


class MarkdownPage {
  final String title;
  final String path;
  final List<MarkdownLineElement> content;

  const MarkdownPage({required this.title, required this.path, required this.content , });

factory MarkdownPage.fromJson(
  Map<String, dynamic> json,
  String path,
  final void Function(NexusPointer) nexusPointerVoidCallback,
) {
    return MarkdownPage(
      title: json['title'] != null ? json['title'] : "NO TITLE????",
      path: path,
      content: json['content'] != null ?(json['content'] as List)
          .map((e) => MarkdownLineElement.fromJson(
              e as Map<String, dynamic>,
              nexusPointerVoidCallback,
          ))
          .toList()
          :
          [],
    );
  }
}
