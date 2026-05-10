use serde::{Deserialize, Serialize};
use std::collections::HashMap;

#[derive(Debug, Hash, Eq, PartialEq, Clone, Deserialize, Serialize)]
pub enum MarkdownTokenType {
    Italics,
    Bold,
    BoldItalicsStart,
    BoldItalicsEnd,
    NexusPointerStart,
    NexusPointerEnd,
    Plain,
}
#[derive(Debug, Clone, PartialEq, Deserialize, Serialize)]
pub enum MarkdownToken {
    Italics(Box<MarkdownToken>),
    Bold(Box<MarkdownToken>),
    BoldItalics(Box<MarkdownToken>),
    Plain(Box<MarkdownToken>),
    _UseVariable(Box<MarkdownToken>),
    String(String),
    NexusPointer(NexusPointer),
}

impl MarkdownToken {
    // New method that creates a MarkdownToken::BoldItalics variant
    pub fn new(token_type: MarkdownTokenType, input: &str) -> MarkdownToken {
        return match token_type {
            MarkdownTokenType::Italics => {
                MarkdownToken::Italics(Box::new(MarkdownToken::String(input.to_string())))
            }
            MarkdownTokenType::Bold => {
                MarkdownToken::Bold(Box::new(MarkdownToken::String(input.to_string())))
            }
            MarkdownTokenType::BoldItalicsStart | MarkdownTokenType::BoldItalicsEnd => {
                MarkdownToken::BoldItalics(Box::new(MarkdownToken::String(input.to_string())))
            }
            MarkdownTokenType::NexusPointerStart | MarkdownTokenType::NexusPointerEnd => {
                MarkdownToken::NexusPointer(NexusPointer::new(&input))
            }
            // Add other MarkdownTokenType matches here if you want to handle other cases
            _ => MarkdownToken::Plain(Box::new(MarkdownToken::String(input.to_string()))),
        };
    }

    // Method to extract the string from the token
    pub fn get_string(&self) -> Option<String> {
        match self {
            // If the variant is String, return the string
            MarkdownToken::String(s) => Some(s.clone()),

            // If the variant is BoldItalics, recursively check the inner token
            MarkdownToken::BoldItalics(inner) => inner.get_string(),

            // If the variant is Italics, recursively check the inner token
            MarkdownToken::Italics(inner) => inner.get_string(),

            // If the variant is Bold, recursively check the inner token
            MarkdownToken::Bold(inner) => inner.get_string(),

            // If the variant is Plain, recursively check the inner token
            MarkdownToken::Plain(inner) => inner.get_string(),

            // For other token types, return None (they don't contain a string)
            _ => None,
        }
    }
}

#[derive(Debug, Clone, PartialEq, Deserialize, Serialize)]
pub struct NexusPointer {
    pub text: String,
    pub link_type: String,
    pub pointer: String,
}
impl NexusPointer {
    pub fn new(input: &str) -> NexusPointer {
        println!("input: {}", input);
        let first_quote = input.chars().position(|c| c == '"').unwrap();
        let string: String = input.chars().take(first_quote).collect();
        let colon_index = input.chars().position(|c| c == ':').unwrap();
        let link_type: String = input
            .chars()
            .skip(first_quote + 1)
            .take(colon_index - first_quote - 1)
            .collect();
        let pointer: String = input
            .chars()
            .skip(colon_index + 1)
            .take(input.len() - 1)
            .collect();

        return NexusPointer {
            text: string,
            link_type,
            pointer,
        };
    }
}

