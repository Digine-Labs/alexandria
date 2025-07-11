//! # Perfect Number.

/// Algorithm to determine if a number is a perfect number
/// #### Arguments
/// * `num` - The number to be checked.
/// #### Returns
/// * `bool` - True if num is a perfect number, false otherwise.
pub fn is_perfect_number(num: u128) -> bool {
    if num == 0 {
        return false;
    }
    if num == 1 {
        return false;
    }

    let mut index = 1;
    let mut sum = 0;
    while (index != num - 1) {
        if num % index == 0 {
            sum += index;
        }
        index += 1;
    }
    num == sum
}

/// Algorithm to determine all the perfect numbers up to a maximum value
/// #### Arguments
/// * `max` - The maximum value to check for perfect numbers.
/// #### Returns
/// * `Array` - An array of perfect numbers up to the max value.
pub fn perfect_numbers(max: u128) -> Array<u128> {
    let mut res = array![];
    let mut index = 1;

    while (index != max) {
        if is_perfect_number(index) {
            res.append(index);
        }
        index += 1;
    }
    res
}
