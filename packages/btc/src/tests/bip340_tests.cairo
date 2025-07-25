use core::byte_array::ByteArrayTrait;
use starknet::secp256_trait::Signature;
use crate::bip340::verify;

impl U256IntoByteArray of Into<u256, ByteArray> {
    fn into(self: u256) -> ByteArray {
        let mut ba = Default::default();
        ba.append_word(self.high.into(), 16);
        ba.append_word(self.low.into(), 16);
        ba
    }
}

// test data adapted from: https://github.com/bitcoin/bips/blob/master/bip-0340/test-vectors.csv

#[test]
fn test_verify_zero_message() {
    let px: u256 = 0xf9308a019258c31049344f85f89d5229b531c845836f99b08601f113bce036f9;
    let rx: u256 = 0xe907831f80848d1069a5371b402410364bdf1c5f8307b0084c55f1ce2dca8215;
    let s: u256 = 0x25f66a4a85ea8b71e482a74f382d2ce5ebeee8fdb2172f477df4900d310536c0;
    let m: u256 = 0x0;
    assert!(verify(px, rx, s, m.into()));
}

#[test]
fn test_verify_basic_signature() {
    let px: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
    let rx: u256 = 0x6896bd60eeae296db48a229ff71dfe071bde413e6d43f917dc8dcf8c78de3341;
    let s: u256 = 0x8906d11ac976abccb20b091292bff4ea897efcb639ea871cfa95f6de339e4b0a;
    let m: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;
    assert!(verify(px, rx, s, m.into()));
}

#[test]
fn test_verify_another_valid_signature() {
    let px: u256 = 0xdd308afec5777e13121fa72b9cc1b7cc0139715309b086c960e18fd969774eb8;
    let rx: u256 = 0x5831aaeed7b44bb74e5eab94ba9d4294c49bcf2a60728d8b4c200f50dd313c1b;
    let s: u256 = 0xab745879a5ad954a72c45a91c3a51d3c7adea98d82f8481e0e1e03674a6f3fb7;
    let m: u256 = 0x7e2d58d8b3bcdf1abadec7829054f90dda9805aab56c77333024b9d0a508b75c;

    assert!(verify(px, rx, s, m.into()));
}

#[test]
fn test_verify_max_message() {
    let px: u256 = 0x25d1dff95105f5253c4022f628a996ad3a0d95fbf21d468a1b33f8c160d8f517;
    let rx: u256 = 0x7eb0509757e246f19449885651611cb965ecc1a187dd51b64fda1edc9637d5ec;
    let s: u256 = 0x97582b9cb13db3933705b32ba982af5af25fd78881ebb32771fc5922efc66ea3;
    let m: u256 = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

    assert!(verify(px, rx, s, m.into()));
}

#[test]
fn test_verify_truncated_rx() {
    let px: u256 = 0xd69c3509bb99e412e68b0fe8544e72837dfa30746d8be2aa65975f29d22dc7b9;
    let rx: u256 = 0x3b78ce563f89a0ed9414f5aa28ad0d96d6795f9c63;
    let s: u256 = 0x76afb1548af603b3eb45c9f8207dee1060cb71c04e80f593060b07d28308d7f4;
    let m: u256 = 0x4df3c3f68fcc83b27e9d42c90431a72499f17875c81a599b566c9889b9696703;

    assert!(verify(px, rx, s, m.into()));
}

#[test]
fn test_invalid_public_key_not_on_curve() {
    // public key not on the curve
    let px: u256 = 0xeefdea4cdb677750a420fee807eacf21eb9898ae79b9768766e4faa04a2d4a34;
    let rx: u256 = 0x6cff5c3ba86c69ea4b7376f31a9bcb4f74c1976089b2d9963da2e5543e177769;
    let s: u256 = 0x69e89b4c5564d00349106b8497785dd7d1d713a8ae82b32fa79d5f7fc407d39b;
    let m: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;
    assert_eq!(verify(px, rx, s, m.into()), false);
}

