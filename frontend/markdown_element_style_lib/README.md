# Markdown Style Element Library

## Purpose
This library provides customizable styling options for use with the Markdown Elements Library.

## Usage
Import the package in your Flutter application:
**import 'package:markdown_element_style_lib/markdown_element_style_lib.dart';**

### TextStyleSet
The TextStyleSet class defines text styling for different markdown elements.
#### Properties

**h1**: TextStyle for heading level 1
**h2**: TextStyle for heading level 2
**h3**: TextStyle for heading level 3
**h4**: TextStyle for heading level 4
**h5**: TextStyle for heading level 5
**h6**: TextStyle for heading level 6
**paragraph**: TextStyle for paragraph text
**orderedList**: TextStyle for ordered lists
**unorderedList**: TextStyle for unordered lists
**link**: TextStyle for hyperlinks

#### Methods
##### Constructor
**TextStyleSet({
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
})**

##### updateFromJson
Updates styles from a JSON map:
**TextStyleSet updateFromJson(Map<String, dynamic> json)**

##### getStyle
Retrieves style for a specific element type:
**TextStyle getStyle(String elementTypeAsString)**

##### Factory Methods
**TextStyleSet.cyberpunk()**: Creates a cyberpunk-themed style set with neon colors and shadows

### TextPaddingSet
The TextPaddingSet class defines vertical padding for different markdown elements.
#### Properties

**h1**: Padding for heading level 1
**h2**: Padding for heading level 2
**h3**: Padding for heading level 3
**h4**: Padding for heading level 4
**h5**: Padding for heading level 5
**h6**: Padding for heading level 6
**paragraph**: Padding for paragraph text
**orderedList**: Padding for ordered lists
**unorderedList**: Padding for unordered lists
**link**: Padding for hyperlinks

#### Methods
##### Constructor
**PaddingSet({
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
})**

##### updateFromJson
Updates padding values from a JSON map:
**PaddingSet updateFromJson(Map<String, dynamic> json)**

##### getPadding
Creates a container with the appropriate vertical padding for an element:
**Container getPadding(String elementTypeAsString, Widget childWidget)**

### BackgroundColorStyleSet
The BackgroundColorStyleSet class defines background colors for different elements of a markdown document.

#### Properties
**main**: Background color for the main content area
**nav**: Background color for navigation elements
**footer**: Background color for the footer
**codeBlock**: Background color for code blocks
**quote**: Background color for quotes/blockquotes

#### Methods

##### Constructor
**BackgroundColorStyleSet({
  Color? main,
  Color? nav,
  Color? footer,
  Color? codeBlock,
  Color? quote,
})**

##### updateFromJson
Updates colors from a JSON map:
**BackgroundColorStyleSet updateFromJson(Map<String, dynamic> json)**

##### Factory Methods
**BackgroundColorStyleSet.cyberpunk()**: Creates a cyberpunk-themed color set with dark backgrounds

