use crate::markdown_inline_element::{process_inline_markdown_text, MarkdownToken};
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub enum MarkdownLineElementType {
    H1,
    H2,
    H3,
    H4,
    H5,
    H6,
    Paragraph,
    Divider,
    OrderedList,
    UnorderedList,
    ConfigVariable,
}
impl MarkdownLineElementType {
    fn get_header_by_int(number: usize) -> MarkdownLineElementType {
        return match number {
            1 => MarkdownLineElementType::H1,
            2 => MarkdownLineElementType::H2,
            3 => MarkdownLineElementType::H3,
            4 => MarkdownLineElementType::H4,
            5 => MarkdownLineElementType::H5,
            _ => MarkdownLineElementType::H6,
        };
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MarkdownLineElement {
    pub indent: usize,
    pub line_type: MarkdownLineElementType,
    pub markdown: Vec<MarkdownToken>,
}

impl MarkdownLineElement {
    pub fn new(line: &str) -> Self {
        let indent = line.chars().take_while(|&c| c == ' ').count() / 2;
        if indent * 2 != line.chars().take_while(|&c| c == ' ').count() {
            panic!("Indentation error: Indentation must be a multiple of 2 spaces\nline that fugged ub: {}", &line);
        }

        let trimmed = line.trim_start();
        let (line_type, content): (MarkdownLineElementType, &str) = if trimmed.starts_with("#") {
            let level = trimmed.chars().take_while(|&c| c == '#').count();
            let line_type = MarkdownLineElementType::get_header_by_int(level);
            (line_type, &trimmed[level..].trim())
        } else if trimmed.starts_with("---") {
            (MarkdownLineElementType::Divider, "")
        } else if trimmed.starts_with("- ") {
            (MarkdownLineElementType::UnorderedList, &trimmed[2..].trim())
        } else if trimmed.starts_with("* ") {
            (MarkdownLineElementType::OrderedList, &trimmed[2..].trim())
        } else if trimmed.starts_with("@@") {
            (
                MarkdownLineElementType::ConfigVariable,
                &trimmed[2..].trim(),
            )
        } else {
            (MarkdownLineElementType::Paragraph, trimmed)
        };

        MarkdownLineElement {
            indent,
            line_type,
            markdown: process_inline_markdown_text(&content),
        }
    }

    pub fn parse_markdown(md_content: &str) -> Vec<MarkdownLineElement> {
        md_content.lines().map(MarkdownLineElement::new).collect()
    }
}
