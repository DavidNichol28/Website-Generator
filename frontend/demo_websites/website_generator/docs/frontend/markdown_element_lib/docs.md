@@work_title="Docs Frontend Markdown Element Lib Docs"
# Markdown Element Lib (Frontend) Docs
## Purpose

The Markdown Element Library is a set of Flutter widgets and utilities designed to render markdown content with customizable styling. It provides a structured way to display markdown content in Flutter applications.

NOTE: Designed to be used by having ExtendedMarkdownSyntax data first processed by ExtendedMarkdownSyntaxParser to be fed into WebsiteBuilder which calls this package.

## Usage

```
import 'package:markdown_element_lib/markdown_element_lib.dart';

// Create a markdown page with content
MarkdownPage page = MarkdownPage(
  title: "My Page",
  path: "/example",
  content: [
    MarkdownLineElement(
      indent: 0,
      type: MarkdownLineElementType.h1,
      items: [Plain(StringToken("Hello World"))],
      textStyle: TextStyleSet.cyberpunk(),
      textPadding: TextPaddingSet(),
    ),
    // Add more elements
  ],
  attributeManager: TreeLocationAttributeManager.newEmpty(),
);

// Render the page
MarkdownPageRenderer(
  markdownPageContent: page.content,
  navBar: MyNavBar(),
  backgroundColorStyleSet: BackgroundColorStyleSet(),
);
```

## Main Components

### MarkdownPage

A container for a complete markdown document.

**Properties:**
- `title`: The title of the page
- `path`: URL path for the page
- `content`: List of MarkdownLineElement objects that make up the page
- `attributeManager`: Manages styling and navigation attributes for the page

**Methods:**
- `fromJson()`: Creates a MarkdownPage from JSON data

### MarkdownPageRenderer

A stateless widget that renders a complete markdown page with navigation and styling.

**Properties:**
- `markdownPageContent`: List of MarkdownLineElement objects to display
- `navBar`: Optional navigation bar widget
- `backgroundColorStyleSet`: Styling for the page background

### MarkdownLineElement

A widget that represents a single line or block of markdown content.

**Properties:**
- `indent`: Indentation level
- `type`: Type of element (heading, paragraph, list, etc.)
- `items`: List of MarkdownToken objects that make up the content
- `textStyle`: Styling for the text
- `textPadding`: Padding settings

**Methods:**
- `fromJson()`: Creates a MarkdownLineElement from JSON data
- `build()`: Renders the element based on its type

### MarkdownToken

An abstract class that represents different types of text formatting.

**Implementations:**
- `Plain`: Regular text
- `Bold`: Bold text
- `Italics`: Italic text
- `BoldItalics`: Bold and italic text
- `NexusPointerToken`: Clickable links

**Methods:**
- `getString()`: Returns the text content
- `getType()`: Returns the formatting type
- `fromJson()`: Factory method to create tokens from JSON

### TreeLocationAttributeManager

Manages styling and navigation attributes for a specific location in the content tree.

**Properties:**
- `location`: Path or identifier for the location
- `nav`: Navigation data
- `textStyle`: Text styling settings
- `backgroundColorStyle`: Background color settings

**Methods:**
- `fromJson()`: Updates attributes from JSON data
- `newEmpty()`: Creates a default empty manager

## Enums

### MarkdownLineElementType

Defines the different types of block elements:
- `h1`, `h2`, `h3`, `h4`, `h5`, `h6`: Heading levels
- `paragraph`: Regular paragraph
- `divider`: Horizontal divider
- `orderedList`: Numbered list item
- `unorderedList`: Bullet list item
- `link`: Hyperlink
- `hidden`: Hidden content

### MarkdownTokenType

Defines the different types of text formatting:
- `plain`: Regular text
- `bold`: Bold text
- `italics`: Italic text
- `boldItalics`: Bold and italic text
- `nexusPointer`: Clickable link