#[test]
fn test_invalid_odd_y_coordinate() {
    // has_even_y(R) is false
    let px: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
    let rx: u256 = 0xfff97bd5755eeea420453a14355235d382f6472f8568a18b2f057a1460297556;
    let s: u256 = 0x3cc27944640ac607cd107ae10923d9ef7a73c643e166be5ebeafa34b1ac553e2;
    let m: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;

    assert_eq!(verify(px, rx, s, m.into()), false);
}

#[test]
fn test_invalid_negated_message() {
    // negated message
    let px: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
    let rx: u256 = 0x1fa62e331edbc21c394792d2ab1100a7b432b013df3f6ff4f99fcb33e0e1515f;
    let s: u256 = 0x28890b3edb6e7189b630448b515ce4f8622a954cfe545735aaea5134fccdb2bd;
    let m: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;

    assert_eq!(verify(px, rx, s, m.into()), false);
}

#[test]
fn test_invalid_negated_s_value() {
    // negated s value
    let px: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
    let rx: u256 = 0x6cff5c3ba86c69ea4b7376f31a9bcb4f74c1976089b2d9963da2e5543e177769;
    let s: u256 = 0x961764b3aa9b2ffcb6ef947b6887a226e8d7c93e00c5ed0c1834ff0d0c2e6da6;
    let m: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;

    assert_eq!(verify(px, rx, s, m.into()), false);
}

#[test]
fn test_invalid_infinite_point_zero_x() {
    // sG - eP is infinite. Test fails in single verification if has_even_y(inf) is defined as
    // true and x(inf) as 0
    let px: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
    let rx: u256 = 0x0;
    let s: u256 = 0x123dda8328af9c23a94c1feecfd123ba4fb73476f0d594dcb65c6425bd186051;
    let m: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;

    assert_eq!(verify(px, rx, s, m.into()), false);
}

#[test]
fn test_invalid_infinite_point_one_x() {
    // sG - eP is infinite. Test fails in single verification if has_even_y(inf) is defined as
    // true and x(inf) as 1
    let px: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
    let rx: u256 = 0x1;
    let s: u256 = 0x7615fbaf5ae28864013c099742deadb4dba87f11ac6754f93780d5a1837cf197;
    let m: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;

    assert_eq!(verify(px, rx, s, m.into()), false);
}

#[test]
fn test_invalid_rx_not_on_curve() {
    // sig[0:32] is not an X coordinate on the curve
    let px: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
    let rx: u256 = 0x4a298dacae57395a15d0795ddbfd1dcb564da82b0f269bc70a74f8220429ba1d;
    let s: u256 = 0x69e89b4c5564d00349106b8497785dd7d1d713a8ae82b32fa79d5f7fc407d39b;
    let m: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;
    assert_eq!(verify(px, rx, s, m.into()), false);
}

#[test]
fn test_invalid_rx_equals_field_size() {
    // sig[0:32] is equal to field size
    let px: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
    let rx: u256 = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f;
    let s: u256 = 0x69e89b4c5564d00349106b8497785dd7d1d713a8ae82b32fa79d5f7fc407d39b;
    let m: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;
    assert_eq!(verify(px, rx, s, m.into()), false);
}

#[test]
fn test_invalid_s_equals_curve_order() {
    // sig[32:64] is equal to curve order
    let px: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
    let rx: u256 = 0x6cff5c3ba86c69ea4b7376f31a9bcb4f74c1976089b2d9963da2e5543e177769;
    let s: u256 = 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141;
    let m: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;
    assert_eq!(verify(px, rx, s, m.into()), false);
}

