use alexandria_ascii::ToAsciiTrait;
use core::num::traits::Bounded;
use snforge_std::*;

#[test]
fn u256_to_ascii() {
    // ------------------------------ max u256 test ----------------------------- //
    // max u256 int in cairo is GitHub Copilot: The maximum u256 number in Cairo is `
    // 115792089237316195423570985008687907853269984665640564039457584007913129639935`.
    let num: u256 = Bounded::MAX;
    let ascii: Array<felt252> = num.to_ascii();
    assert(ascii.len() == 3, 'ascii len should be 3');
    assert(*ascii.at(0) == '1157920892373161954235709850086', 'ascii[0] mismatch');
    assert(*ascii.at(1) == '8790785326998466564056403945758', 'ascii[1] mismatch');
    assert(*ascii.at(2) == '4007913129639935', 'ascii[2] mismatch');
    // ------------------------------ min u256 test ----------------------------- //
    let num: u256 = Bounded::MIN;
    let ascii: Array<felt252> = num.to_ascii();

    assert(ascii.len() == 1, 'ascii len should be 1');
    assert(*ascii.at(0) == '0', 'ascii[0] mismatch');
    // ---------------------------- 31 char u256 test --------------------------- //
    let ascii: Array<felt252> = 1157920892373161954235709850086_u256.to_ascii();
    assert(ascii.len() == 1, 'ascii len should be 1');
    assert(*ascii.at(0) == '1157920892373161954235709850086', 'ascii[0] mismatch');
    // ---------------------------- 62 char u256 test --------------------------- //
    let ascii: Array<felt252> = 11579208923731619542357098500868790785326998466564056403945758_u256
        .to_ascii();
    assert(ascii.len() == 2, 'ascii len should be 2');
    assert(*ascii.at(0) == '1157920892373161954235709850086', 'ascii[0] mismatch');
    assert(*ascii.at(1) == '8790785326998466564056403945758', 'ascii[1] mismatch');
}

#[test]
fn u128_to_ascii() {
    // ------------------------------ max u128 test ----------------------------- //
    // max u128 int in cairo is 340282366920938463463374607431768211455
    let num: u128 = Bounded::MAX;
    let ascii: Array<felt252> = num.to_ascii();

    assert(ascii.len() == 2, 'ascii len should be 2');
    assert(*ascii.at(0) == '3402823669209384634633746074317', 'ascii[0] mismatch');
    assert(*ascii.at(1) == '68211455', 'ascii[1] mismatch');
    // ------------------------------ min u128 test ----------------------------- //
    let num: u128 = Bounded::MIN;
    let ascii: Array<felt252> = num.to_ascii();

    assert(ascii.len() == 1, 'ascii len should be 1');
    assert(*ascii.at(0) == '0', 'ascii[0] mismatch');
    // ---------------------------- 31 char u128 test --------------------------- //
    let ascii: Array<felt252> = 3402823669209384634633746074317_u128.to_ascii();
    assert(ascii.len() == 1, 'ascii len should be 1');
    assert(*ascii.at(0) == '3402823669209384634633746074317', 'ascii[0] mismatch');
}

#[test]
fn u64_to_ascii() {
    // ------------------------------ max u64 test ------------------------------ //
    let num: u64 = Bounded::MAX;
    assert(num.to_ascii() == '18446744073709551615', 'u64 max to_ascii mismatch');
    // ------------------------------ min u64 test ------------------------------ //
    let num: u64 = Bounded::MIN;
    assert(num.to_ascii() == '0', 'u64 min to_ascii mismatch');
}

#[test]
fn u32_to_ascii() {
    // ------------------------------ max u32 test ------------------------------ //
    let num: u32 = Bounded::MAX;
    assert(num.to_ascii() == '4294967295', 'u32 max to_ascii mismatch');
    // ------------------------------ min u32 test ------------------------------ //
    let num: u32 = Bounded::MIN;
    assert(num.to_ascii() == '0', 'u32 min to_ascii mismatch');
}

#[test]
fn u16_to_ascii() {
    // ------------------------------ max u16 test ------------------------------ //
    let num: u16 = Bounded::MAX;
    assert(num.to_ascii() == '65535', 'u16 max to_ascii mismatch');
    // ------------------------------ min u16 test ------------------------------ //
    let num: u16 = Bounded::MIN;
    assert(num.to_ascii() == '0', 'u16 min to_ascii mismatch');
}

#[test]
fn u8_to_ascii() {
    // ------------------------------- max u8 test ------------------------------ //
    let num: u8 = Bounded::MAX;
    assert(num.to_ascii() == '255', 'u8 max to_ascii mismatch');
    // ------------------------------- min u8 test ------------------------------ //
    let num: u8 = Bounded::MIN;
    assert(num.to_ascii() == '0', 'u8 min to_ascii mismatch');
}
