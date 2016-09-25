package;
import haxe.Json;
import haxe.DynamicAccess;

interface TapeTest {
  function fail(?message: String): Void;
  function pass(?message: String): Void;
  function skip(?message: String): Void;
  function plan(count: Int): Void;
  function ok(value: Bool, ?message: String): Void;
  function notOk(value: Bool, ?message: String): Void;
  function error(object: Dynamic): Void;
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

@:jsRequire('tape')
extern class Tape {
  static function test(name: String, ?options: TapeOptions, body: TapeTest->Void): Void;
}

@:jsRequire('es6-promise')
extern class Es6Promise {
  static function polyfill(): Void;
}

@:jsRequire('process')
extern class Process {
  static function on(event: String, callback: Dynamic->Void): Void;
}

@:keep
class JackTests {
  static function main() {
    var host = 'http://localhost:3000';
    Es6Promise.polyfill();

    Tape.test('get', {timeout: 500}, function(t) {
      t.plan(3);
      Jack.jack({url: 'http://localhost:3000/request', method: 'GET'})
        .then(function(res) {
          var headers: DynamicAccess<String> = res.body.headers;
          t.ok(res.ok);
          t.equal(res.body.method, 'GET');
          t.equal(headers['x-requested-with'], 'XMLHttpRequest');
        })
        .catchError(t.error);
    });

    Tape.test('post', {timeout: 500}, function(t) {
      t.plan(2);
      Jack.jack({url: 'http://localhost:3000/request', method: 'POST'})
        .then(function(res) {
          t.ok(res.ok);
          t.equal(res.body.method, 'POST');
        })
        .catchError(t.error);
    });

    Tape.test('put', {timeout: 500}, function(t) {
      t.plan(2);
      Jack.jack({url: 'http://localhost:3000/request', method: 'PUT'})
        .then(function(res) {
          t.ok(res.ok);
          t.equal(res.body.method, 'PUT');
        })
        .catchError(t.error);
    });

    Tape.test('delete', {timeout: 500}, function(t) {
      t.plan(2);
      Jack.jack({url: 'http://localhost:3000/request', method: 'DELETE'})
        .then(function(res) {
          t.ok(res.ok);
          t.equal(res.body.method, 'DELETE');
        })
        .catchError(t.error);
    });

    Tape.test('empty body', {timeout: 500}, function(t) {
      t.plan(3);
      Jack.jack({url: 'http://localhost:3000/empty', method: 'GET'})
        .then(function(res) {
          t.ok(res.ok);
          t.equal(res.status, 204);
          t.equal(res.body, null);
        })
        .catchError(t.error);
    });

    Tape.test('500 response', {timeout: 500}, function(t) {
      t.plan(4);
      Jack.jack({url: 'http://localhost:3000/boom', method: 'GET'})
        .then(function(res) {
          t.fail('response promise was not rejected');
        })
        .catchError(function(err) {
          t.notOk(err.ok);
          t.equal(err.status, 500);
          t.equal(err.body, null);
          t.equal(err.text, 'boom');
        });
    });

    Tape.test('posting data', {timeout: 500}, function(t) {
      var data = {
        name: 'Chelsea',
        age: 27,
        cats: ['One', 'Two', 'Three']
      };
      t.plan(2);
      Jack.jack({
        url: 'http://localhost:3000/request',
        method: 'POST',
        data: data
      })
      .then(function(res) {
        t.ok(res.ok);
        t.same(Json.parse(res.body.data), data);
      })
      .catchError(t.error);
    });
  }
}
