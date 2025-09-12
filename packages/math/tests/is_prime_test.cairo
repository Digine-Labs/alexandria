use alexandria_math::is_prime::is_prime;
use snforge_std::*;

#[test]
fn is_prime_test_1() {
    assert(is_prime(2, 10), 'assertion failed');
}

#[test]
fn is_prime_test_2() {
    assert(!is_prime(0, 10), 'assertion failed');
}

#[test]
fn is_prime_test_3() {
    assert(!is_prime(1, 10), 'assertion failed');
}

#[test]
fn is_prime_test_4() {
    assert(is_prime(97, 10), 'assertion failed');
}
