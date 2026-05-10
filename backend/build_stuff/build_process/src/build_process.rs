pub mod build_process_handler {

    use file_handling::file_handling::file_handling::{
        collect_asset_directories, handle_config_details_update, handle_storage, modify_pubspec,
    };
    use markdown_backend_utilities::{
        data_processing::merge_json::merge_json,
        file::{file_name_extractor, is_emacs_file::is_emacs_file},
    };
    use markdown_element_lib::{
        markdown_line_element::MarkdownLineElement, markdown_page::MarkdownPage,
    };
    use serde_json::Value;
    use std::collections::HashMap;
    use std::fs;
    use std::io::BufRead;
    use std::path::Path;

    pub fn build_handler(target_location: &Path, output_dir: &Path, build_command: &str) {
        // Check target_location exists
        if !target_location.exists() {
            panic!("Target location does not exist: {:?}", target_location);
        }

        let build_dir_string = &format!(
            "{}{}",
            output_dir.to_string_lossy(),
            "/assets/processed_data/"
        );
        let build_dir: &Path = Path::new(&build_dir_string);

        // Ensure we are not setting the output directory inside itself
        if target_location == build_dir {
            panic!("Target location cannot be 'processed_data/' itself.");
        }

        // Remove existing build
        if build_dir.exists() {
            fs::remove_dir_all(&build_dir).expect(
                format!(
                    "Failed to delete existing processed_data directory in {:#?}",
                    target_location
                )
                .as_str(),
            );
        }

        // Create new build direcory
        fs::create_dir_all(&build_dir).expect("Failed to create output directory");

        let mut config_details: HashMap<String, HashMap<String, String>> = HashMap::new();
        let mut additional_config_details: HashMap<String, HashMap<String, Vec<String>>> =
            HashMap::new();
        additional_config_details.insert(
            "actionWidgetCallbackValuesListsMap".to_string(),
            HashMap::new(),
        );
        additional_config_details.insert("actionWidgetStringsListsMap".to_string(), HashMap::new());
        // Recursively processes md tree at target_location into toml tree at build_dir for Flutter to build with
        process_directory(
            &target_location,
            &target_location,
            &build_dir,
            &mut config_details,
            &mut additional_config_details,
        );

        // Serialize config_details into JSON format
        let config_details_json = serde_json::to_string(&config_details)
            .expect("Failed to serialize config_details to JSON");
        let additional_config_details_json = serde_json::to_string(&additional_config_details)
            .expect("Failed to serialize additional_config_details to JSON");

        // Define the output path for the JSON file
        let config_details_output_path = build_dir.join("nexus_key_config.json");

        // Write the serialized JSON to the file
        fs::write(
            config_details_output_path,
            serde_json::to_string(&merge_json(
                &config_details_json,
                &additional_config_details_json,
            ))
            .unwrap(),
        )
        .expect("Failed to write config_details JSON to file");

        // Get list of all subdirectories to put in
        // assets file (pubspec.yaml)because Flutter
        // is annoying with its build system
        let mut list_of_nested_directory_locations: Vec<String> = vec![];
        collect_asset_directories(
            build_dir,
            "processed_data",
            &mut list_of_nested_directory_locations,
        );

        // Write over the existing pubspec.yaml with
        // the old assets locations removed and new
        // ones added
        let _ = modify_pubspec(
            &output_dir.join("pubspec.yaml"),
            list_of_nested_directory_locations,
        );

        // build_and_launch_flutter(output_dir, build_command);
        println!(
            "build_and_launch_flutter(\noutput_dir={},\nbuild_command={}",
            output_dir.display(),
            build_command
        );
    }

    fn process_directory(
        // Original Dir is needed to prevent copying the same substring showing where the root is every single time when using input_dir as key
        original_dir: &Path,
        input_dir: &Path,
        output_dir: &Path,
        config_details: &mut HashMap<String, HashMap<String, String>>,
        additional_config_details: &mut HashMap<String, HashMap<String, Vec<String>>>,
    ) {
        if input_dir
            .file_name()
            .map_or(false, |name| name == "markdown_to_flutter_build_output")
        {
            return;
        }
        let output_key: String = input_dir
            .strip_prefix(original_dir)
            .map(|p| p.to_string_lossy().into_owned())
            .unwrap_or_else(|_| input_dir.to_string_lossy().into_owned());

        if let Some(map) = additional_config_details.get_mut("actionWidgetStringsListsMap") {
            map.insert(output_key.to_string(), vec![]);
        }
        if let Some(map) = additional_config_details.get_mut("actionWidgetCallbackValuesListsMap") {
            map.insert(output_key.to_string(), vec![]);
        }

        // Get and go through files in directory
        for entry in fs::read_dir(input_dir).expect("Failed to read directory") {
            // Get file
            let entry = entry.expect("Failed to get directory entry");
            // File path
            let path = entry.path();

            // Ensure we are not processing anything inside processed_data itself
            if path.starts_with(&output_dir) {
                continue;
            }

            // Get the text after the last slash
            // Path => String
            let file_name = file_name_extractor::extract_file_name_from_path(
                path.to_string_lossy().to_string(),
            );

            // Where the file is going to be saved
            let output_path = output_dir.join(&file_name);

            // Check if directory
            if path.is_dir() {
                // Make directory
                fs::create_dir_all(&output_path).expect(&format!(
                    "Failed to create output directory: {:#?}",
                    &output_path
                ));

                // Recurse for current directory
                process_directory(
                    &original_dir,
                    &path,
                    &output_path,
                    config_details,
                    additional_config_details,
                );
            }
            // Is a file
            else if let Some(extension) = path.extension() {
                // Not a file to be ignored
                if !(extension == "md" || extension == "json") || is_emacs_file(&path) {
                    continue;
                }

                let content = match fs::read_to_string(&path) {
                    Ok(file_content) => file_content,
                    Err(e) => {
                        if (extension == "json") {
                            panic!(
                                "JSON formatting error in file: {:#?}\nERR MSG:\n{}",
                                path, e
                            );
                        } else {
                            panic!("Error opening md file: {}", e);
                        }
                    }
                };

                match extension.to_str().unwrap() {
                    "md" => {
                        let parsed_lines = MarkdownLineElement::parse_markdown(&content);
                        handle_config_details_update(
                            &parsed_lines,
                            config_details,
                            &output_key,
                            &file_name,
                        );

                        handle_storage(
                            MarkdownPage {
                                title: file_name.clone(),
                                content: parsed_lines.clone().to_vec(),
                            },
                            output_path.with_extension("json"),
                        );
                    }
                    "json" => {
                        let parsed_json: Value = serde_json::from_str(&content)
                            .expect(&format!("Failed to parse JSON file: {:#?}", output_dir));

                        for (section, items) in
                            parsed_json.as_object().expect("JSON is not an object")
                        {
                            if let Some(array) = items.as_array() {
                                println!("Section: {}", section);

                                for item in array {
                                    if let Some(obj) = item.as_object() {
                                        println!("HERR {:#?}", obj);

                                        if let Some(map) = additional_config_details
                                            .get_mut("actionWidgetCallbackValuesListsMap")
                                        {
                                            if let Some(val) = map.get_mut(&output_key) {
                                                if let Some(location) =
                                                    obj.get("location").and_then(|v| v.as_str())
                                                {
                                                    val.push(location.to_string());
                                                }
                                            }
                                        }

                                        if let Some(map) = additional_config_details
                                            .get_mut("actionWidgetStringsListsMap")
                                        {
                                            if let Some(val) = map.get_mut(&output_key) {
                                                if let Some(title) =
                                                    obj.get("title").and_then(|v| v.as_str())
                                                {
                                                    val.push(title.to_string());
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        fs::write(output_path.with_extension("json"), content)
                            .expect("Failed to write config JSON to file");
                    }
                    _ => {
                        panic!("What the fuck? We're only supposed to have md and json files!")
                    }
                };
            }
        }
    }
}
