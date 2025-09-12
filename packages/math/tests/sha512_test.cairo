use alexandria_math::sha512::{Word64WordOperations, sha512};
use snforge_std::*;

fn get_lorem_ipsum() -> Array<u8> {
    let mut input: Array<u8> = array![
        0x4C, 0x6F, 0x72, 0x65, 0x6D, 0x20, 0x69, 0x70, 0x73, 0x75, 0x6D, 0x2C, 0x20, 0x6F, 0x72,
        0x20, 0x6C, 0x73, 0x69, 0x70, 0x73, 0x75, 0x6D, 0x20, 0x61, 0x73, 0x20, 0x69, 0x74, 0x20,
        0x69, 0x73, 0x20, 0x73, 0x6F, 0x6D, 0x65, 0x74, 0x69, 0x6D, 0x65, 0x73, 0x20, 0x6B, 0x6E,
        0x6F, 0x77, 0x6E, 0x2C, 0x20, 0x69, 0x73, 0x20, 0x64, 0x75, 0x6D, 0x6D, 0x79, 0x20, 0x74,
        0x65, 0x78, 0x74, 0x20, 0x75, 0x73, 0x65, 0x64, 0x20, 0x69, 0x6E, 0x20, 0x6C, 0x61, 0x79,
        0x69, 0x6E, 0x67, 0x20, 0x6F, 0x75, 0x74, 0x20, 0x70, 0x72, 0x69, 0x6E, 0x74, 0x2C, 0x20,
        0x67, 0x72, 0x61, 0x70, 0x68, 0x69, 0x63, 0x20, 0x6F, 0x72, 0x20, 0x77, 0x65, 0x62, 0x20,
        0x64, 0x65, 0x73, 0x69, 0x67, 0x6E, 0x73, 0x2E, 0x20, 0x54, 0x68, 0x65, 0x20, 0x70, 0x61,
        0x73, 0x73, 0x61, 0x67, 0x65, 0x20, 0x69, 0x73, 0x20, 0x61, 0x74, 0x74, 0x72, 0x69, 0x62,
        0x75, 0x74, 0x65, 0x64, 0x20, 0x74, 0x6F, 0x20, 0x61, 0x6E, 0x20, 0x75, 0x6E, 0x6B, 0x6E,
        0x6F, 0x77, 0x6E, 0x20, 0x74, 0x79, 0x70, 0x65, 0x73, 0x65, 0x74, 0x74, 0x65, 0x72, 0x20,
        0x69, 0x6E, 0x20, 0x74, 0x68, 0x65, 0x20, 0x31, 0x35, 0x74, 0x68, 0x20, 0x63, 0x65, 0x6E,
        0x74, 0x75, 0x72, 0x79, 0x20, 0x77, 0x68, 0x6F, 0x20, 0x69, 0x73, 0x20, 0x74, 0x68, 0x6F,
        0x75, 0x67, 0x68, 0x74, 0x20, 0x74, 0x6F, 0x20, 0x68, 0x61, 0x76, 0x65, 0x20, 0x73, 0x63,
        0x72, 0x61, 0x6D, 0x62, 0x6C, 0x65, 0x64, 0x20, 0x70, 0x61, 0x72, 0x74, 0x73, 0x20, 0x6F,
        0x66, 0x20, 0x43, 0x69, 0x63, 0x65, 0x72, 0x6F, 0x27, 0x73, 0x20, 0x44, 0x65, 0x20, 0x46,
        0x69, 0x6E, 0x69, 0x62, 0x75, 0x73, 0x20, 0x42, 0x6F, 0x6E, 0x6F, 0x72, 0x75, 0x6D, 0x20,
        0x65, 0x74, 0x20, 0x4D, 0x61, 0x6C, 0x6F, 0x72, 0x75, 0x6D, 0x20, 0x66, 0x6F, 0x72, 0x20,
        0x75, 0x73, 0x65, 0x20, 0x69, 0x6E, 0x20, 0x61, 0x20, 0x74, 0x79, 0x70, 0x65, 0x20, 0x73,
        0x70, 0x65, 0x63, 0x69, 0x6D, 0x65, 0x6E, 0x20, 0x62, 0x6F, 0x6F, 0x6B, 0x2E, 0x20, 0x49,
        0x74, 0x20, 0x75, 0x73, 0x75, 0x61, 0x6C, 0x6C, 0x79, 0x20, 0x62, 0x65, 0x67, 0x69, 0x6E,
        0x73, 0x20, 0x77, 0x69, 0x74, 0x68,
    ];
    input
}

