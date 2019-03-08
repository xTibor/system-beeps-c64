use std::fs;
use std::cmp;
use structopt::StructOpt;

#[derive(StructOpt, Debug)]
#[structopt(name = "lzss")]
struct Opt {
    #[structopt(short = "i", long = "input")]
    input_path: String,

    #[structopt(short = "o", long = "output")]
    output_path: String,
}

pub fn same_count<T: Eq>(buf1: &[T], buf2: &[T], max_length: usize) -> usize {
    let mut i = 0;
    while (i < buf1.len()) && (i < buf2.len()) && (i < max_length) && (buf1[i] == buf2[i]) {
        i += 1;
    }
    i
}

fn main() {
    let opt = Opt::from_args();

    let input_data: Vec<u8> = fs::read(&opt.input_path).expect("failed to read input data");
    let mut output_data = Vec::new();

    let mut i = 0;
    while i < input_data.len() {
        // TODO
        let len = cmp::min(127, input_data.len() - i);
        output_data.push(0x00 | len as u8);

        for n in 0..len {
            output_data.push(input_data[i + n]);
        }

        i += len;
        //
    }

    output_data.push(0);

    fs::write(opt.output_path, &output_data).expect("failed to write output data");
}
