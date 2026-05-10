import 'package:flutter/material.dart';

class TextStyleSet{
  TextStyle h1;
  TextStyle h2;
  TextStyle h3;
  TextStyle h4;
  TextStyle h5;
  TextStyle h6;
  TextStyle paragraph;
  TextStyle orderedList;
  TextStyle unorderedList;
  TextStyle link;

  TextStyleSet({
    TextStyle? h1,
    TextStyle? h2,
    TextStyle? h3,
    TextStyle? h4,
    TextStyle? h5,
    TextStyle? h6,
    TextStyle? paragraph,
    TextStyle? orderedList,
    TextStyle? unorderedList,
    TextStyle? link,
  })  : h1 = h1 ?? const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold
  ),
        h2 = h2 ?? const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold
        ),
        h3 = h3 ?? const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold
        ),
        h4 = h4 ?? const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
        h5 = h5 ?? const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),
        h6 = h6 ?? const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold
        ),
        paragraph = paragraph ?? const TextStyle(
          fontSize: 16
        ),
        link = link ?? const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
orderedList = orderedList ?? const TextStyle(
          fontSize: 16
        ),
        unorderedList = unorderedList ?? const TextStyle(
          fontSize: 16
        );

  TextStyleSet updateFromJson(Map<String, dynamic> json) {
    return TextStyleSet(
      h1: json.containsKey('h1') ? _mapToTextStyle(json['h1']) : h1,
      h2: json.containsKey('h2') ? _mapToTextStyle(json['h2']) : h2,
      h3: json.containsKey('h3') ? _mapToTextStyle(json['h3']) : h3,
      h4: json.containsKey('h4') ? _mapToTextStyle(json['h4']) : h4,
      h5: json.containsKey('h5') ? _mapToTextStyle(json['h5']) : h5,
      h6: json.containsKey('h6') ? _mapToTextStyle(json['h6']) : h6,
      paragraph: json.containsKey('paragraph') ? _mapToTextStyle(json['paragraph']) : paragraph,
      orderedList: json.containsKey('orderedList') ? _mapToTextStyle(json['orderedList']) : orderedList,
      unorderedList: json.containsKey('unorderedList') ? _mapToTextStyle(json['unorderedList']) : unorderedList,
    );
  }

  static TextStyle _mapToTextStyle(dynamic value) {
    if (value is! Map<String, dynamic>) return TextStyle();
    
    return TextStyle(
      fontSize: (value['fontSize'] as num?)?.toDouble(),
      color: value.containsKey('color') ? Color(value['color']) : null,
      fontWeight: _parseFontWeight(value['fontWeight']),
      fontStyle: value['fontStyle'] == 'italic' ? FontStyle.italic : FontStyle.normal,
      letterSpacing: (value['letterSpacing'] as num?)?.toDouble(),
      wordSpacing: (value['wordSpacing'] as num?)?.toDouble(),
      decoration: _parseTextDecoration(value['decoration']),
    );
  }

  static FontWeight? _parseFontWeight(dynamic value) {
    if (value is int) {
      return FontWeight.values.firstWhere(
        (e) => e.index == (value ~/ 100) - 1,
        orElse: () => FontWeight.normal,
      );
    }
    return FontWeight.normal;
  }

  static TextDecoration? _parseTextDecoration(dynamic value) {
    if (value == 'underline') return TextDecoration.underline;
    if (value == 'lineThrough') return TextDecoration.lineThrough;
    if (value == 'overline') return TextDecoration.overline;
    return TextDecoration.none;
  }


  TextStyle getStyle(String elementTypeAsString) {
    switch (elementTypeAsString) {
      case 'h1':
        return h1;
      case 'h2':
        return h2;
      case 'h3':
        return h3;
      case 'h4':
        return h4;
      case 'h5':
        return h5;
      case 'h6':
        return h6;
      case 'paragraph':
        return paragraph;
      case 'orderedList':
        return orderedList;
      case 'unorderedList':
        return unorderedList;
      default:
        return paragraph;
    }
  }

  factory TextStyleSet.cyberpunk() {
    const Color neonPink = Color(0xFFFF007F);
    const Color neonBlue = Color(0xFF00E5FF);
    const Color neonYellow = Color(0xFFFFD700);
    const Color neonOrange = Color(0xFFFF6600);
    const Color darkBackground = Color(0xFF0D0D0D);
    const Color textColor = Color(0xFFCCCCCC);

    return TextStyleSet(
      h1: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: neonYellow,
        letterSpacing: 1.5,
        shadows: [Shadow(blurRadius: 10, color: neonYellow, offset: Offset(2, 2))],
      ),
      h2: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: neonBlue,
        letterSpacing: 1.2,
        shadows: [Shadow(blurRadius: 8, color: neonBlue, offset: Offset(1, 1))],
      ),
      h3: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: neonPink,
        letterSpacing: 1.1,
        shadows: [Shadow(blurRadius: 6, color:neonPink, offset: Offset(1, 1))],
      ),
      h4: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: neonYellow,
        letterSpacing: 1.0,
      ),
      h5: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: neonPink,
        letterSpacing: 0.8,
      ),
      h6: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: neonBlue,
        letterSpacing: 0.6,
      ),
      paragraph: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textColor,
        letterSpacing: 0.5,
      ),
      orderedList: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textColor,
        letterSpacing: 0.5,
      ),
      link: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        color: neonOrange,
        letterSpacing: 0.5,
      ),
      unorderedList: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textColor,
        letterSpacing: 0.5,
      ),
    );
  }
}