#[test]
fn test_sha512_lorem_ipsum() {
    let msg = get_lorem_ipsum();
    let res = sha512(msg);

    assert(res.len() == 64, 'assertion failed');

    assert(*res[0] == 0xd5, 'assertion failed');
    assert(*res[1] == 0xa2, 'assertion failed');
    assert(*res[2] == 0xe1, 'assertion failed');
    assert(*res[3] == 0x4e, 'assertion failed');
    assert(*res[4] == 0xf4, 'assertion failed');
    assert(*res[5] == 0x20, 'assertion failed');
    assert(*res[6] == 0xf8, 'assertion failed');
    assert(*res[7] == 0x2d, 'assertion failed');
    assert(*res[8] == 0x68, 'assertion failed');
    assert(*res[9] == 0x2b, 'assertion failed');
    assert(*res[10] == 0x19, 'assertion failed');
    assert(*res[11] == 0xc3, 'assertion failed');
    assert(*res[12] == 0xd0, 'assertion failed');
    assert(*res[13] == 0x70, 'assertion failed');
    assert(*res[14] == 0xf4, 'assertion failed');
    assert(*res[15] == 0x81, 'assertion failed');
    assert(*res[16] == 0x14, 'assertion failed');
    assert(*res[17] == 0xcb, 'assertion failed');
    assert(*res[18] == 0xb9, 'assertion failed');
    assert(*res[19] == 0x74, 'assertion failed');
    assert(*res[20] == 0x7c, 'assertion failed');
    assert(*res[21] == 0x7d, 'assertion failed');
    assert(*res[22] == 0xb1, 'assertion failed');
    assert(*res[23] == 0x15, 'assertion failed');
    assert(*res[24] == 0xce, 'assertion failed');
    assert(*res[25] == 0xa5, 'assertion failed');
    assert(*res[26] == 0x41, 'assertion failed');
    assert(*res[27] == 0x3e, 'assertion failed');
    assert(*res[28] == 0xf8, 'assertion failed');
    assert(*res[29] == 0xcb, 'assertion failed');
    assert(*res[30] == 0x8f, 'assertion failed');
    assert(*res[31] == 0xba, 'assertion failed');
    assert(*res[32] == 0xc6, 'assertion failed');
    assert(*res[33] == 0x90, 'assertion failed');
    assert(*res[34] == 0x17, 'assertion failed');
    assert(*res[35] == 0xc5, 'assertion failed');
    assert(*res[36] == 0x17, 'assertion failed');
    assert(*res[37] == 0x0f, 'assertion failed');
    assert(*res[38] == 0x01, 'assertion failed');
    assert(*res[39] == 0xc4, 'assertion failed');
    assert(*res[40] == 0x77, 'assertion failed');
    assert(*res[41] == 0xb3, 'assertion failed');
    assert(*res[42] == 0xdf, 'assertion failed');
    assert(*res[43] == 0x3d, 'assertion failed');
    assert(*res[44] == 0xfb, 'assertion failed');
    assert(*res[45] == 0x34, 'assertion failed');
    assert(*res[46] == 0xd3, 'assertion failed');
    assert(*res[47] == 0x50, 'assertion failed');
    assert(*res[48] == 0x8f, 'assertion failed');
    assert(*res[49] == 0xa0, 'assertion failed');
    assert(*res[50] == 0xb2, 'assertion failed');
    assert(*res[51] == 0xb1, 'assertion failed');
    assert(*res[52] == 0x37, 'assertion failed');
    assert(*res[53] == 0xd4, 'assertion failed');
    assert(*res[54] == 0xcb, 'assertion failed');
    assert(*res[55] == 0x54, 'assertion failed');
    assert(*res[56] == 0x60, 'assertion failed');
    assert(*res[57] == 0x9e, 'assertion failed');
    assert(*res[58] == 0x63, 'assertion failed');
    assert(*res[59] == 0x3d, 'assertion failed');
    assert(*res[60] == 0x14, 'assertion failed');
    assert(*res[61] == 0x45, 'assertion failed');
    assert(*res[62] == 0x82, 'assertion failed');
    assert(*res[63] == 0xc9, 'assertion failed');
}

