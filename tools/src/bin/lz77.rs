use std::fs;

use gba_compression::bios::compress_lz77;
use structopt::StructOpt;

#[derive(StructOpt, Debug)]
#[structopt(name = "lz77")]
struct Opt {
    #[structopt(short = "i", long = "input")]
    input_path: String,

    #[structopt(short = "o", long = "output")]
    output_path: String,
}

fn main() {
    let opt = Opt::from_args();

    let input_data: Vec<u8> = fs::read(&opt.input_path).expect("failed to read input data");
    let output_data = compress_lz77(&input_data, false).expect("failed to compress input data");

    fs::write(opt.output_path, &output_data).expect("failed to write output data");
}
