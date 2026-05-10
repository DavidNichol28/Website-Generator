import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:toml/toml.dart';
import 'package:flutter/services.dart';
import 'package:markdown_element_style_lib/markdown_element_style_lib.dart';
import 'markdown_token.dart';
import 'package:flutter/gestures.dart';

class MarkdownLineElement extends StatelessWidget {
  final int indent;
  final MarkdownLineElementType type;
  final List<MarkdownToken> items;
  final TextStyleSet textStyle;
  final TextPaddingSet textPadding;

  const MarkdownLineElement({super.key, required this.indent, required this.type, required this.items, required this.textStyle, required this.textPadding, });

  factory MarkdownLineElement.fromJson(
    Map<String, dynamic> json,
    final void Function(NexusPointer) nexusPointerVoidCallback,
  ) {
    return MarkdownLineElement(
      indent: json['indent'] ?? 0,
      type: _mapStringToLineElementType(json['line_type']),
      items: (json['markdown'] as List<dynamic>?)
          ?.map((item) => MarkdownToken.fromJson(
              item,
              nexusPointerVoidCallback
          ))
          .toList() ?? [],
      textStyle: json['textStyle'] ?? TextStyleSet.cyberpunk(),
      textPadding: json['textPadding'] ?? TextPaddingSet(),
    );
  }

  static MarkdownLineElementType _mapStringToLineElementType(String? type) {
    switch (type) {
      case 'H1':
        return MarkdownLineElementType.h1;
      case 'H2':
        return MarkdownLineElementType.h2;
      case 'H3':
        return MarkdownLineElementType.h3;
      case 'H4':
        return MarkdownLineElementType.h4;
      case 'H5':
        return MarkdownLineElementType.h5;
      case 'H6':
        return MarkdownLineElementType.h6;
      case 'Paragraph':
        return MarkdownLineElementType.paragraph;
      case 'Divider':
        return MarkdownLineElementType.divider;
      case 'OrderedList':
        return MarkdownLineElementType.orderedList;
      case 'UnorderedList':
        return MarkdownLineElementType.unorderedList;
      default:
        return MarkdownLineElementType.hidden;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (items.length == 0) return SizedBox.shrink();
    else {
      return Padding(
        padding: EdgeInsets.only(left: indent * 16.0),
        child: _buildContent(),
      );
    }
  }




Widget _buildContent() {
    // final styleNotifier = ref.read(styleProvider.notifier);
    // final paddingNotifier = ref.read(paddingProvider.notifier);
    String text = "";

    List<TextSpan> textList = [];
    
    for (MarkdownToken token in items) {
      TextSpan newTextSpan;
      String? tokenString = token.getString();

      if (tokenString == "" || tokenString == null) continue;
      else tokenString = tokenString!;
      
      switch (token.getType()) {
        case MarkdownTokenType.plain:
          newTextSpan = TextSpan(text: tokenString);
          break;
        case MarkdownTokenType.bold:
          newTextSpan = TextSpan(
            text: tokenString,
            style: TextStyle(fontWeight: FontWeight.bold),
          );
          break;
        case MarkdownTokenType.boldItalics:
          newTextSpan = TextSpan(
            text: tokenString,
            style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
          );
          break;
        case MarkdownTokenType.italics:
          newTextSpan = TextSpan(
            text: tokenString,
            style: TextStyle(fontStyle: FontStyle.italic),
          );
          break;
        case MarkdownTokenType.nexusPointer:

          if (token is NexusPointerToken) {
            final tapRecognizer = TapGestureRecognizer();
            newTextSpan = TextSpan(
              text: token.nexusPointer.text,
              style: textStyle.link,
              recognizer: tapRecognizer
              ..onTap = () {

                token.executeCallback();
              },
            );
            break;
          }
          else newTextSpan = TextSpan(text: "WHAAAAA");
        default:
          newTextSpan = TextSpan(
            text: tokenString
          );
          break;
      }

      textList.add(newTextSpan);
    }

    switch (type) {
      case MarkdownLineElementType.h1:
        return textPadding.getPadding(
          'h1',
          RichText(
          text: TextSpan(children: textList, style: textStyle.h1),
          )
        );
      case MarkdownLineElementType.h2:
        return textPadding.getPadding(
          'h2',
          RichText(
          text: TextSpan(children: textList, style: textStyle.h2),
        ));
      case MarkdownLineElementType.h3:
        return textPadding.getPadding(
          'h3',
          RichText(
          text: TextSpan(children: textList, style: textStyle.h3),
        ));
      case MarkdownLineElementType.h4:
        return textPadding.getPadding(
          'h4',
          RichText(
          text: TextSpan(children: textList, style: textStyle.h4),
        ));
      case MarkdownLineElementType.h5:
        return textPadding.getPadding(
          'h5',
          RichText(
          text: TextSpan(children: textList, style: textStyle.h5),
        ));
      case MarkdownLineElementType.h6:
        return textPadding.getPadding(
          'h6',
          RichText(
          text: TextSpan(children: textList, style: textStyle.h6),
        ));
      case MarkdownLineElementType.paragraph:
        return textPadding.getPadding(
          'paragraph',
          RichText(
          text: TextSpan(children: textList, style: textStyle.paragraph),
        ));
      case MarkdownLineElementType.unorderedList:
        return textPadding.getPadding(
          'unorderedList',
          Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("• ", style: textStyle.unorderedList),


            Expanded(
              // child: Text(text, style: textStyle.unorderedList)),
              child: RichText(text: TextSpan(children: textList, style: textStyle.unorderedList)),

              
            ),
          ],
        ));
      case MarkdownLineElementType.orderedList:
        return textPadding.getPadding(
          'orderedList',
          Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("1. ", style: textStyle.orderedList),
            Expanded(
              child: RichText(text: TextSpan(children: textList, style: textStyle.unorderedList)),
            ),
          ],
        ));
      case MarkdownLineElementType.divider:
        return Divider();
      case MarkdownLineElementType.hidden:
        return SizedBox.shrink();
      default:
        return textPadding.getPadding(
          'paragraph',
          RichText(
          text: TextSpan(children: textList),
        ));
    }
  }
}

enum MarkdownLineElementType {
  h1,
  h2,
  h3,
  h4,
  h5,
  h6,
  paragraph,
  divider,
  orderedList,
  unorderedList,
  link,
  hidden,
}