/// Extracts the positions of markdown symbols in the input string.
/// Returns a HashMap where each key is a MarkdownTokenType and the value is a vector of indices.
fn extract_positions(input: &str) -> HashMap<MarkdownTokenType, Vec<usize>> {
    let mut positions: HashMap<MarkdownTokenType, Vec<usize>> = HashMap::new();

    // Locate special markdown markers in the input.
    positions.insert(
        MarkdownTokenType::NexusPointerStart,
        input.match_indices("${").map(|(i, _)| i).collect(),
    );
    positions.insert(
        MarkdownTokenType::NexusPointerEnd,
        input.match_indices("}$").map(|(i, _)| i).collect(),
    );
    positions.insert(
        MarkdownTokenType::BoldItalicsStart,
        input.match_indices("**_").map(|(i, _)| i).collect(),
    );
    positions.insert(
        MarkdownTokenType::BoldItalicsEnd,
        input.match_indices("_**").map(|(i, _)| i).collect(),
    );

    // Filter out ** that are actually part of **_ bold-italics sequences.
    let bold_indices_raw: Vec<usize> = input.match_indices("**").map(|(i, _)| i).collect();
    let mut bold_indices: Vec<usize> = vec![];
    for &bold_index in &bold_indices_raw {
        if !positions[&MarkdownTokenType::BoldItalicsStart].contains(&bold_index)
            && !(bold_index > 0
                && positions[&MarkdownTokenType::BoldItalicsEnd].contains(&(bold_index - 1)))
        {
            bold_indices.push(bold_index);
        }
    }
    positions.insert(MarkdownTokenType::Bold, bold_indices);

    // Identify valid standalone * for italics (not part of bold or bold-italics sequences).
    let italics_indices_raw: Vec<usize> = input.match_indices("*").map(|(i, _)| i).collect();
    let mut italics_indices: Vec<usize> = vec![];
    for &italics_index in &italics_indices_raw {
        if !positions[&MarkdownTokenType::Bold].contains(&italics_index)
            && !(italics_index > 0
                && positions[&MarkdownTokenType::Bold].contains(&(italics_index - 1)))
            && !positions[&MarkdownTokenType::BoldItalicsStart].contains(&italics_index)
            && !(italics_index > 0
                && positions[&MarkdownTokenType::BoldItalicsStart].contains(&(italics_index - 1)))
            && !(italics_index > 0
                && positions[&MarkdownTokenType::BoldItalicsEnd].contains(&(italics_index - 1)))
            && !(italics_index > 1
                && positions[&MarkdownTokenType::BoldItalicsEnd].contains(&(italics_index - 2)))
        {
            italics_indices.push(italics_index);
        }
    }
    positions.insert(MarkdownTokenType::Italics, italics_indices);

    positions
}

/// Handles opening and closing logic for markdown tokens.
fn handle_token_logic(
    input: &str,
    lowest_index: usize,
    current_index: usize,
    lowest_index_type: &MarkdownTokenType,
    token_type_stack: &mut Vec<MarkdownTokenType>,
    tokens: &mut Vec<MarkdownToken>,
) {
    let parsed_text = input[current_index..lowest_index].to_string();
    if token_type_stack.is_empty()
        || !(token_type_stack.last().unwrap() == &MarkdownTokenType::BoldItalicsStart
            && lowest_index_type == &MarkdownTokenType::BoldItalicsEnd)
            && !(token_type_stack.last().unwrap() == &MarkdownTokenType::NexusPointerStart
                && lowest_index_type == &MarkdownTokenType::NexusPointerEnd)
            && !(token_type_stack.last().unwrap() == lowest_index_type)
    {
        if token_type_stack.is_empty() {
            tokens.push(MarkdownToken::new(MarkdownTokenType::Plain, &parsed_text));
        } else {
            tokens.push(MarkdownToken::new(
                token_type_stack.last().unwrap().clone(),
                &parsed_text,
            ));
        }
        token_type_stack.push(lowest_index_type.clone());
    } else {
        let current_closure = token_type_stack.pop().unwrap();
        tokens.push(MarkdownToken::new(current_closure, &parsed_text));
    }
}

/// Processes the markdown input and updates the token list accordingly.
pub fn process_inline_markdown_text(input: &str) -> Vec<MarkdownToken> {
    let mut token_type_stack: Vec<MarkdownTokenType> = vec![];
    let mut current_index = 0;
    let mut tokens: Vec<MarkdownToken> = vec![];
    // Get the positions of the inline text modifiers
    let positions: HashMap<MarkdownTokenType, Vec<usize>> = extract_positions(&input);

    while current_index < input.len() {
        let mut lowest_index = usize::MAX;
        let mut lowest_index_type = MarkdownTokenType::Plain;

        for (token_type, indices) in &positions {
            if let Some(&index) = indices.iter().find(|&&i| i >= current_index) {
                if index < lowest_index {
                    lowest_index = index;
                    lowest_index_type = token_type.clone();
                }
            }
        }

        if lowest_index == usize::MAX {
            break;
        }

        handle_token_logic(
            input,
            lowest_index,
            current_index,
            &lowest_index_type,
            &mut token_type_stack,
            &mut tokens,
        );

        current_index = lowest_index
            + match lowest_index_type {
                MarkdownTokenType::NexusPointerStart
                | MarkdownTokenType::BoldItalicsStart
                | MarkdownTokenType::BoldItalicsEnd => 3,
                MarkdownTokenType::NexusPointerEnd | MarkdownTokenType::Bold => 2,
                MarkdownTokenType::Italics => 1,
                _ => 0,
            };
    }

    // Add the last bit of the line if its Plain
    if current_index < input.len() {
        tokens.push(MarkdownToken::new(
            MarkdownTokenType::Plain,
            &input[current_index..].to_string(),
        ));
    }

    return tokens;
}
