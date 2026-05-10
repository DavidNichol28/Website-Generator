pub fn extract_file_name_from_path(file_path: String) -> String {
    // Get index of last '/'
    let relative_path_reversed_index = file_path.chars().rev().position(|x| x == '/').unwrap();
    // Unreverse index
    let relative_path_start_index = file_path.len() - relative_path_reversed_index;
    // Return slice that is text after last slash
    return String::from(&file_path[relative_path_start_index..]);
}
