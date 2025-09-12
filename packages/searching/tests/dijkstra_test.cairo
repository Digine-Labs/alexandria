use alexandria_searching::dijkstra::{GraphTrait, NodeGetters};
use core::nullable::{FromNullableResult, match_nullable};
use snforge_std::*;


#[test]
fn add_edge() {
    let source = 0_u32;
    let dest = 1_u32;
    let weight = 4_u128;
    let mut graph = GraphTrait::new();
    GraphTrait::add_edge(ref graph, source, dest, weight);
    GraphTrait::add_edge(ref graph, source, dest + 1, weight + 1);
    GraphTrait::add_edge(ref graph, source, dest + 2, weight + 2);
    GraphTrait::add_edge(ref graph, source, dest + 3, weight + 3);
    GraphTrait::add_edge(ref graph, 2, 1, 2);
    GraphTrait::add_edge(ref graph, 2, 3, 3);

    // Test that nodes were added by checking adjacent nodes functionality
    let val = graph.adj_nodes(source.into());

    let span = match match_nullable(val) {
        FromNullableResult::Null => { panic!("No value found") },
        FromNullableResult::NotNull(val) => { val.unbox() },
    };

    assert(span.len() == 4, 'assertion failed');

    let new_node = *span.get(1).unwrap().unbox();
    assert(*new_node.dest() == dest + 1, 'assertion failed');
    assert(*new_node.weight() == weight + 1, 'assertion failed');

    let new_node = *span.get(3).unwrap().unbox();
    assert(*new_node.dest() == dest + 3, 'assertion failed');
    assert(*new_node.weight() == weight + 3, 'assertion failed');

    let val = graph.adj_nodes(2.into());

    let span = match match_nullable(val) {
        FromNullableResult::Null => { panic!("No value found") },
        FromNullableResult::NotNull(val) => { val.unbox() },
    };

    assert(span.len() == 2, 'assertion failed');
}


#[test]
fn calculate_shortest_path() {
    let mut graph = GraphTrait::new();
    GraphTrait::add_edge(ref graph, 0, 1, 5);
    GraphTrait::add_edge(ref graph, 0, 2, 3);
    GraphTrait::add_edge(ref graph, 0, 3, 2);
    GraphTrait::add_edge(ref graph, 0, 4, 3);
    GraphTrait::add_edge(ref graph, 0, 5, 3);
    GraphTrait::add_edge(ref graph, 2, 1, 2);
    GraphTrait::add_edge(ref graph, 2, 3, 3);

    let mut results: Felt252Dict<u128> = GraphTrait::shortest_path(ref graph, 0_u32);

    assert(results.get(0.into()) == 0, 'assertion failed');
    assert(results.get(1.into()) == 5, 'assertion failed');
    assert(results.get(2.into()) == 3, 'assertion failed');
    assert(results.get(3.into()) == 2, 'assertion failed');
    assert(results.get(4.into()) == 3, 'assertion failed');
    assert(results.get(5.into()) == 3, 'assertion failed');
}

#[test]
fn calculate_shortest_path_random() {
    let mut graph = GraphTrait::new();
    GraphTrait::add_edge(ref graph, 0, 2, 4);
    GraphTrait::add_edge(ref graph, 0, 3, 5);
    GraphTrait::add_edge(ref graph, 2, 1, 6);
    GraphTrait::add_edge(ref graph, 3, 1, 7);
    GraphTrait::add_edge(ref graph, 3, 4, 2);
    GraphTrait::add_edge(ref graph, 4, 1, 1);

    let mut results: Felt252Dict<u128> = GraphTrait::shortest_path(ref graph, 0_u32);

    assert(results.get(0.into()) == 0, 'assertion failed');
    assert(results.get(2.into()) == 4, 'assertion failed');
    assert(results.get(3.into()) == 5, 'assertion failed');
    assert(results.get(1.into()) == 8, 'assertion failed');
    assert(results.get(4.into()) == 7, 'assertion failed');
}


#[test]
fn calculate_shortest_path_node_visited() {
    let mut graph = GraphTrait::new();
    GraphTrait::add_edge(ref graph, 0, 1, 5);
    GraphTrait::add_edge(ref graph, 0, 2, 3);
    GraphTrait::add_edge(ref graph, 0, 3, 2);
    GraphTrait::add_edge(ref graph, 0, 4, 3);
    GraphTrait::add_edge(ref graph, 0, 5, 3);
    GraphTrait::add_edge(ref graph, 2, 0, 1);

    let mut results: Felt252Dict<u128> = GraphTrait::shortest_path(ref graph, 0_u32);

    assert(results.get(0.into()) == 0, 'assertion failed');
    assert(results.get(1.into()) == 5, 'assertion failed');
    assert(results.get(2.into()) == 3, 'assertion failed');
    assert(results.get(3.into()) == 2, 'assertion failed');
    assert(results.get(4.into()) == 3, 'assertion failed');
    assert(results.get(5.into()) == 3, 'assertion failed');
}

