use crate::markdown_line_element::MarkdownLineElement;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MarkdownPage {
    pub title: String,
    pub content: Vec<MarkdownLineElement>,
}
