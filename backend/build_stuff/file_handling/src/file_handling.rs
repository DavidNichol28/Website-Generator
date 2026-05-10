pub mod file_handling {
    use markdown_element_lib::{
        markdown_line_element::{MarkdownLineElement, MarkdownLineElementType},
        markdown_page::MarkdownPage,
    };
    use std::collections::HashMap;
    use std::fs;
    use std::fs::{File, OpenOptions};
    use std::io::{self, BufRead, Write};
    use std::path::Path;
    use std::path::PathBuf;

    pub fn collect_asset_directories(
        base_dir: &Path,
        relative_path: &str,
        asset_list: &mut Vec<String>,
    ) {
        if let Ok(entries) = fs::read_dir(base_dir) {
            for entry in entries.flatten() {
                let path = entry.path();
                if path.is_dir() {
                    let new_relative_path = format!(
                        "{}/{}",
                        relative_path,
                        path.file_name().unwrap().to_string_lossy()
                    );
                    asset_list.push(format!("    - assets/{}/", new_relative_path));
                    collect_asset_directories(&path, &new_relative_path, asset_list);
                }
            }
        }
    }

    pub fn handle_config_details_update(
        parsed_lines: &Vec<MarkdownLineElement>,
        config_details: &mut HashMap<String, HashMap<String, String>>,
        // HERE IT IS!
        output_path: &str,
        file_name: &str,
    ) {
        let current_config_details = get_config_details_from_parsed_lines(&parsed_lines);
        for current_config_detail in current_config_details {
            if !config_details.contains_key(&current_config_detail.0) {
                let mut inner_current_config_details = HashMap::new();

                inner_current_config_details
                    .insert(current_config_detail.1, output_path.to_string());

                config_details.insert(current_config_detail.0, inner_current_config_details);
            } else {
                if let Some(val) = config_details.get_mut(&current_config_detail.0) {
                    val.insert(
                        current_config_detail.1,
                        format!(
                            "{}/{}",
                            output_path.to_string(),
                            file_name
                                .to_string()
                                .strip_suffix(".md")
                                .unwrap_or(&file_name.to_string())
                                .to_string(),
                        ),
                    );
                }
            }
        }
    }

    fn get_config_details_from_parsed_lines(
        parsed_lines: &Vec<MarkdownLineElement>,
    ) -> Vec<(String, String)> {
        let mut return_list: Vec<(String, String)> = vec![];
        for parsed_line in parsed_lines {
            if parsed_line.line_type == MarkdownLineElementType::ConfigVariable {
                let string: String = parsed_line.markdown[0].get_string().unwrap();
                let string_subsections: Vec<&str> = string.split('=').collect();
                return_list.push((
                    string_subsections[0].to_string(),
                    string_subsections[1][1..string_subsections[1].len() - 1].to_string(),
                ));
            }
        }
        return return_list;
    }
    pub fn modify_pubspec(path: &Path, new_lines: Vec<String>) -> io::Result<()> {
        let file = File::open(path)?;
        let reader = io::BufReader::new(file);

        let mut lines: Vec<String> = Vec::new();

        // Read through the file
        for line in reader.lines() {
            let line = line?;

            if line.contains("assets:") {
                lines.push(line); // Keep the 'assets:' line
                lines.push(String::from("    - assets/processed_data/"));
                for new_line in &new_lines {
                    lines.push(new_line.to_owned());
                }
                break;
            } else {
                lines.push(line);
            }
        }

        // Open the file again for writing (overwrite the file)
        let mut file = OpenOptions::new().write(true).truncate(true).open(path)?;

        // Write the modified lines back to the file
        for line in lines.iter() {
            writeln!(file, "{}", line)?;
        }

        Ok(())
    }

    pub fn handle_storage(output_data: MarkdownPage, output_file_location: PathBuf) {
        let output_data =
            serde_json::to_string_pretty(&output_data).expect("Failed to serialize to JSON");
        fs::write(output_file_location, output_data).expect("Failed to write JSON to file");
    }
}
