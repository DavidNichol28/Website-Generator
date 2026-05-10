@@work_title="Docs Backend Markdown Element Lib Docs"
# Markdown Element Lib (Backend) Docs
## Purpose
Takes data in ${"ExtendedMarkDown syntax"work_title:Walkthrough Syntax Overview}$ and turns it into an intermediate format to be passed to ${"Markdown Element Lib (Frontend)"work_title:Docs Frontend Markdown Element Lib Overview}$ to be turned into frontend components.

## Basic Example
###### Code Snippet Start...
use markdown_element_lib::MarkdownLineElement;

fn main() {
    let md_content = r#"
    \# Hello World
    This is a paragraph.
    "#;

    let elements: Vec<MarkdownLineElement> =
        MarkdownLineElement::parse_markdown(md_content);

    println!("{:?}", elements);
}
###### Code Snippet End...

This will parse an entire Markdown file into a Vec<MarkdownLineElement>, which can be consumed by the frontend library.

## Data Structures
### MarkdownPage
MarkdownPage represents a complete Markdown document with title and content.

#### Structure
pub struct MarkdownPage {
    pub title: String,
    pub content: Vec<MarkdownLineElement>,
}

### MarkdownLineElement
MarkdownLineElement represents a single line in a Markdown document and processes it based on its type.

#### Structure
pub struct MarkdownLineElement {
    // Tracks spaces in indentation
    pub indent: usize,
    // Denotes what type of line (H1-H6, etc)
    pub line_type: MarkdownLineElementType,
    // Holds pieces of the line according to how they should be rendered
    pub markdown: Vec<MarkdownToken>,
}

### MarkdownLineElementType
An enum defining different types of Markdown lines:

pub enum MarkdownLineElementType {
    H1, H2, H3, H4, H5, H6,
    Paragraph,
    Divider,
    OrderedList,
    UnorderedList,
    ConfigVariable,
}

Additions to this type will create a new option to render MarkdownLineElements and will need to be addressed accordingly.

### MarkdownToken
Holds data to be used in rendering pieces of the inline markdown.

It recurses into itself until the end which will either be a String(String) or NexusPointer(NexusPointer).
#### Structure
pub enum MarkdownToken {
    Italics(Box<MarkdownToken>),
    Bold(Box<MarkdownToken>),
    BoldItalics(Box<MarkdownToken>),
    Plain(Box<MarkdownToken>),
    _UseVariable(Box<MarkdownToken>),
    String(String),
    NexusPointer(NexusPointer),
}

Additions to MarkdownTokenType will require that this be added to in the appropriate manner.

### MarkdownTokenType
Represents different inline Markdown formatting elements.
pub enum MarkdownTokenType {
    Italics,
    Bold,
    BoldItalicsStart,
    BoldItalicsEnd,
    NexusPointerStart,
    NexusPointerEnd,
    Plain,
}

Additions to this type will create a new option to render MarkdownInlineElements and will need to be addressed accordingly.

### NexusPointer
NexusPointer represents a link or reference within the Markdown content.
#### Structure
pub struct NexusPointer {
	// What is rendered on-page represented as a hyperlink
    pub text: String,
	// Tells the parser if the link is internal ("work_title") or external ("link")
    pub link_type: String,
	// The string that is the identifying information (a work title or a url) for the link
    pub pointer: String,
}

## Tickets
- Separate the parser code out into its own module and leave this as an actual library.
