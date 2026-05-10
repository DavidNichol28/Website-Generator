# Markdown Element Library (User Version)
## Purpose
The processing of my precious ExtendedMarkdown gets real complicated real fast, so I'm putting everything to do with Markdown[Stuff] structs and impls into here to maintain sanity.
Anything in Rust that wants to do something with a Markdown[stuff] has to go through here.

## Usage
This library provides a set of structures and functions for parsing and handling extended Markdown content. Each component is designed to handle different aspects of the Markdown parsing process.
### MarkdownLineElement
MarkdownLineElement represents a single line in a Markdown document and processes it based on its type.

#### Structure
```
pub struct MarkdownLineElement {
    pub indent: usize,
    pub line_type: MarkdownLineElementType,
    pub markdown: Vec<MarkdownToken>,
}
```

#### Methods
```
new(line: &str) -> Self: Creates a new MarkdownLineElement by parsing a line of text
```
```
parse_markdown(md_content: &str) -> Vec<MarkdownLineElement>: Parses entire Markdown content into a collection of line elements
```
### MarkdownLineElementType
An enum defining different types of Markdown lines:
```
pub enum MarkdownLineElementType {
    H1, H2, H3, H4, H5, H6,
    Paragraph,
    Divider,
    OrderedList,
    UnorderedList,
    ConfigVariable,
}
```

### MarkdownToken
MarkdownToken represents different inline Markdown formatting elements.
#### Structure
```
pub enum MarkdownToken {
    Italics(Box<MarkdownToken>),
    Bold(Box<MarkdownToken>),
    BoldItalics(Box<MarkdownToken>),
    Plain(Box<MarkdownToken>),
    _UseVariable(Box<MarkdownToken>),
    String(String),
    NexusPointer(NexusPointer),
}
```

#### Methods
```
new(token_type: MarkdownTokenType, input: &str) -> MarkdownToken: Creates a new token based on the type and input text
```
```
get_string(&self) -> Option<String>: Extracts the string content from a token, if available
```

### MarkdownTokenType
An enum defining the types of inline tokens:
```
pub enum MarkdownTokenType {
    Italics,
    Bold,
    BoldItalicsStart,
    BoldItalicsEnd,
    NexusPointerStart,
    NexusPointerEnd,
    Plain,
}
```
### NexusPointer
NexusPointer represents a link or reference within the Markdown content.
#### Structure
```
pub struct NexusPointer {
    pub text: String,
    pub link_type: String,
    pub pointer: String,
}
```

#### Methods
```
new(input: &str) -> NexusPointer: Creates a new NexusPointer by parsing the input string
```

### MarkdownPage
MarkdownPage represents a complete Markdown document with title and content.

#### Structure
```
pub struct MarkdownPage {
    pub title: String,
    pub content: Vec<MarkdownLineElement>,
}
```

### Utility Functions
```
process_inline_markdown_text(input: &str) -> Vec<MarkdownToken>: Processes a string of text to identify and create appropriate Markdown tokens
```
```
extract_positions(input: &str) -> HashMap<MarkdownTokenType, Vec<usize>>: Helper function that identifies positions of Markdown symbols in text
```
### Syntax Examples
(Ignore the forward-slashes - they're just there to cancel out the md parser from interpreting them)
**Headers**: # H1, ## H2, etc.
**Bold**: \*\*bold text\*\*
**Italics**: \*italic text\*
**Bold-Italics**: \*\*_bold-italic text_\*\*
**Divider**: ---
**Unordered List**: \- item
**Ordered List**: \* item
**Config Variable**: \@\@ variable
**Nexus Pointer**: \$\{text"link_type:pointer\}\$