#[test]
fn test_sha512_size_one() {
    let mut arr: Array<u8> = array![49];
    let mut res = sha512(arr);

    assert(res.len() == 64, 'assertion failed');

    assert(*res[0] == 0x4d, 'assertion failed');
    assert(*res[1] == 0xff, 'assertion failed');
    assert(*res[2] == 0x4e, 'assertion failed');
    assert(*res[3] == 0xa3, 'assertion failed');
    assert(*res[4] == 0x40, 'assertion failed');
    assert(*res[5] == 0xf0, 'assertion failed');
    assert(*res[6] == 0xa8, 'assertion failed');
    assert(*res[7] == 0x23, 'assertion failed');
    assert(*res[8] == 0xf1, 'assertion failed');
    assert(*res[9] == 0x5d, 'assertion failed');
    assert(*res[10] == 0x3f, 'assertion failed');
    assert(*res[11] == 0x4f, 'assertion failed');
    assert(*res[12] == 0x01, 'assertion failed');
    assert(*res[13] == 0xab, 'assertion failed');
    assert(*res[14] == 0x62, 'assertion failed');
    assert(*res[15] == 0xea, 'assertion failed');
    assert(*res[16] == 0xe0, 'assertion failed');
    assert(*res[17] == 0xe5, 'assertion failed');
    assert(*res[18] == 0xda, 'assertion failed');
    assert(*res[19] == 0x57, 'assertion failed');
    assert(*res[20] == 0x9c, 'assertion failed');
    assert(*res[21] == 0xcb, 'assertion failed');
    assert(*res[22] == 0x85, 'assertion failed');
    assert(*res[23] == 0x1f, 'assertion failed');
    assert(*res[24] == 0x8d, 'assertion failed');
    assert(*res[25] == 0xb9, 'assertion failed');
    assert(*res[26] == 0xdf, 'assertion failed');
    assert(*res[27] == 0xe8, 'assertion failed');
    assert(*res[28] == 0x4c, 'assertion failed');
    assert(*res[29] == 0x58, 'assertion failed');
    assert(*res[30] == 0xb2, 'assertion failed');
    assert(*res[31] == 0xb3, 'assertion failed');
    assert(*res[32] == 0x7b, 'assertion failed');
    assert(*res[33] == 0x89, 'assertion failed');
    assert(*res[34] == 0x90, 'assertion failed');
    assert(*res[35] == 0x3a, 'assertion failed');
    assert(*res[36] == 0x74, 'assertion failed');
    assert(*res[37] == 0x0e, 'assertion failed');
    assert(*res[38] == 0x1e, 'assertion failed');
    assert(*res[39] == 0xe1, 'assertion failed');
    assert(*res[40] == 0x72, 'assertion failed');
    assert(*res[41] == 0xda, 'assertion failed');
    assert(*res[42] == 0x79, 'assertion failed');
    assert(*res[43] == 0x3a, 'assertion failed');
    assert(*res[44] == 0x6e, 'assertion failed');
    assert(*res[45] == 0x79, 'assertion failed');
    assert(*res[46] == 0xd5, 'assertion failed');
    assert(*res[47] == 0x60, 'assertion failed');
    assert(*res[48] == 0xe5, 'assertion failed');
    assert(*res[49] == 0xf7, 'assertion failed');
    assert(*res[50] == 0xf9, 'assertion failed');
    assert(*res[51] == 0xbd, 'assertion failed');
    assert(*res[52] == 0x05, 'assertion failed');
    assert(*res[53] == 0x8a, 'assertion failed');
    assert(*res[54] == 0x12, 'assertion failed');
    assert(*res[55] == 0xa2, 'assertion failed');
    assert(*res[56] == 0x80, 'assertion failed');
    assert(*res[57] == 0x43, 'assertion failed');
    assert(*res[58] == 0x3e, 'assertion failed');
    assert(*res[59] == 0xd6, 'assertion failed');
    assert(*res[60] == 0xfa, 'assertion failed');
    assert(*res[61] == 0x46, 'assertion failed');
    assert(*res[62] == 0x51, 'assertion failed');
    assert(*res[63] == 0x0a, 'assertion failed');
}

