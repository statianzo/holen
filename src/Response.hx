import js.html.XMLHttpRequest;

typedef Response = {
  var body: Dynamic;
  var ok: Bool;
  var status: Int;
  var statusText: String;
  var text: String;
  var xhr: XMLHttpRequest;
}

