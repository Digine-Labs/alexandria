use starknet::ContractAddress;


#[derive(Clone, Drop, Serde)]
pub struct EVMCalldata {
    pub registry: ContractAddress,
    pub calldata: ByteArray,
    pub offset: usize,
    pub relative_offset: usize,
}

