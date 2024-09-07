#[allow(warnings)]
mod bindings;

//use bindings::exports::example::calculator::calculate::Guest;

use bindings::{example::adder::add::add, exports::example::calculator::calculate::Guest};

struct Example;

impl Guest for Example {
    fn add_number(x: u32, y: u32) -> u32 {
        add(x, y)
        //x + y
    }
}

bindings::export!(Example with_types_in bindings);
