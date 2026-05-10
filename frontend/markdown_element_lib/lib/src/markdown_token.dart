import 'dart:core';
import 'package:flutter/foundation.dart';

enum MarkdownTokenType {
  plain,          
  bold,          
  italics,      
  boldItalics, 
  nexusPointer,
}

abstract class MarkdownToken {
// Constructor to accept content for subclasses
  MarkdownToken();
  
  // A factory method for creating instances from JSON
  factory MarkdownToken.fromJson(
    Map<String, dynamic> json,
    final void Function(NexusPointer) nexusPointerVoidCallback,
  ) {
    if (json.isEmpty) {
      throw ArgumentError('Empty JSON provided');
    }

    var tokenTypeKey = json.keys.first;
    String? currentString;
    if (tokenTypeKey == "element_type") {
      currentString = json['string']; 
      tokenTypeKey = json['element_type'];
    }
    

    switch (tokenTypeKey) {
      case 'Bold':
        return Bold(StringToken(currentString ?? json['Bold']?['String']));
      case 'Italics':
        return Italics(StringToken(currentString ?? json['Italics']?['String']));
      case 'BoldItalics':
        return BoldItalics(StringToken(currentString ?? json['BoldItalics']?['String']));
      case 'Plain':
        return Plain(StringToken(currentString ?? json['Plain']?['String']));
      case 'NexusPointer':
        var nexusPointerJson = json['NexusPointer'];
        return NexusPointerToken(NexusPointer(
          text: nexusPointerJson['text'] ?? '',
          linkType: nexusPointerJson['link_type'] ?? '',
          pointer: nexusPointerJson['pointer'] ?? '',
          voidCallback: nexusPointerVoidCallback
        ));
      default:
        throw ArgumentError('Unknown Markdown token type: $tokenTypeKey ${json}');
    }
  }

  String? getString();
  MarkdownTokenType getType();
}

class Italics extends MarkdownToken {
  final MarkdownToken content;

  Italics(this.content);

  @override
  String? getString() {
    return content.getString();
  }

  @override
  MarkdownTokenType getType() {
    return MarkdownTokenType.italics;
  }
}

class Bold extends MarkdownToken {
  final MarkdownToken content;

  Bold(this.content);

  @override
  String? getString() {
    return content.getString();
  }

  @override
  MarkdownTokenType getType() {
    return MarkdownTokenType.bold;
  }
}

class BoldItalics extends MarkdownToken {
  final MarkdownToken content;

  BoldItalics(this.content);

  @override
  String? getString() {
    return content.getString();
  }

  @override
  MarkdownTokenType getType() {
    return MarkdownTokenType.boldItalics;
  }
}

class Plain extends MarkdownToken {
  final MarkdownToken content;

  Plain(this.content);

  @override
  String? getString() {
    return content.getString();
  }

  @override
  MarkdownTokenType getType() {
    return MarkdownTokenType.plain;
  }
}

class StringToken extends MarkdownToken {
  final String content;

  StringToken(this.content);

  @override
  String? getString() {
    return content;
  }

  @override
  MarkdownTokenType getType() {
    return MarkdownTokenType.plain; // StringToken is essentially plain text
  }
}

class NexusPointer {
  final String text;
  final String linkType;
  final String pointer;
  final void Function(NexusPointer) voidCallback;

  NexusPointer({
    required this.text,
    required this.linkType,
    required this.pointer,
    required this.voidCallback,
  });

  String toStringRepresentation() {
    return 'NexusPointer(text: $text, linkType: $linkType, pointer: $pointer)';
  }
}

class NexusPointerToken extends MarkdownToken {
  final NexusPointer nexusPointer;

  NexusPointerToken(this.nexusPointer);

  @override
  void executeCallback() {
    nexusPointer.voidCallback(nexusPointer);
  }
  @override
  String? getString() {
    return nexusPointer.pointer; // Customize as needed
  }

  @override
  MarkdownTokenType getType() {
    return MarkdownTokenType.nexusPointer;
  }
}

