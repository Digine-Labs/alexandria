use alexandria_linalg::kron::{KronError, kron};
use snforge_std::*;

#[test]
fn kron_product_test() {
    let xs = array![1_u64, 10, 100];
    let ys = array![5, 6, 7];
    let zs = kron(xs.span(), ys.span()).unwrap();
    assert(*zs[0] == 5, 'assertion failed');
    assert(*zs[1] == 6, 'assertion failed');
    assert(*zs[2] == 7, 'assertion failed');
    assert(*zs[3] == 50, 'assertion failed');
    assert(*zs[4] == 60, 'assertion failed');
    assert(*zs[5] == 70, 'assertion failed');
    assert(*zs[6] == 500, 'assertion failed');
    assert(*zs[7] == 600, 'assertion failed');
    assert(*zs[8] == 700, 'assertion failed');
}

#[test]
fn kron_product_test_check_len() {
    let xs = array![1_u64];
    let ys = array![];
    assert(kron(xs.span(), ys.span()) == Result::Err(KronError::UnequalLength), 'assertion failed');
}