#[test]
fn test_invalid_pubkey_exceeds_field_size() {
    // public key is not a valid X coordinate because it exceeds the field size
    let px: u256 = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc30;
    let rx: u256 = 0x6cff5c3ba86c69ea4b7376f31a9bcb4f74c1976089b2d9963da2e5543e177769;
    let s: u256 = 0x69e89b4c5564d00349106b8497785dd7d1d713a8ae82b32fa79d5f7fc407d39b;
    let m: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;
    assert_eq!(verify(px, rx, s, m.into()), false);
}

#[test]
fn test_verify_empty_message() {
    // message of size 0
    let px: u256 = 0x778caa53b4393ac467774d09497a87224bf9fab6f6e68b23086497324d6fd117;
    let rx: u256 = 0x71535db165ecd9fbbc046e5ffaea61186bb6ad436732fccc25291a55895464cf;
    let s: u256 = 0x6069ce26bf03466228f19a3a62db8a649f2d560fac652827d1af0574e427ab63;
    let m = "";
    assert!(verify(px, rx, s, m));
}

#[test]
fn test_verify_one_byte_message() {
    // message of size 1
    let px: u256 = 0x778caa53b4393ac467774d09497a87224bf9fab6f6e68b23086497324d6fd117;
    let rx: u256 = 0x8a20a0afef64124649232e0693c583ab1b9934ae63b4c3511f3ae1134c6a303;
    let s: u256 = 0xea3173bfea6683bd101fa5aa5dbc1996fe7cacfc5a577d33ec14564cec2bacbf;
    let m = "\x11";
    assert!(verify(px, rx, s, m));
}

#[test]
fn test_verify_seventeen_byte_message() {
    // message of size 17
    let px: u256 = 0x778caa53b4393ac467774d09497a87224bf9fab6f6e68b23086497324d6fd117;
    let rx: u256 = 0x5130f39a4059b43bc7cac09a19ece52b5d8699d1a71e3c52da9afdb6b50ac370;
    let s: u256 = 0xc4a482b77bf960f8681540e25b6771ece1e5a37fd80e5a51897c5566a97ea5a5;
    let m = "\x01\x02\x03\x04\x05\x06\x07\x08\t\n\x0b\x0c\r\x0e\x0f\x10\x11";

    assert!(verify(px, rx, s, m));
}

#[test]
fn test_verify_hundred_byte_message() {
    // message of size 100
    let px: u256 = 0x778caa53b4393ac467774d09497a87224bf9fab6f6e68b23086497324d6fd117;
    let rx: u256 = 0x403b12b0d8555a344175ea7ec746566303321e5dbfa8be6f091635163eca79a8;
    let s: u256 = 0x585ed3e3170807e7c03b720fc54c7b23897fcba0e9d0b4a06894cfd249f22367;

    let mut m: ByteArray = Default::default();
    let mut nines: ByteArray =
        0x9999999999999999999999999999999999999999999999999999999999999999_u256
        .into();
    m.append(@nines);
    m.append(@nines);
    m.append(@nines);
    m.append_byte(0x99);
    m.append_byte(0x99);
    m.append_byte(0x99);
    m.append_byte(0x99);

    assert!(verify(px, rx, s, m));
}

#[test]
fn test_verify_real_world_joyboy_signature() {
    // signature of message: joyboy, generated in browser with nos2x extension
    let px: u256 = 0x98298b0b4a0d586771e7f84c742394b5013d37c16af0924bd7ee62ec6a517a5d;
    let rx: u256 = 0x3b7a0877cefa952d536fc167446a22f017922743db5cddd912b7890b7c5c34fe;
    let s: u256 = 0x2591fff0a4ac15d3ed5d3f767e686e771ec456af2fb53ffba163e509e16b0eba;
    let m: u256 = 0x2e5673c8b39f7a0d41219676661159c59a93644c06b81684718b8a0cd53f7f06;

    assert!(verify(px, rx, s, m.into()));
}

fn verify_bip340_signature(msg: u256, sig: Signature, pub_key: u256) {
    assert!(verify(pub_key, sig.r, sig.s, msg.into()));
}

