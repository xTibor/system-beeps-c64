use std::fs;

use image::{GenericImageView, Pixel};
use structopt::StructOpt;

#[derive(StructOpt, Debug)]
#[structopt(name = "img2font")]
struct Opt {
    #[structopt(short = "i", long = "input")]
    input_path: String,

    #[structopt(short = "o", long = "output")]
    output_path: String,
}

fn main() {
    let opt = Opt::from_args();

    let input = image::open(opt.input_path).expect("failed to open input image");

    let tile_width = 8;
    let tile_height = 8;

    if input.width() % tile_width != 0 {
        panic!("width % tile_width");
    } else if input.height() % tile_height != 0 {
        panic!("height % tile_height");
    }

    let width = input.width() / tile_width;
    let height = input.height() / tile_height;

    let mut output_data = Vec::new();

    for tile_y in 0..height {
        for tile_x in 0..width {
            for tile_row in 0..tile_height {
                let mut value = 0;
                for tile_col in 0..tile_width {
                    let px = tile_x * tile_width + tile_col;
                    let py = tile_y * tile_height + tile_row;
                    if input.get_pixel(px, py).to_rgb() != image::Rgb([0, 0, 0]) {
                        value |= (0x01 << (tile_width - 1)) >> tile_col;
                    }
                }
                output_data.push(value);
            }
        }
    }

    fs::write(opt.output_path, &output_data).expect("failed to write output data");
}
