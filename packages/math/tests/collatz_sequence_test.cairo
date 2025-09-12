use alexandria_math::collatz_sequence::sequence;
use snforge_std::*;

#[test]
fn collatz_sequence_10_test() {
    assert(sequence(10).len() == 7, 'assertion failed');
}

#[test]
fn collatz_sequence_15_test() {
    assert(sequence(15).len() == 18, 'assertion failed');
}

#[test]
fn collatz_sequence_empty_test() {
    assert(sequence(0).len() == 0, 'assertion failed');
}
