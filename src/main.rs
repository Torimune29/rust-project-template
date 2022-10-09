use clap::Parser;
// use serde::{Deserialize, Serialize};
// use npm_package_json;
use std::fs::File;
use std::io::BufReader;

// Parserを継承した構造体はArgの代わりに使用することが可能。
#[derive(Debug, Parser)]
#[clap(
    name = env!("CARGO_PKG_NAME"),
    version = env!("CARGO_PKG_VERSION"),
    author = env!("CARGO_PKG_AUTHORS"),
    about = env!("CARGO_PKG_DESCRIPTION"),
)]
struct AppArg {
    // 任意のオプション
    #[clap(short, long)]
    name: Option<String>,

    // 必須のオプション
    #[clap(short = 'c', long = "count")]
    count: i32,

    // 位置引数
    message: String,
}

fn main() {
    let reader = BufReader::new(File::open("package.json").unwrap());
    let deserialized: npm_package_json::Package = serde_json::from_reader(reader).unwrap();
    println!("deserialized = {:?}", deserialized);
    println!("version = {}", deserialized.version);

    let arg: AppArg = AppArg::parse();
    for _ in 0..arg.count {
        println!(
            "{}: {}",
            arg.name.clone().unwrap_or_else(|| String::from("Alice")),
            arg.message
        );
    }
}
