use alexandria_encoding::base64::{Base64Decoder, Base64Encoder, Base64UrlDecoder, Base64UrlEncoder};
use snforge_std::*;

#[test]
fn base64encode_empty_test() {
    let input = array![];
    let result = Base64Encoder::encode(input);
    assert(result.len() == 0, 'assertion failed');
}

#[test]
fn base64encode_simple_test() {
    let input = array!['a'];

    let result = Base64Encoder::encode(input);
    assert(result.len() == 4, 'assertion failed');
    assert(*result[0] == 'Y', 'assertion failed');
    assert(*result[1] == 'Q', 'assertion failed');
    assert(*result[2] == '=', 'assertion failed');
    assert(*result[3] == '=', 'assertion failed');
}

#[test]
fn base64encode_hello_world_test() {
    let input = array!['h', 'e', 'l', 'l', 'o', ' ', 'w', 'o', 'r', 'l', 'd'];

    let result = Base64Encoder::encode(input);
    assert(result.len() == 16, 'assertion failed');
    assert(*result[0] == 'a', 'assertion failed');
    assert(*result[1] == 'G', 'assertion failed');
    assert(*result[2] == 'V', 'assertion failed');
    assert(*result[3] == 's', 'assertion failed');
    assert(*result[4] == 'b', 'assertion failed');
    assert(*result[5] == 'G', 'assertion failed');
    assert(*result[6] == '8', 'assertion failed');
    assert(*result[7] == 'g', 'assertion failed');
    assert(*result[8] == 'd', 'assertion failed');
    assert(*result[9] == '2', 'assertion failed');
    assert(*result[10] == '9', 'assertion failed');
    assert(*result[11] == 'y', 'assertion failed');
    assert(*result[12] == 'b', 'assertion failed');
    assert(*result[13] == 'G', 'assertion failed');
    assert(*result[14] == 'Q', 'assertion failed');
    assert(*result[15] == '=', 'assertion failed');
}

#[test]
fn base64decode_empty_test() {
    let input = array![];

    let result = Base64Decoder::decode(input);
    assert(result.len() == 0, 'assertion failed');
}

#[test]
fn base64decode_simple_test() {
    let input = array!['Y', 'Q', '=', '='];

    let result = Base64Decoder::decode(input);
    assert(result.len() == 1, 'assertion failed');
    assert(*result[0] == 'a', 'assertion failed');
}

#[test]
fn base64decode_hello_world_test() {
    let input = array![
        'a', 'G', 'V', 's', 'b', 'G', '8', 'g', 'd', '2', '9', 'y', 'b', 'G', 'Q', '=',
    ];

    let result = Base64Decoder::decode(input);
    assert(result.len() == 11, 'assertion failed');
    assert(*result[0] == 'h', 'assertion failed');
    assert(*result[1] == 'e', 'assertion failed');
    assert(*result[2] == 'l', 'assertion failed');
    assert(*result[3] == 'l', 'assertion failed');
    assert(*result[4] == 'o', 'assertion failed');
    assert(*result[5] == ' ', 'assertion failed');
    assert(*result[6] == 'w', 'assertion failed');
    assert(*result[7] == 'o', 'assertion failed');
    assert(*result[8] == 'r', 'assertion failed');
    assert(*result[9] == 'l', 'assertion failed');
    assert(*result[10] == 'd', 'assertion failed');
}

#[test]
fn base64encode_with_plus_and_slash() {
    let input = array![255, 239];

    let result = Base64Encoder::encode(input);
    assert(result.len() == 4, 'assertion failed');
    assert(*result[0] == '/', 'assertion failed');
    assert(*result[1] == '+', 'assertion failed');
    assert(*result[2] == '8', 'assertion failed');
    assert(*result[3] == '=', 'assertion failed');
}

