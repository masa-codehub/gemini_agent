from hello import say_hello


def test_say_hello():
    """say_hello() returns 'Hello, World!'"""
    assert say_hello() == "Hello, World!"


def test_say_hello_type():
    """say_hello() returns a string"""
    assert isinstance(say_hello(), str)