#[test]
fn test_size_zero() {
    let msg = array![];

    let res = sha512(msg);

    assert(res.len() == 64, 'assertion failed');
    assert(*res[0] == 0xcf, 'assertion failed');
    assert(*res[1] == 0x83, 'assertion failed');
    assert(*res[2] == 0xe1, 'assertion failed');
    assert(*res[3] == 0x35, 'assertion failed');
    assert(*res[4] == 0x7e, 'assertion failed');
    assert(*res[5] == 0xef, 'assertion failed');
    assert(*res[6] == 0xb8, 'assertion failed');
    assert(*res[7] == 0xbd, 'assertion failed');
    assert(*res[8] == 0xf1, 'assertion failed');
    assert(*res[9] == 0x54, 'assertion failed');
    assert(*res[10] == 0x28, 'assertion failed');
    assert(*res[11] == 0x50, 'assertion failed');
    assert(*res[12] == 0xd6, 'assertion failed');
    assert(*res[13] == 0x6d, 'assertion failed');
    assert(*res[14] == 0x80, 'assertion failed');
    assert(*res[15] == 0x07, 'assertion failed');
    assert(*res[16] == 0xd6, 'assertion failed');
    assert(*res[17] == 0x20, 'assertion failed');
    assert(*res[18] == 0xe4, 'assertion failed');
    assert(*res[19] == 0x05, 'assertion failed');
    assert(*res[20] == 0x0b, 'assertion failed');
    assert(*res[21] == 0x57, 'assertion failed');
    assert(*res[22] == 0x15, 'assertion failed');
    assert(*res[23] == 0xdc, 'assertion failed');
    assert(*res[24] == 0x83, 'assertion failed');
    assert(*res[25] == 0xf4, 'assertion failed');
    assert(*res[26] == 0xa9, 'assertion failed');
    assert(*res[27] == 0x21, 'assertion failed');
    assert(*res[28] == 0xd3, 'assertion failed');
    assert(*res[29] == 0x6c, 'assertion failed');
    assert(*res[30] == 0xe9, 'assertion failed');
    assert(*res[31] == 0xce, 'assertion failed');
    assert(*res[32] == 0x47, 'assertion failed');
    assert(*res[33] == 0xd0, 'assertion failed');
    assert(*res[34] == 0xd1, 'assertion failed');
    assert(*res[35] == 0x3c, 'assertion failed');
    assert(*res[36] == 0x5d, 'assertion failed');
    assert(*res[37] == 0x85, 'assertion failed');
    assert(*res[38] == 0xf2, 'assertion failed');
    assert(*res[39] == 0xb0, 'assertion failed');
    assert(*res[40] == 0xff, 'assertion failed');
    assert(*res[41] == 0x83, 'assertion failed');
    assert(*res[42] == 0x18, 'assertion failed');
    assert(*res[43] == 0xd2, 'assertion failed');
    assert(*res[44] == 0x87, 'assertion failed');
    assert(*res[45] == 0x7e, 'assertion failed');
    assert(*res[46] == 0xec, 'assertion failed');
    assert(*res[47] == 0x2f, 'assertion failed');
    assert(*res[48] == 0x63, 'assertion failed');
    assert(*res[49] == 0xb9, 'assertion failed');
    assert(*res[50] == 0x31, 'assertion failed');
    assert(*res[51] == 0xbd, 'assertion failed');
    assert(*res[52] == 0x47, 'assertion failed');
    assert(*res[53] == 0x41, 'assertion failed');
    assert(*res[54] == 0x7a, 'assertion failed');
    assert(*res[55] == 0x81, 'assertion failed');
    assert(*res[56] == 0xa5, 'assertion failed');
    assert(*res[57] == 0x38, 'assertion failed');
    assert(*res[58] == 0x32, 'assertion failed');
    assert(*res[59] == 0x7a, 'assertion failed');
    assert(*res[60] == 0xf9, 'assertion failed');
    assert(*res[61] == 0x27, 'assertion failed');
    assert(*res[62] == 0xda, 'assertion failed');
    assert(*res[63] == 0x3e, 'assertion failed');
}
