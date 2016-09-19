package;
import haxe.Json;

interface TapeTest {
  function plan(count: Int): Void;
  function ok(value: Bool, ?message: String): Void;
  function notOk(value: Bool, ?message: String): Void;
  function error(object: Dynamic, ?message: String): Void;
  function throws(fn: Void->Void, expected: Dynamic, ?message: String): Void;
  function doesNotThrow(fn: Void->Void, ?message: String): Void;
  function equal<T>(actual: T, expected: T, ?message: String): Void;
  function notEqual<T>(actual: T, unexpected: T, ?message: String): Void;
  function same<T>(actual: T, expected: T, ?message: String): Void;
  function notSame<T>(actual: T, unexpected: T, ?message: String): Void;
  function strictSame<T>(actual: T, expected: T, ?message: String): Void;
  function strictNotSame<T>(actual: T, unexpected: T, ?message: String): Void;
  function match(found: String, pattern: Dynamic, ?message: String): Void;
  function notMatch(found: String, pattern: Dynamic, ?message: String): Void;
  function type(object: Dynamic, type: Dynamic, ?message: String): Void;
}

typedef TapeOptions = {
  @:optional var todo: Bool;
  @:optional var skip: Bool;
  @:optional var timeout: Int;
  @:optional var bail: Bool;
  @:optional var autoend: Bool;
  @:optional var diagnostic: Bool;
};

@:jsRequire("tape")
extern class Tape {
  static function test(name: String, ?options: TapeOptions, body: TapeTest->Void): Void;
}

@:jsRequire("es6-promise")
extern class Es6Promise {
  static function polyfill(): Void;
}

@:keep
class JackTests {
  static function main() {
    Es6Promise.polyfill();
    Tape.test("hello", {timeout: 5000}, function(t) {
      t.plan(2);
      var p = Jack.jack({url: "https://api.github.com/users/statianzo", method: "GET"});
      p.then(function(res) {
        t.equal(res.body.login, "statianzo");
        t.ok(res.ok);
      });
    });
  }
}
