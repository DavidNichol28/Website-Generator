@@work_title="Docs Backend Markdown Renderer Docs"
# Markdown Renderer User Docs
## Purpose
Takes in the intermediary data processed and stored by ${"Markdown Element Lib."work_title:Docs Backend Markdown Element Lib Overview}$

This is used to build a website out by passing data to ${"Frontend Markdown Element Lib"work_title: Docs Frontend Markdown Element Lib Overview}$ and ${"Frontend Markdown Element Style Lib"work_title: Docs Frontend Markdown Element Style Lib Overview}$ and putting the rest of it together herein.

Also responsible for repeating components like the RFNavBar (more soon like RFFooter, RFButton, etc).

## Basic Example
###### Code Snippet Start...

final renderer = MarkdownRenderer(configPath: "path/to/root/of/intermediary/data/directory");

###### Code Snippet End...

bla bla

## Data Structures
### MarkdownRenderer
MarkdownRenderer takes in the path to the intermediary data and passes it to WebsiteHandler.

#### Structure
class MarkdownRenderer {
    String configPath,
}

### WebsiteHandler
WebsiteHandler takes in the path from MarkdownRenderer and handles getting the site built as well as running the loading spinner.

Turns the stored data into a Map<String, dynamic> for WebsiteBuilder.

#### Structure
class MarkdownRenderer {
    String configPath,
}

### WebsiteBuilder
WebsiteBuilder takes in the loaded intermediary data from WebsiteHandler, and it calls and uses the Riverpod state stuff and components (like RFNavBar) to get everything ready to be passed to create MarkdownPageRenderer from ${"Frontend Markdown Element Lib."work_title: Docs Frontend Markdown Element Lib Overview}$

#### Structure
class WebsiteBuilder {
    String config,
}

## Functions
### loadConfig

### _processManifest

## State
### WebsiteData
Holds all the data for the website (NOTE: can probably drop all elements prepended with "action" and just pass them in for creation so it doesn't hold all that all the time...)

Returns WebsiteBuilder to render when the config is ready and remains there to manage state.

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
}

#### Methods
##### updateWebDirectory
This pumps all the config data in - should only be called once.
##### updatePage
This takes in data to update the pageStack and currentPage directly (helper function).
##### figureOutBackPage
This gets the last page the user was on from pageStack, and sends that and pageStack (minus last element) to updatePage.
##### handleChangingCurrentPage
This takes an internal NexusPointer pointer and figures out which page to render and updates pageStack and currentPage (by sending the new values to updatePage) in doing so.

### StyleData
Gathers the styling classes from ${"Frontend Markdown Element Style Lib"work_title: Docs Frontend Markdown Element Style Lib Overview}$ and inits them.
class StyleData {
  final TextStyleSet textStyleSet;
  final BackgroundColorStyleSet backgroundColorStyleSet;
}

### PaddingData
Honestly, don't know what the hell is going on here. Needs attention but works, apparently. It may be a placeholder or something...
