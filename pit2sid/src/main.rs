use std::fs;
use structopt::StructOpt;

#[derive(StructOpt, Debug)]
#[structopt(name = "pit2sid")]
struct Opt {
    #[structopt(short = "i", long = "input")]
    input_path: String,

    #[structopt(short = "o", long = "output")]
    output_path: String,
}

fn convert_pit_to_sid(pit_value: u16) -> u16 {
    let frequency = if pit_value > 0 { 1193180.0 / pit_value as f64 } else { 0.0 };
    let sid_value = (16777216.0 / 985248.0 * frequency as f64) as u16;
    sid_value
}

fn main() {
    let opt = Opt::from_args();

    let input_data: Vec<u8> = fs::read(&opt.input_path).expect("failed to read input data");

    let mut output_data = Vec::new();

    let mut i = 1; // Skip framerate field
    while i < input_data.len() {
        let delta = input_data[i];
        i += 1;

        if delta == 0x00 {
            // End of song
            output_data.push(delta);
            break;
        } else if delta == 0xFF {
            // Loop marker
            output_data.push(delta);
        } else {
            output_data.push(delta);
            let pit_value = (input_data[i + 0] as u16) + ((input_data[i + 1] as u16) << 8);
            let sid_value = convert_pit_to_sid(pit_value);
            output_data.push((sid_value & 0xFF) as u8);
            output_data.push(((sid_value >> 8) & 0xFF) as u8);
            i += 2;
        }
    }

    fs::write(opt.output_path, &output_data).expect("failed to write output data");
}
