use alexandria_math::fast_power::{fast_power, fast_power_mod};
use snforge_std::*;

#[test]
fn fast_power_test() {
    assert(fast_power(2_u128, 1_u128) == 2, 'assertion failed');
    assert(fast_power(2_u128, 2_u128) == 4, 'assertion failed');
    assert(fast_power(2_u128, 3_u128) == 8, 'assertion failed');
    assert(fast_power(3_u128, 4_u128) == 81, 'assertion failed');
    assert(fast_power(2_u128, 100_u128) == 0x10000000000000000000000000, 'assertion failed');
    assert(fast_power(2_u128, 127_u128) == 0x80000000000000000000000000000000, 'assertion failed');

    assert(fast_power(2_u256, 128_u256) == 0x100000000000000000000000000000000, 'assertion failed');

    assert(
        fast_power(
            2_u256, 255_u256,
        ) == 0x8000000000000000000000000000000000000000000000000000000000000000,
        'invalid result',
    );
}

#[test]
fn fast_power_mod_test() {
    assert(fast_power_mod(2_u128, 1_u128, 17_u128) == 2, 'assertion failed');
    assert(fast_power_mod(2_u128, 2_u128, 17_u128) == 4, 'assertion failed');
    assert(fast_power_mod(2_u128, 3_u128, 17_u128) == 8, 'assertion failed');
    assert(fast_power_mod(3_u128, 4_u128, 17_u128) == 13, 'assertion failed');
    assert(fast_power_mod(2_u128, 100_u128, 1000000007_u128) == 976371285, 'assertion failed');
    assert(
        fast_power_mod(
            2_u128, 127_u128, 340282366920938463463374607431768211454_u128,
        ) == 170141183460469231731687303715884105728,
        'assertion failed',
    );
    assert(
        fast_power_mod(2_u128, 127_u128, 34028236692093846346337460743176821144_u128) == 8,
        'assertion failed',
    );

    assert(fast_power_mod(2_u128, 128_u128, 9299_u128) == 1412, 'assertion failed');

    assert(
        fast_power_mod(
            2_u128, 88329_u128, 34028236692093846346337460743176821144_u128,
        ) == 2199023255552,
        'assertion failed',
    );
}
