import 'package:flutter/material.dart';

class TextPaddingSet{
  double h1;
  double h2;
  double h3;
  double h4;
  double h5;
  double h6;
  double paragraph;
  double orderedList;
  double unorderedList;
  double link;

  TextPaddingSet({
    double? h1,
    double? h2,
    double? h3,
    double? h4,
    double? h5,
    double? h6,
    double? paragraph,
    double? orderedList,
    double? unorderedList,
    double? link,
  })  : h1 = h1 ?? 12,
        h2 = h2 ?? 12,
        h3 = h3 ?? 8,
        h4 = h4 ?? 8,
        h5 = h5 ?? 4,
        h6 = h6 ?? 4,
        paragraph = paragraph ?? 4,
orderedList = orderedList ?? 4,
        unorderedList = unorderedList ?? 4,
        link = link ?? 4;

  TextPaddingSet updateFromJson(Map<String, dynamic> json) {
    return TextPaddingSet(
      h1: json.containsKey('h1') ? json['h1'] : h1,
      h2: json.containsKey('h2') ? json['h2'] : h2,
      h3: json.containsKey('h3') ? json['h3'] : h3,
      h4: json.containsKey('h4') ? json['h4'] : h4,
      h5: json.containsKey('h5') ? json['h5'] : h5,
      h6: json.containsKey('h6') ? json['h6'] : h6,
      paragraph: json.containsKey('paragraph') ? json['paragraph'] : paragraph,
      orderedList: json.containsKey('orderedList') ? json['orderedList'] : orderedList,
      unorderedList: json.containsKey('unorderedList') ? json['unorderedList'] : unorderedList,
    );
  }

  Container getPadding(
    String elementTypeAsString,
    Widget childWidget,
  ) {
    switch (elementTypeAsString) {
      case 'h1':
        return Container(
          margin: EdgeInsets.symmetric(vertical: h1),
          child: childWidget,
        );
      case 'h2':
        return Container(
          margin: EdgeInsets.symmetric(vertical: h2),
          child: childWidget,
        );;
      case 'h3':
return Container(
          margin: EdgeInsets.symmetric(vertical: h3),
          child: childWidget,
        );
      case 'h4':
return Container(
          margin: EdgeInsets.symmetric(vertical: h4),
          child: childWidget,
        );
      case 'h5':
return Container(
          margin: EdgeInsets.symmetric(vertical: h5),
          child: childWidget,
        );
      case 'h6':
return Container(
          margin: EdgeInsets.symmetric(vertical: h6),
          child: childWidget,
        );
      case 'paragraph':
return Container(
          margin: EdgeInsets.symmetric(vertical: paragraph),
          child: childWidget,
        );
      case 'orderedList':
return Container(
          margin: EdgeInsets.symmetric(vertical: orderedList),
          child: childWidget,
        );
      case 'unorderedList':
return Container(
          margin: EdgeInsets.symmetric(vertical: unorderedList),
          child: childWidget,
        );
      default:
        return Container(
          margin: EdgeInsets.symmetric(vertical: paragraph),
          child: childWidget,
        );
    }
  }
}
