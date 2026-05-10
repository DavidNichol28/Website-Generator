import 'package:flutter/material.dart';
import 'package:markdown_element_lib/markdown_element_lib.dart';
import 'package:markdown_element_style_lib/markdown_element_style_lib.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:html' as html;

class WebsiteData {
  final Map<String, MarkdownPage> webDirectory;
  final MarkdownPage? currentPage;
  final List<MarkdownPage> pageStack;
  final String? currentDirectory;
  final Map<String, dynamic> nexusKey;
  final List<String> actionWidgetStringsLists;
  // This gets passed into VoidCallback to Navigator
  final List<String> actionWidgetCallbackValuesLists;
  final Map<String, List<String>> actionWidgetStringsListsMap;
  final Map<String, List<String>> actionWidgetCallbackValuesListsMap;

  WebsiteData({
      required this.webDirectory,
      required this.currentPage,
      // This tracks where the user has been for back button navigation
      required this.pageStack,
      required this.currentDirectory,
      required this.nexusKey,
      required this.actionWidgetStringsLists,
      required this.actionWidgetCallbackValuesLists,
      required this.actionWidgetStringsListsMap,
      required this.actionWidgetCallbackValuesListsMap,
  });
}

class WebsiteNotifier extends StateNotifier<WebsiteData> {
  WebsiteNotifier() : super(
    WebsiteData(
      webDirectory: {},
      currentPage: null,
      pageStack: [],
      currentDirectory: null,
      nexusKey: {},
      actionWidgetStringsLists: [],
      actionWidgetCallbackValuesLists: [],
      actionWidgetStringsListsMap: {},
      actionWidgetCallbackValuesListsMap: {},
    )
  );
WebsiteData copyWith({
    Map<String, MarkdownPage>? webDirectory,
    MarkdownPage? currentPage,
    List<MarkdownPage>? pageStack,
    String? currentDirectory,
    Map<String, dynamic>? nexusKey,
    List<String>? actionWidgetStringsLists,
    List<String>? actionWidgetCallbackValuesLists,
    Map<String, List<String>>? actionWidgetStringsListsMap,
    Map<String, List<String>>? actionWidgetCallbackValuesListsMap,
  }) {
    print("starting copy");
    return WebsiteData(
      webDirectory: webDirectory ?? state.webDirectory,
      currentPage: currentPage ?? state.currentPage,
      pageStack: pageStack ?? state.pageStack,
      currentDirectory: currentDirectory ?? state.currentDirectory,
      nexusKey: nexusKey ?? state.nexusKey,
      actionWidgetStringsLists: actionWidgetStringsLists ?? state.actionWidgetStringsLists,
      actionWidgetCallbackValuesLists: actionWidgetCallbackValuesLists ?? state.actionWidgetCallbackValuesLists,
      actionWidgetStringsListsMap: actionWidgetStringsListsMap ?? state.actionWidgetStringsListsMap,
      actionWidgetCallbackValuesListsMap: actionWidgetCallbackValuesListsMap ?? state.actionWidgetCallbackValuesListsMap,
    );

    print("ending copy");
  }

  void updateWebDirectory(
    Map<String, dynamic> update,
  ) {
    print("update.keys: ${update['nexusKey'].keys}");
// Ensure the map values are explicitly cast to the correct type
Map<String, List<String>> actionWidgetStringsListsMap = (update['actionWidgetStringsListsMap'] as Map<String, dynamic>).map(
  (key, value) => MapEntry(key, List<String>.from(value as List<dynamic>)),
);

Map<String, List<String>> actionWidgetCallbackValuesListsMap = (update['actionWidgetCallbackValuesListsMap'] as Map<String, dynamic>).map(
  (key, value) => MapEntry(key, List<String>.from(value as List<dynamic>)),
);

     print("tsukablyat");
    state = copyWith(
      webDirectory: update['newWebDirectory']!,
      currentPage: update['newWebDirectory']!['overview'],
      nexusKey: update['nexusKey'],
      actionWidgetStringsLists: update['actionWidgetStringsListsMap'][""].cast<String>(),
      actionWidgetCallbackValuesLists: update['actionWidgetCallbackValuesListsMap'][""].cast<String>(),

      actionWidgetStringsListsMap: actionWidgetStringsListsMap,
      actionWidgetCallbackValuesListsMap:actionWidgetCallbackValuesListsMap,
    );
  }

  void updatePage(List<MarkdownPage> pageStack, MarkdownPage newPage) {
state = copyWith(
      pageStack: pageStack,
      currentPage: newPage,
    );
  }

  void figureOutBackPage() {
    print("THIS IS THE SPOT");
    // Get the last one in pageStack
    MarkdownPage backString = state.pageStack.last;
    List<MarkdownPage> updatedPageStack = state.pageStack;
    updatedPageStack.remove(backString);
    // Update pageStack to have aforementioned last item removed and set to currentPage
    updatePage(updatedPageStack, backString);
  }

  void handleChangingCurrentPage(String key) {
    var realPage;
    if (key[0] == "/" ) {
      key = key.substring(1);
      }
      if (key.length > 0) {
        // This looks for the key straight in, then defaults to the key plus "/overview"
        realPage = state.webDirectory[key] ?? state.webDirectory["$key/overview"];
      }
      else {
        // Returns local directory root page
        realPage = state.webDirectory["overview"]!;
      }
    print("key: $key");
    print("webDirectory: ${state.webDirectory}");

    bool isNewDirectory = true;
    // bool isNewDirectory = checkIfNewDirectory(key);

      // Take currentPage and push that String to pageStack before updating
      MarkdownPage currentPage = state.currentPage!;
      List<MarkdownPage> updatedPageStack = state.pageStack;
      updatedPageStack.add(currentPage);
      // Update pageStack to have aforementioned last item removed and set to currentPage
      updatePage(updatedPageStack, realPage!);
  }



  //
  //
  //
  //
  //
  // Make all this shit below static - it shouldn't be doing this everytime
  //
  //
  //
  //
  // 

    
  void handleNexusPointer(NexusPointer nexusPointer) {
    print("NexusPointer.pointer: ${nexusPointer.pointer}");
if (nexusPointer.linkType == "link") {
    // Open in new browser tab  // Ensure the link is absolute
    String key = nexusPointer.pointer;
    final url = key.startsWith("http") ? key : "https://$key";
    html.window.open(url, "_blank");
    return; // Prevents falling through to internal navigation
  }
  else {
    String key = getHardLink(
      nexusPointer.linkType,
      nexusPointer.pointer,
    );
    handleChangingCurrentPage(key);
  }
  }


  String getHardLink(String linkType, String linkString) {
    if (linkType == "work_title") {
      return state.nexusKey[linkType][linkString]!;
    }
    else {
      print("open this link: $linkString");
      return linkString;
    }
  }
  
}

final websiteProvider = StateNotifierProvider<WebsiteNotifier, WebsiteData>((ref) {
  return WebsiteNotifier();
});