#[test]
fn base64urlencode_with_plus_and_slash() {
    let input = array![255, 239];

    let result = Base64UrlEncoder::encode(input);
    assert(result.len() == 4, 'assertion failed');
    assert(*result[0] == '_', 'assertion failed');
    assert(*result[1] == '-', 'assertion failed');
    assert(*result[2] == '8', 'assertion failed');
    assert(*result[3] == '=', 'assertion failed');
}

#[test]
fn base64decode_with_plus_and_slash() {
    let input = array!['/', '+', '8', '='];

    let result = Base64UrlDecoder::decode(input);
    assert(result.len() == 2, 'assertion failed');
    assert(*result[0] == 255, 'assertion failed');
    assert(*result[1] == 239, 'assertion failed');
}

#[test]
fn base64urldecode_with_plus_and_slash() {
    let input = array!['_', '-', '8', '='];

    let result = Base64UrlDecoder::decode(input);
    assert(result.len() == 2, 'assertion failed');
    assert(*result[0] == 255, 'assertion failed');
    assert(*result[1] == 239, 'assertion failed');
}

#[test]
fn base64_round_trip_test() {
    // Basic round trip test for "Test"
    let input1 = array!['T', 'e', 's', 't'];
    let encoded1 = Base64Encoder::encode(input1.clone());
    let decoded1 = Base64Decoder::decode(encoded1);

    assert(decoded1.len() == input1.len(), 'Test length mismatch');
    assert(*decoded1[0] == 'T', 'assertion failed');
    assert(*decoded1[1] == 'e', 'assertion failed');
    assert(*decoded1[2] == 's', 'assertion failed');
    assert(*decoded1[3] == 't', 'assertion failed');

    // Round trip test for "Test1" (5 bytes - 1 padding char)
    let input2 = array!['T', 'e', 's', 't', '1'];
    let encoded2 = Base64Encoder::encode(input2.clone());
    let decoded2 = Base64Decoder::decode(encoded2);

    assert(decoded2.len() == input2.len(), 'Test1 length mismatch');
    assert(*decoded2[0] == 'T', 'assertion failed');
    assert(*decoded2[1] == 'e', 'assertion failed');
    assert(*decoded2[2] == 's', 'assertion failed');
    assert(*decoded2[3] == 't', 'assertion failed');
    assert(*decoded2[4] == '1', 'assertion failed');

    // Round trip test for "Test12" (6 bytes - 2 padding chars)
    let input3 = array!['T', 'e', 's', 't', '1', '2'];
    let encoded3 = Base64Encoder::encode(input3.clone());
    let decoded3 = Base64Decoder::decode(encoded3);

    assert(decoded3.len() == input3.len(), 'Test12 length mismatch');
    assert(*decoded3[0] == 'T', 'assertion failed');
    assert(*decoded3[1] == 'e', 'assertion failed');
    assert(*decoded3[2] == 's', 'assertion failed');
    assert(*decoded3[3] == 't', 'assertion failed');
    assert(*decoded3[4] == '1', 'assertion failed');
    assert(*decoded3[5] == '2', 'assertion failed');

    // Round trip test for "Test123" (7 bytes - no padding)
    let input4 = array!['T', 'e', 's', 't', '1', '2', '3'];
    let encoded4 = Base64Encoder::encode(input4.clone());
    let decoded4 = Base64Decoder::decode(encoded4);

    assert(decoded4.len() == input4.len(), 'Test123 length mismatch');
    assert(*decoded4[0] == 'T', 'assertion failed');
    assert(*decoded4[1] == 'e', 'assertion failed');
    assert(*decoded4[2] == 's', 'assertion failed');
    assert(*decoded4[3] == 't', 'assertion failed');
    assert(*decoded4[4] == '1', 'assertion failed');
    assert(*decoded4[5] == '2', 'assertion failed');
    assert(*decoded4[6] == '3', 'assertion failed');
}

