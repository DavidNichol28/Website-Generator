@@work_title="Projects Website Generator Design Markdown Parser Design"
# Designing a Markdown to JSON Parser

## Purpose
---
Design a base to easily handle markdown plus increasing levels of customized-markdown into a format that can be easily processed (JSON). Markdown is an extremely powerful design that can and should be further increased to condense more information more easily, and this parser is designed to make that straightforward in its modularity.

## MVP Vision
---
Take a directory full of markdown and turn it into a standardized format that can be fed into systems, like a website generator, so that writers can write instead of figuring out how to format their writing to whatever system they're using.

## MVP Specs
---
* Takes a root directory and crawls through it creating a Map in the structure of the root directory
  - Copies over config.json files in mirror locations
  - Directories turn into nested Maps
  - Turns markdown files into processed JSON
* Markdown to JSON parsing
  - Makes each line its own data structure: MarkdownLineElement
  - Prefix modifiers are stored with MarkdownLineElement
    - Everything after the prefix modifier is stored in MarkdownLineElement.content as a Vec<MarkdownInlineElement>
	  - Inline modifiers are noted (if present) with the text in here
	  - Its a list so: [ {type=plain, text="Hello"}, {type=bold, text="World"} {type=plain, text="."] is for the line "Hello **World**."
  - Handles creating NexusKey
    - Flexible and robust linking system in extended-markdown uses this to go from descriptive/bucket linking to direct linking
  - Handles putting NexusPointers through the NexusKey
    - This hard-codes the links to where they need to point

## Deliverables:
---
* Working parser
* ${"Syntax key"work_title:Projects Website Generator Syntax Design}$