#[test]
fn test_bip340_verify_success() {
    let pub_key: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
    let msg: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;
    let sig = Signature {
        r: 0x6896bd60eeae296db48a229ff71dfe071bde413e6d43f917dc8dcf8c78de3341,
        s: 0x8906d11ac976abccb20b091292bff4ea897efcb639ea871cfa95f6de339e4b0a,
        y_parity: true,
    };

    verify_bip340_signature(msg, sig, pub_key);
}


#[test]
#[should_panic]
fn test_bip340_verify_pk_failure() {
    let pub_key: u256 =
        0xdf01d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659; // 3e304cdd0efe378178266f9d1acfaf3d1335604e
    let msg: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;
    let sig = Signature {
        r: 0x6896bd60eeae296db48a229ff71dfe071bde413e6d43f917dc8dcf8c78de3341,
        s: 0x8906d11ac976abccb20b091292bff4ea897efcb639ea871cfa95f6de339e4b0a,
        y_parity: true,
    };

    verify_bip340_signature(msg, sig, pub_key);
}

#[test]
fn test_bip340_zero_public_key() {
    // Test with zero public key (invalid)
    let pub_key: u256 = 0x0;
    let msg: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;
    let rx: u256 = 0x6896bd60eeae296db48a229ff71dfe071bde413e6d43f917dc8dcf8c78de3341;
    let s: u256 = 0x8906d11ac976abccb20b091292bff4ea897efcb639ea871cfa95f6de339e4b0a;

    assert_eq!(verify(pub_key, rx, s, msg.into()), false);
}

#[test]
fn test_bip340_zero_rx() {
    // Test with zero r value (invalid)
    let pub_key: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
    let msg: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;
    let rx: u256 = 0x0;
    let s: u256 = 0x8906d11ac976abccb20b091292bff4ea897efcb639ea871cfa95f6de339e4b0a;

    assert_eq!(verify(pub_key, rx, s, msg.into()), false);
}

#[test]
fn test_bip340_zero_s() {
    // Test with zero s value (invalid)
    let pub_key: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
    let msg: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;
    let rx: u256 = 0x6896bd60eeae296db48a229ff71dfe071bde413e6d43f917dc8dcf8c78de3341;
    let s: u256 = 0x0;

    assert_eq!(verify(pub_key, rx, s, msg.into()), false);
}

#[test]
fn test_bip340_max_public_key() {
    // Test with maximum field value public key (invalid)
    let pub_key: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;
    let msg: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;
    let rx: u256 = 0x6896bd60eeae296db48a229ff71dfe071bde413e6d43f917dc8dcf8c78de3341;
    let s: u256 = 0x8906d11ac976abccb20b091292bff4ea897efcb639ea871cfa95f6de339e4b0a;

    assert_eq!(verify(pub_key, rx, s, msg.into()), false);
}

#[test]
fn test_bip340_max_rx() {
    // Test with maximum field value rx (invalid)
    let pub_key: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
    let msg: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;
    let rx: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;
    let s: u256 = 0x8906d11ac976abccb20b091292bff4ea897efcb639ea871cfa95f6de339e4b0a;

    assert_eq!(verify(pub_key, rx, s, msg.into()), false);
}

#[test]
fn test_bip340_max_s() {
    // Test with maximum curve order s (invalid)
    let pub_key: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
    let msg: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;
    let rx: u256 = 0x6896bd60eeae296db48a229ff71dfe071bde413e6d43f917dc8dcf8c78de3341;
    let s: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;

    assert_eq!(verify(pub_key, rx, s, msg.into()), false);
}

#[test]
fn test_bip340_out_of_range_public_key() {
    // Test with public key exceeding field size (invalid)
    let pub_key: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC30;
    let msg: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;
    let rx: u256 = 0x6896bd60eeae296db48a229ff71dfe071bde413e6d43f917dc8dcf8c78de3341;
    let s: u256 = 0x8906d11ac976abccb20b091292bff4ea897efcb639ea871cfa95f6de339e4b0a;

    assert_eq!(verify(pub_key, rx, s, msg.into()), false);
}

