use clap::{Parser, Subcommand};
use lib::framework::Framework;
use std::path::PathBuf;
#[derive(Parser)]
#[command(author, version, about, long_about = None)]
struct Cli {
    #[command(subcommand)]
    command: Option<Commands>,
}

#[derive(Subcommand)]
enum Commands {
    Translate {
        #[arg(short = "i", long)]
        input: PathBuf,
        #[arg(short = "o", long)]
        output: PathBuf,
        #[arg(short = "f", long)]
        framework: Framework,
    },
    BuildTypes {
        #[arg(short = "o", long)]
        output: PathBuf,
    },
}

async fn main() -> std::io::Result<()> {
    let cli = Cli::parse();

    match &cli.command {
        Some(Commands::Translate {
            input,
            output,
            framework,
        }) => Ok(()),
        Some(Commands::BuildTypes { output }) => Ok(()),
        None => {
            // Default behavior if no subcommand is provided
            println!("No command provided. Use --help for more information.");
            Ok(())
        }
    }
}
