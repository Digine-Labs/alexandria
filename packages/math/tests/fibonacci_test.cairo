use alexandria_math::fibonacci::fib;
use snforge_std::*;

#[test]
fn fibonacci_test() {
    assert(fib(0, 1, 10) == 55, 'assertion failed');
    assert(fib(2, 4, 8) == 110, 'assertion failed');
}
