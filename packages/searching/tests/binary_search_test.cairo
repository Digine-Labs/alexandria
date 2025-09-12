use alexandria_searching::binary_search::binary_search;
use snforge_std::*;

#[test]
fn value_found() {
    let mut arr: Array<u128> = array![100, 200, 300, 400, 500, 600];

    let mut span = arr.span();

    // Test with an even length
    assert(binary_search(span, 100).unwrap() == 0, 'assertion failed');
    assert(binary_search(span, 200).unwrap() == 1, 'assertion failed');
    assert(binary_search(span, 300).unwrap() == 2, 'assertion failed');
    assert(binary_search(span, 400).unwrap() == 3, 'assertion failed');
    assert(binary_search(span, 500).unwrap() == 4, 'assertion failed');
    assert(binary_search(span, 600).unwrap() == 5, 'assertion failed');

    // Odd length
    arr.append(700);
    span = arr.span();
    assert(binary_search(span, 100).unwrap() == 0, 'assertion failed');
    assert(binary_search(span, 200).unwrap() == 1, 'assertion failed');
    assert(binary_search(span, 300).unwrap() == 2, 'assertion failed');
    assert(binary_search(span, 400).unwrap() == 3, 'assertion failed');
    assert(binary_search(span, 500).unwrap() == 4, 'assertion failed');
    assert(binary_search(span, 600).unwrap() == 5, 'assertion failed');
    assert(binary_search(span, 700).unwrap() == 6, 'assertion failed');
}

#[test]
fn value_not_found() {
    let mut arr: Array<u128> = array![100, 200, 300, 400, 500, 600];

    // Test with an even length
    let mut span = arr.span();
    assert(binary_search(span, 20).is_none(), 'value not found');
    assert(binary_search(span, 42000).is_none(), 'value not found');
    assert(binary_search(span, 760).is_none(), 'value not found');

    // Odd length
    arr.append(700); // 6
    span = arr.span();
    assert(binary_search(span, 20).is_none(), 'value not found');
    assert(binary_search(span, 42000).is_none(), 'value not found');
    assert(binary_search(span, 760).is_none(), 'value not found');
}

#[test]
fn value_found_length_one() {
    let span: Span<u128> = array![100].span();
    assert(binary_search(span, 100).unwrap() == 0, 'value was not found')
}

#[test]
fn value_not_found_length_one() {
    let span: Span<u128> = array![100].span();
    assert(binary_search(span, 50).is_none(), 'value was found');
}

#[test]
fn zero_length_span() {
    let span: Span<u128> = array![].span();
    assert(binary_search(span, 100).is_none(), 'value was found');
}