#[test]
fn test_bip340_out_of_range_rx() {
    // Test with rx exceeding field size (invalid)
    let pub_key: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
    let msg: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;
    let rx: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC30;
    let s: u256 = 0x8906d11ac976abccb20b091292bff4ea897efcb639ea871cfa95f6de339e4b0a;

    assert_eq!(verify(pub_key, rx, s, msg.into()), false);
}

#[test]
fn test_bip340_out_of_range_s() {
    // Test with s exceeding curve order (invalid)
    let pub_key: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
    let msg: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;
    let rx: u256 = 0x6896bd60eeae296db48a229ff71dfe071bde413e6d43f917dc8dcf8c78de3341;
    let s: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364142;

    assert_eq!(verify(pub_key, rx, s, msg.into()), false);
}

#[test]
fn test_bip340_wrong_message_format() {
    // Test with invalid message format (should still work as it's converted to ByteArray)
    let pub_key: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
    let rx: u256 = 0x6896bd60eeae296db48a229ff71dfe071bde413e6d43f917dc8dcf8c78de3341;
    let s: u256 = 0x8906d11ac976abccb20b091292bff4ea897efcb639ea871cfa95f6de339e4b0a;

    // Test with empty message
    let empty_msg = "";
    let result_empty = verify(pub_key, rx, s, empty_msg);
    // Should handle empty message gracefully
    assert_eq!(result_empty, false);

    // Test with very long message
    let long_msg =
        "This is a very long message that exceeds normal bounds to test how the verification handles large inputs and whether it can process them correctly without failing or producing unexpected results";
    let result_long = verify(pub_key, rx, s, long_msg);
    // Should handle long message gracefully
    assert_eq!(result_long, false);
}

#[test]
fn test_bip340_boundary_values() {
    // Test with boundary values for all parameters
    let pub_key: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
    let msg: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;

    // Test with rx = 1 (minimum valid value)
    let rx_min: u256 = 0x1;
    let s: u256 = 0x8906d11ac976abccb20b091292bff4ea897efcb639ea871cfa95f6de339e4b0a;
    let result_min = verify(pub_key, rx_min, s, msg.into());
    assert_eq!(result_min, false);

    // Test with s = 1 (minimum valid value)
    let rx: u256 = 0x6896bd60eeae296db48a229ff71dfe071bde413e6d43f917dc8dcf8c78de3341;
    let s_min: u256 = 0x1;
    let result_s_min = verify(pub_key, rx, s_min, msg.into());
    assert_eq!(result_s_min, false);

    // Test with s = curve_order - 1 (maximum valid value)
    let s_max: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364140;
    let result_s_max = verify(pub_key, rx, s_max, msg.into());
    assert_eq!(result_s_max, false);
}

#[test]
fn test_bip340_malformed_signature_components() {
    let pub_key: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
    let msg: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;

    // Test with bit-flipped rx
    let rx_valid: u256 = 0x6896bd60eeae296db48a229ff71dfe071bde413e6d43f917dc8dcf8c78de3341;
    let rx_flipped: u256 =
        0x6896bd60eeae296db48a229ff71dfe071bde413e6d43f917dc8dcf8c78de3340; // Last bit flipped
    let s: u256 = 0x8906d11ac976abccb20b091292bff4ea897efcb639ea871cfa95f6de339e4b0a;

    let result_flipped = verify(pub_key, rx_flipped, s, msg.into());
    assert_eq!(result_flipped, false);

    // Test with bit-flipped s
    let s_flipped: u256 =
        0x8906d11ac976abccb20b091292bff4ea897efcb639ea871cfa95f6de339e4b0b; // Last bit flipped
    let result_s_flipped = verify(pub_key, rx_valid, s_flipped, msg.into());
    assert_eq!(result_s_flipped, false);
}

