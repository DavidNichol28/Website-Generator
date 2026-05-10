import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_element_lib/markdown_element_lib.dart';
import 'package:markdown_element_style_lib/markdown_element_style_lib.dart';

class StyleData {
  final TextStyleSet textStyleSet;
  final BackgroundColorStyleSet backgroundColorStyleSet;

  StyleData({
      required this.textStyleSet,
      required this.backgroundColorStyleSet
  });
}

class StyleNotifier extends StateNotifier<StyleData> {
  StyleNotifier() : super(
    StyleData(
      // textStyleSet: TextStyleSet()
      textStyleSet: TextStyleSet.cyberpunk(),
      backgroundColorStyleSet: BackgroundColorStyleSet.cyberpunk()
    )
  );
  void updateBackgroundColorStyleSet(Map<String, dynamic> newStyleSet) {
    state = StyleData(
      backgroundColorStyleSet: state.backgroundColorStyleSet.updateFromJson(newStyleSet),
      textStyleSet: state.textStyleSet,
    );
  }

void updateTextStyleSet(Map<String, dynamic> newStyleSet) {
    state = StyleData(
      backgroundColorStyleSet: state.backgroundColorStyleSet,
      textStyleSet: state.textStyleSet.updateFromJson(newStyleSet),
    );
  }

  TextStyle getTextStyle(MarkdownLineElementType elementType) {
    switch (elementType) {
      case MarkdownLineElementType.h1:
        return state.textStyleSet.h1;
      case MarkdownLineElementType.h2:
        return state.textStyleSet.h2;
      case MarkdownLineElementType.h3:
        return state.textStyleSet.h3;
      case MarkdownLineElementType.h4:
        return state.textStyleSet.h4;
      case MarkdownLineElementType.h5:
        return state.textStyleSet.h5;
      case MarkdownLineElementType.h6:
        return state.textStyleSet.h6;
      case MarkdownLineElementType.paragraph:
        return state.textStyleSet.paragraph;
      case MarkdownLineElementType.orderedList:
        return state.textStyleSet.orderedList;
      case MarkdownLineElementType.unorderedList:
        return state.textStyleSet.unorderedList;
      case MarkdownLineElementType.link:
        return state.textStyleSet.link;
      default:
        return state.textStyleSet.paragraph;
    }
  }
}

final styleProvider = StateNotifierProvider<StyleNotifier, StyleData>((ref) {
  return StyleNotifier();
});
