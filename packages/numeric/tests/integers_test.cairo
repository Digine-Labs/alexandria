use alexandria_numeric::integers::UIntBytes;
use snforge_std::*;

#[test]
fn test_u32_from_bytes() {
    let input: Array<u8> = array![0xf4, 0x32, 0x15, 0x62];
    let res: Option<u32> = UIntBytes::from_bytes(input.span());

    assert(res.is_some(), 'should have a value');
    assert(res.unwrap() == 0xf4321562, 'assertion failed');
}

#[test]
fn test_u32_from_bytes_too_big() {
    let input: Array<u8> = array![0xf4, 0x32, 0x15, 0x62, 0x01];
    let res: Option<u32> = UIntBytes::from_bytes(input.span());

    assert(res.is_none(), 'should not have a value');
}


#[test]
fn test_u32_to_bytes_full() {
    let input: u32 = 0xf4321562;
    let res: Span<u8> = input.to_bytes();

    assert(res.len() == 4, 'assertion failed');
    assert(*res[0] == 0xf4, 'assertion failed');
    assert(*res[1] == 0x32, 'assertion failed');
    assert(*res[2] == 0x15, 'assertion failed');
    assert(*res[3] == 0x62, 'assertion failed');
}

#[test]
fn test_u32_to_bytes_partial() {
    let input: u32 = 0xf43215;
    let res: Span<u8> = input.to_bytes();

    assert(res.len() == 3, 'assertion failed');
    assert(*res[0] == 0xf4, 'assertion failed');
    assert(*res[1] == 0x32, 'assertion failed');
    assert(*res[2] == 0x15, 'assertion failed');
}


#[test]
fn test_u32_to_bytes_leading_zeros() {
    let input: u32 = 0x00f432;
    let res: Span<u8> = input.to_bytes();

    assert(res.len() == 2, 'assertion failed');
    assert(*res[0] == 0xf4, 'assertion failed');
    assert(*res[1] == 0x32, 'assertion failed');
}