#[test]
fn base64_binary_data_test() {
    // Test with binary data
    let input = array![0, 127, 128, 255];

    let encoded = Base64Encoder::encode(input.clone());
    let decoded = Base64Decoder::decode(encoded);

    assert(decoded.len() == input.len(), 'length mismatch');
    assert(*decoded[0] == 0, 'assertion failed');
    assert(*decoded[1] == 127, 'assertion failed');
    assert(*decoded[2] == 128, 'assertion failed');
    assert(*decoded[3] == 255, 'assertion failed');
}

#[test]
fn base64_longer_input_test() {
    // Test with longer input (16 bytes)
    let mut input = array![];
    let mut i = 0;
    while i != 16 {
        input.append(i.try_into().unwrap());
        i += 1;
    }

    let encoded = Base64Encoder::encode(input.clone());
    let decoded = Base64Decoder::decode(encoded);

    assert(decoded.len() == input.len(), 'length mismatch');

    i = 0;
    while i != input.len() {
        assert(*decoded[i] == *input[i], 'assertion failed');
        i += 1;
    }
}

#[test]
fn base64_sample_byte_values_test() {
    // Test with some sample byte values
    let samples = array![0, 50, 100, 150, 200, 255];

    let mut i = 0;
    while i != samples.len() {
        let val = *samples[i];
        let input = array![val];
        let encoded = Base64Encoder::encode(input);
        let decoded = Base64Decoder::decode(encoded);

        assert(decoded.len() == 1, 'assertion failed');
        assert(*decoded[0] == val, 'assertion failed');

        i += 1;
    }
}

#[test]
fn base64_double_padding_test() {
    // Test with input that requires double padding
    let input = array!['f'];

    let encoded = Base64Encoder::encode(input.clone());
    assert(encoded.len() == 4, 'assertion failed');
    assert(*encoded[2] == '=', 'assertion failed');
    assert(*encoded[3] == '=', 'assertion failed');

    let decoded = Base64Decoder::decode(encoded);
    assert(decoded.len() == 1, 'assertion failed');
    assert(*decoded[0] == 'f', 'assertion failed');
}

#[test]
fn base64_single_padding_test() {
    // Test with input that requires single padding
    let input = array!['f', 'o'];

    let encoded = Base64Encoder::encode(input.clone());
    assert(encoded.len() == 4, 'assertion failed');
    assert(*encoded[3] == '=', 'assertion failed');

    let decoded = Base64Decoder::decode(encoded);
    assert(decoded.len() == 2, 'assertion failed');
    assert(*decoded[0] == 'f', 'assertion failed');
    assert(*decoded[1] == 'o', 'assertion failed');
}

#[test]
fn base64_no_padding_test() {
    // Test with input that requires no padding
    let input = array!['f', 'o', 'o'];

    let encoded = Base64Encoder::encode(input.clone());
    assert(encoded.len() == 4, 'assertion failed');

    // Verify no padding
    let last_char = *encoded[encoded.len() - 1];
    assert(last_char != '=', 'unexpected padding');

    let decoded = Base64Decoder::decode(encoded);
    assert(decoded.len() == 3, 'assertion failed');
    assert(*decoded[0] == 'f', 'assertion failed');
    assert(*decoded[1] == 'o', 'assertion failed');
    assert(*decoded[2] == 'o', 'assertion failed');
}

#[test]
fn base64url_round_trip_test() {
    // Test with URL-safe encoding/decoding
    let input = array![255, 239, 223, 191]; // Binary data with values that produce special chars

    let encoded = Base64UrlEncoder::encode(input.clone());

    // Ensure no '+' or '/' characters
    let mut i = 0;
    while i != encoded.len() {
        let current_char = *encoded[i];
        assert(current_char != '+', 'found + char');
        assert(current_char != '/', 'found / char');
        i += 1;
    }

    let decoded = Base64UrlDecoder::decode(encoded);
    assert(decoded.len() == input.len(), 'length mismatch');

    assert(*decoded[0] == 255, 'assertion failed');
    assert(*decoded[1] == 239, 'assertion failed');
    assert(*decoded[2] == 223, 'assertion failed');
    assert(*decoded[3] == 191, 'assertion failed');
}
