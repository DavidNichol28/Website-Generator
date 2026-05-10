use build_process::build_process::build_process_handler::build_handler;
use std::fs;
use std::path::Path;
use std::process::Command;

pub fn build(target_location: &Path, output_dir: &Path, build_command: &str) -> String {
    build_handler(target_location, output_dir, build_command);

    return String::from("build is done");
}

pub fn launch(build_directory: &Path, build_command: &str) {
    // let build_command = format!("run {} {}", build_directory.display(), build_command);
    println!("build_command: {}", build_command);
    println!("build_directory: {:#?}", build_directory);
    let status = Command::new("flutter")
        .args(&build_command.split_whitespace().collect::<Vec<&str>>())
        .current_dir(build_directory)
        .status()
        .expect("Failed to run Flutter build");

    if !status.success() {
        panic!("Flutter run failed");
    }
}
