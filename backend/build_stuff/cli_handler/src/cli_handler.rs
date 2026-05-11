use clap::Parser;
use dialoguer::{Input, Select};
use std::env;
use std::fmt::Display;
use std::io::{self, Write};
use std::path::PathBuf;
use std::str::FromStr;
#[derive(Parser, Debug)]
#[command(
    name = "builder",
    version = "1.0",
    about = "Handles program building with optional parameters"
)]
pub struct Cli {
    #[arg(short, long)]
    target: Option<PathBuf>,

    #[arg(short, long)]
    output: Option<PathBuf>,

    #[arg(short, long)]
    command: Option<String>,
}

fn get_program_data() -> (PathBuf, PathBuf, String) {
    let project_root = env::current_dir().unwrap().to_string_lossy().into_owned();
    println!("project_root: {}", &project_root);
    let cli = Cli::parse();

    let mut frontend = project_root.clone();
    frontend.push_str("/frontend/demo_websites/website_generator");
    //frontend.push_str("/frontend/demo_websites/rebuild_forge");

    let target_location = interactive_input("Target location", cli.target, frontend.into(), |v| {
        v.display().to_string()
    });

    let mut build_path = project_root.clone();
    build_path.push_str("/backend/test_launch");

    let build_location = interactive_input("Build location", cli.output, build_path.into(), |v| {
        v.display().to_string()
    });

    let build_command_raw = interactive_input(
        "Build command",
        cli.command,
        String::from("run -d chrome"),
        |v| v.clone(),
    );

    let build_command = if build_command_raw.trim() == "build" {
        String::from("build web")
    } else {
        build_command_raw
    };
    return (target_location, build_location, build_command);
}
pub fn handle_cli() {
    let (target_location, build_location, build_command) = get_program_data();

    let program_manager_message: String =
        program_manager::build(&target_location, &build_location, &build_command);
    // Make a nice countdown
    fancy_blocking_countdown(3);
    program_manager::launch(&build_location, &build_command);
}
fn fancy_blocking_countdown(seconds: u8) {
    println!("beginning launch in...");
    // Multiply seconds by 4 so it does quarter-second updates to look smoother
    for second in 0..seconds * 4 {
        // See if full second
        if (second % 4 == 0) {
            // Current second count
            print!("{}", seconds - (second / 4));
        } else {
            // Drop a dot for an elipses effect on the same line
            print!(".");
            if (second % 4 == 3) {
                // Makes new line after before next number is printed
                println!("");
            }
        }
        // Forces text to output
        io::stdout().flush().unwrap();
        // 250 for handling each line with 4 outputs in one second
        std::thread::sleep(std::time::Duration::from_millis(250));
    }
}

fn interactive_input<T, F>(label: &str, passed: Option<T>, default: T, display: F) -> T
where
    T: Clone + FromStr,
    <T as FromStr>::Err: Display + std::fmt::Debug,
    F: Fn(&T) -> String,
{
    match passed {
        Some(val) => {
            let options = vec![
                format!("Use passed: {}", display(&val)),
                format!("Use default: {}", display(&default)),
                "Enter new value".to_string(),
            ];
            let choice = Select::new()
                .with_prompt(format!("{}:", label))
                .items(&options)
                .default(0)
                .interact()
                .unwrap();
            match choice {
                0 => val,
                1 => default,
                _ => Input::<String>::new()
                    .with_prompt("Enter new value")
                    .interact_text()
                    .unwrap()
                    .parse::<T>()
                    .expect("Invalid input"),
            }
        }
        None => {
            let options = vec![
                format!("Use default: {}", display(&default)),
                "Enter new value".to_string(),
            ];
            let choice = Select::new()
                .with_prompt(format!("{}:", label))
                .items(&options)
                .default(0)
                .interact()
                .unwrap();
            match choice {
                0 => default,
                _ => Input::<String>::new()
                    .with_prompt("Enter value")
                    .interact_text()
                    .unwrap()
                    .parse::<T>()
                    .expect("Invalid input"),
            }
        }
    }
}
