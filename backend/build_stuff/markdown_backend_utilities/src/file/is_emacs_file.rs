use std::path::Path;
pub fn is_emacs_file(path: &Path) -> bool {
    path.file_name()
        .and_then(|name| name.to_str())
        .map_or(false, |name| {
            name.contains('~') || name.contains('#') || name.contains('*')
        })
}
