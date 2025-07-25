use alexandria_searching::binary_search::binary_search_closest as search;
use core::num::traits::Zero;
//! One-dimensional linear interpolation for monotonically increasing sample points.

#[derive(Serde, Copy, Drop, PartialEq)]
pub enum Interpolation {
    Linear,
    Nearest,
    ConstantLeft,
    ConstantRight,
}

#[derive(Serde, Copy, Drop, PartialEq)]
pub enum Extrapolation {
    Null,
    Constant,
}

/// Interpolate y(x) at x.
/// #### Arguments
/// * `x` - The position at which to interpolate.
/// * `xs` - The sorted abscissa sequence of len L.
/// * `ys` - The ordinate sequence of len L.
/// * `interpolation` - The interpolation method to use.
/// * `extrapolation` - The extrapolation method to use.
/// #### Returns
/// * `T` - The interpolated y at x.
pub fn interpolate<
    T, +PartialOrd<T>, +Add<T>, +Sub<T>, +Mul<T>, +Div<T>, +Zero<T>, +Copy<T>, +Drop<T>,
>(
    x: T, xs: Span<T>, ys: Span<T>, interpolation: Interpolation, extrapolation: Extrapolation,
) -> T {
    // [Check] Inputs
    assert!(xs.len() == ys.len(), "Arrays must have the same len");
    assert!(xs.len() >= 2, "Array must have at least 2 elts");

    // [Check] Extrapolation
    if x <= *xs[0] {
        return match extrapolation {
            Extrapolation::Null => Zero::zero(),
            Extrapolation::Constant => *ys[0],
        };
    }
    if x >= *xs[xs.len() - 1] {
        return match extrapolation {
            Extrapolation::Null => Zero::zero(),
            Extrapolation::Constant => *ys[xs.len() - 1],
        };
    }

    // [Compute] Interpolation, could be optimized with binary search
    let mut index = 0;
    loop {
        assert!(*xs[index + 1] > *xs[index], "Abscissa must be sorted");

        if x < *xs[index + 1] {
            break match interpolation {
                Interpolation::Linear => {
                    // y = [(xb - x) * ya + (x - xa) * yb] / (xb - xa)
                    // y = [alpha * ya + beta * yb] / den
                    let den = *xs[index + 1] - *xs[index];
                    let alpha = *xs[index + 1] - x;
                    let beta = x - *xs[index];
                    (alpha * *ys[index] + beta * *ys[index + 1]) / den
                },
                Interpolation::Nearest => {
                    // y = ya or yb
                    let alpha = *xs[index + 1] - x;
                    let beta = x - *xs[index];
                    if alpha >= beta {
                        *ys[index]
                    } else {
                        *ys[index + 1]
                    }
                },
                Interpolation::ConstantLeft => {
                    // Handle equality case: x == *xs[index]
                    if x <= *xs[index] {
                        *ys[index]
                    } else {
                        *ys[index + 1]
                    }
                },
                Interpolation::ConstantRight => *ys[index],
            };
        }

        index += 1;
    }
}

/// Fast interpolation function that uses binary search for efficient value lookup.
/// Optimized version of interpolate() with O(log n) time complexity instead of O(n).
///
/// Time complexity: O(log n) due to binary search
/// Space complexity: O(1)
///
/// #### Arguments
/// * `x` - The position at which to interpolate
/// * `xs` - The sorted abscissa sequence of length L (must be monotonically increasing)
/// * `ys` - The ordinate sequence of length L corresponding to xs values
/// * `interpolation` - The interpolation method to use (Linear, Nearest, ConstantLeft,
/// ConstantRight)
/// * `extrapolation` - The extrapolation method for values outside xs range (Null, Constant)
///
/// #### Returns
/// * `T` - The interpolated/extrapolated value y at position x
///
/// #### Requirements
/// * xs and ys must have the same length
/// * xs must be sorted in ascending order
/// * Both arrays must have at least 2 elements
/// * Type T must implement required arithmetic and comparison traits
///
/// #### Panics
/// * If xs and ys have different lengths
/// * If arrays have fewer than 2 elements
/// * If xs is not properly sorted
/// * If binary search fails to find appropriate index
pub fn interpolate_fast<
    T, +PartialOrd<T>, +Add<T>, +Sub<T>, +Mul<T>, +Div<T>, +Zero<T>, +Copy<T>, +Drop<T>,
>(
    x: T, xs: Span<T>, ys: Span<T>, interpolation: Interpolation, extrapolation: Extrapolation,
) -> T {
    // [Check] Inputs
    assert!(xs.len() == ys.len(), "Arrays must have the same len");
    assert!(xs.len() >= 2, "Array must have at least 2 elts");

    // [Check] Extrapolation
    if x <= *xs[0] {
        return match extrapolation {
            Extrapolation::Null => Zero::zero(),
            Extrapolation::Constant => *ys[0],
        };
    }
    if x >= *xs[xs.len() - 1] {
        return match extrapolation {
            Extrapolation::Null => Zero::zero(),
            Extrapolation::Constant => *ys[xs.len() - 1],
        };
    }

    // [Compute] Interpolation with binary search
    let index: u32 = search(xs, x).expect('search error');

    assert!(*xs[index + 1] > *xs[index], "Abscissa must be sorted");
    assert!(x < *xs[index + 1], "search error");

    match interpolation {
        Interpolation::Linear => {
            // y = [(xb - x) * ya + (x - xa) * yb] / (xb - xa)
            // y = [alpha * ya + beta * yb] / den
            let den = *xs[index + 1] - *xs[index];
            let alpha = *xs[index + 1] - x;
            let beta = x - *xs[index];
            (alpha * *ys[index] + beta * *ys[index + 1]) / den
        },
        Interpolation::Nearest => {
            // y = ya or yb
            let alpha = *xs[index + 1] - x;
            let beta = x - *xs[index];
            if alpha >= beta {
                *ys[index]
            } else {
                *ys[index + 1]
            }
        },
        Interpolation::ConstantLeft => {
            // Handle equality case: x == *xs[index]
            if x <= *xs[index] {
                *ys[index]
            } else {
                *ys[index + 1]
            }
        },
        Interpolation::ConstantRight => *ys[index],
    }
}
