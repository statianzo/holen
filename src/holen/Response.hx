package holen;

import js.html.XMLHttpRequest;

typedef Response = {
  @:optional var body: Dynamic;
  var ok: Bool;
  var status: Int;
  var statusText: String;
  var text: String;
  var xhr: XMLHttpRequest;
}

