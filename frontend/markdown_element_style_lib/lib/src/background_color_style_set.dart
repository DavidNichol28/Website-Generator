import 'package:flutter/material.dart';

class BackgroundColorStyleSet {
  final Color main;
  final Color nav;
  final Color footer;
  final Color codeBlock;
  final Color quote;

  BackgroundColorStyleSet({
    Color? main,
    Color? nav,
    Color? footer,
    Color? codeBlock,
    Color? quote,
  })  : main = main ?? const Color(0xFFFFFFFF), // White for main content (light background)
        nav = nav ?? const Color(0xFF333333),  // Dark gray for navigation
        footer = footer ?? const Color(0xFF222222), // Darker gray for footer
        codeBlock = codeBlock ?? const Color(0xFFF0F0F0), // Light gray for code blocks
        quote = quote ?? const Color(0xFFF7F7F7); 

// Update colors from JSON data
  BackgroundColorStyleSet updateFromJson(Map<String, dynamic> json) {
    return BackgroundColorStyleSet(
      main: json.containsKey('main') ? Color(json['main']) : main,
      nav: json.containsKey('nav') ? Color(json['nav']) : nav,
      footer: json.containsKey('footer') ? Color(json['footer']) : footer,
      codeBlock: json.containsKey('codeBlock') ? Color(json['codeBlock']) : codeBlock,
      quote: json.containsKey('quote') ? Color(json['quote']) : quote,
    );
  }



  factory BackgroundColorStyleSet.cyberpunk() {
    return BackgroundColorStyleSet(
      main: Color(0xFF0D0D0D), // Deep black for main content
      nav: Color(0xFF1A1A2E),  // Dark blue-gray for navigation
      footer: Color(0xFF121212), // Slightly lighter black for footer contrast
      codeBlock: Color(0xFF222831), // Dark metallic gray for code blocks
      quote: Color(0xFF2A2D43), // Dark indigo for a subtle, sleek quote background
    );
  }
}
