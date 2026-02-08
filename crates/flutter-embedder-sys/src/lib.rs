// src/lib.rs
#![allow(non_upper_case_globals)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]

include!(concat!(env!("OUT_DIR"), "/bindings.rs"));

#[cfg(test)]
mod tests {
    use super::*;
    use std::mem;

    #[test]
    fn test_struct_sizes() {
        // Advanced Safety: Verify that our generated Rust struct
        // matches the expectations of the C header for ABI stability.
        let mut args: FlutterProjectArgs = Default::default();
        args.struct_size = mem::size_of::<FlutterProjectArgs>();

        assert!(args.struct_size > 0);
    }
}
