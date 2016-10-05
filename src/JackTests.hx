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
  static var host = 'http://localhost:3000';

  function get(t: TapeTest) {
    t.plan(3);
    Jack.jack({url: '${host}/request', method: 'GET'})
      .then(function(res) {
        var headers: DynamicAccess<String> = res.body.headers;
        t.ok(res.ok);
        t.equal(res.body.method, 'GET');
        t.equal(headers['x-requested-with'], 'XMLHttpRequest');
      })
    .catchError(t.error);
  }

  function post(t: TapeTest) {
    t.plan(2);
    Jack.jack({url: '${host}/request', method: 'POST'})
      .then(function(res) {
        t.ok(res.ok);
        t.equal(res.body.method, 'POST');
      })
    .catchError(t.error);
  }

  function put(t: TapeTest) {
    t.plan(2);
    Jack.jack({url: '${host}/request', method: 'PUT'})
      .then(function(res) {
        t.ok(res.ok);
        t.equal(res.body.method, 'PUT');
      })
    .catchError(t.error);
  }

  function delete(t: TapeTest) {
    t.plan(2);
    Jack.jack({url: '${host}/request', method: 'DELETE'})
      .then(function(res) {
        t.ok(res.ok);
        t.equal(res.body.method, 'DELETE');
      })
    .catchError(t.error);
  }

  function emptyBody(t: TapeTest) {
    t.plan(3);
    Jack.jack({url: '${host}/empty', method: 'GET'})
      .then(function(res) {
        t.ok(res.ok);
        t.equal(res.status, 204);
        t.equal(res.body, null);
      })
    .catchError(t.error);
  }

  function response500(t: TapeTest) {
    t.plan(4);
    Jack.jack({url: '${host}/boom', method: 'GET'})
      .then(function(res) {
        t.fail('response promise was not rejected');
      })
    .catchError(function(err) {
      t.notOk(err.ok);
      t.equal(err.status, 500);
      t.equal(err.body, null);
      t.equal(err.text, 'boom');
    });
  }

  function postQuerystring(t: TapeTest) {
    var data = {
      name: 'Chelsea',
      age: '27',
      cats: ['One', 'Two', 'Three']
    };
    t.plan(2);
    Jack.jack({
      url: '${host}/request',
      method: 'POST',
      data: data
    })
    .then(function(res) {
      t.ok(res.ok);
      t.same(QueryString.parse(res.body.data), data);
    })
    .catchError(t.error);
  }

  function postJson(t: TapeTest) {
    var data = {
      name: 'Chelsea',
      age: 27,
      cats: ['One', 'Two', 'Three']
    };
    t.plan(2);
    Jack.jack({
      url: '${host}/request',
      method: 'POST',
      serialize: 'json',
      data: data
    })
    .then(function(res) {
      t.ok(res.ok);
      t.same(Json.parse(res.body.data), data);
    })
    .catchError(t.error);
  }

  function getIgnoresData(t: TapeTest) {
    t.plan(2);
    Jack.jack({
      url: '${host}/request',
      method: 'GET',
      serialize: 'json',
      data: 'ignore me'
    })
    .then(function(res) {
      t.ok(res.ok);
      t.equal(res.body.data, '');
    })
    .catchError(t.error);
  }


  static function main() {
    Es6Promise.polyfill();

    var fieldNames = Type.getInstanceFields(JackTests);
    var instance = Type.createEmptyInstance(JackTests);
    for (name in fieldNames) {
      var method = Reflect.field(instance, name);
      Tape.test(name, {timeout: 500}, function(t) {
        Reflect.callMethod(null, method, [t]);
      });
    }
  }
}
