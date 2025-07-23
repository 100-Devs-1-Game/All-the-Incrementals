extends "res://addons/gut/test.gd"


func test_variable_eq_hello_world() -> void:
    var x: String = "hello_world"

    assert_eq(x, "hello_world")


func test_variable_ne_hello_world() -> void:
    var x: String = "hello world"

    assert_ne(x, "hello_world")