#[test]
fn test_bip340_signature_malleability() {
    // Test against signature malleability attacks
    let pub_key: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
    let msg: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;
    let rx: u256 = 0x6896bd60eeae296db48a229ff71dfe071bde413e6d43f917dc8dcf8c78de3341;
    let s: u256 = 0x8906d11ac976abccb20b091292bff4ea897efcb639ea871cfa95f6de339e4b0a;

    // Original signature should be valid
    assert!(verify(pub_key, rx, s, msg.into()));

    // Test with negated s (should be invalid due to BIP340 canonicality)
    let curve_order: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;
    let s_negated = curve_order - s;
    let result_negated = verify(pub_key, rx, s_negated, msg.into());
    assert_eq!(result_negated, false);
}

#[test]
fn test_bip340_edge_case_messages() {
    let pub_key: u256 = 0x778caa53b4393ac467774d09497a87224bf9fab6f6e68b23086497324d6fd117;
    let rx: u256 = 0x71535db165ecd9fbbc046e5ffaea61186bb6ad436732fccc25291a55895464cf;
    let s: u256 = 0x6069ce26bf03466228f19a3a62db8a649f2d560fac652827d1af0574e427ab63;

    // Test with messages of different lengths
    let msg_empty = "";
    let msg_single = "A";
    let msg_32_bytes = "This is exactly 32 bytes length!!";
    let msg_64_bytes = "This is exactly 64 bytes length and should be handled correctly!";

    // These should all be processed (though likely fail verification with wrong signature)
    let result_empty = verify(pub_key, rx, s, msg_empty);
    let result_single = verify(pub_key, rx, s, msg_single);
    let result_32 = verify(pub_key, rx, s, msg_32_bytes);
    let result_64 = verify(pub_key, rx, s, msg_64_bytes);

    // Only the empty message should pass with the test vector
    assert!(result_empty);
    assert_eq!(result_single, false);
    assert_eq!(result_32, false);
    assert_eq!(result_64, false);
}

#[test]
fn test_bip340_consistency_check() {
    // Test that the same inputs always produce the same result
    let pub_key: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
    let msg: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;
    let rx: u256 = 0x6896bd60eeae296db48a229ff71dfe071bde413e6d43f917dc8dcf8c78de3341;
    let s: u256 = 0x8906d11ac976abccb20b091292bff4ea897efcb639ea871cfa95f6de339e4b0a;

    // Run verification multiple times with same inputs
    let result1 = verify(pub_key, rx, s, msg.into());
    let result2 = verify(pub_key, rx, s, msg.into());
    let result3 = verify(pub_key, rx, s, msg.into());

    // All results should be identical
    assert_eq!(result1, result2);
    assert_eq!(result2, result3);
    assert!(result1); // Should be true for this test vector
}

#[test]
fn test_bip340_random_invalid_inputs() {
    // Test with completely random invalid inputs
    let pub_key: u256 = 0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890;
    let msg: u256 = 0x1111111111111111111111111111111111111111111111111111111111111111;
    let rx: u256 = 0x2222222222222222222222222222222222222222222222222222222222222222;
    let s: u256 = 0x3333333333333333333333333333333333333333333333333333333333333333;

    // Should handle gracefully and return false
    let result = verify(pub_key, rx, s, msg.into());
    assert_eq!(result, false);
}

#[test]
fn test_bip340_field_overflow_protection() {
    // Test protection against field overflow attacks
    let pub_key: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
    let msg: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;

    // Test with values that would overflow if not properly handled
    let rx_overflow: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    let s_overflow: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

    let result_rx_overflow = verify(pub_key, rx_overflow, 0x1, msg.into());
    let result_s_overflow = verify(pub_key, 0x1, s_overflow, msg.into());

    // Both should be handled gracefully and return false
    assert_eq!(result_rx_overflow, false);
    assert_eq!(result_s_overflow, false);
}
