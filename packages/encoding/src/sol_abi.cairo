pub mod decode;
pub mod encode;
pub mod encode_as;
pub mod sol_bytes;

// [Erim] Todo: ByteArray support can be useful since if we deprecate alexandria Bytes type

use decode::{SolAbiDecodeTrait};
use encode::{SolAbiEncodeSelectorTrait, SolAbiEncodeTrait};
use encode_as::{SolAbiEncodeAsTrait};
use sol_bytes::{SolBytesTrait};
