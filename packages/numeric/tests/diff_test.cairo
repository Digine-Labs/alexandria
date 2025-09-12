use alexandria_numeric::diff::diff;
use snforge_std::*;

#[test]
fn diff_test() {
    let xs = array![3, 5, 7];
    let ys = diff(xs.span());
    assert(*ys[0] == 0_u256, 'assertion failed');
    assert(*ys[1] == *xs[1] - *xs[0], 'assertion failed');
    assert(*ys[2] == *xs[2] - *xs[1], 'assertion failed');
}

#[test]
#[should_panic(expected: ('Sequence must be sorted',))]
fn diff_test_revert_not_sorted() {
    let xs: Array<u128> = array![3, 2];
    diff(xs.span());
}

#[test]
#[should_panic(expected: ('Array must have at least 1 elt',))]
fn diff_test_revert_empty() {
    let xs: Array<u128> = array![];
    diff(xs.span());
}
