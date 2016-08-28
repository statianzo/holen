import js.Promise;
import js.Error;
import js.html.XMLHttpRequest;
import js.html.XMLHttpRequestResponseType;
import js.RegExp;
import haxe.Json;

class ResponseTypes {
  public static function isJSON(contentType: String): Bool {
    return new RegExp("[\\/+]json").test(contentType);
  }
}

class HttpStatusRanges {
  public static inline var Ok = 2;
  public static inline var Redirect = 3;
  public static inline var ClientError = 4;
  public static inline var ServerError = 5;
}

class XhrEvents {
  public static inline var ReadyStateChange = "readystatechange";
}

typedef Response = {
  var body: Dynamic;
  var ok: Bool;
  var status: Int;
  var statusText: String;
  var text: String;
  var xhr: XMLHttpRequest;
}

class Jack {
  @:keep
  @:expose('jack')
  static function jack(options:AjaxOptions):Promise<Response> {
    return new Promise<Response>(function(resolve, reject) {
      var xhr = new XMLHttpRequest();
      xhr.open(options.method, options.url);
      xhr.addEventListener(XhrEvents.ReadyStateChange, function() {
        if (xhr.readyState == XMLHttpRequest.DONE) {
          var response = buildResponse(xhr, options);
          if (response.ok) {
            resolve(response);
          }
          else {
            reject(response);
          }
        }
      });
      xhr.send();
    });
  }

  static function buildResponse(xhr: XMLHttpRequest, options) : Response  {
    var statusRange = Math.floor(xhr.status / 100);
    var ok = statusRange == HttpStatusRanges.Ok;
    var response: Response = cast (ok ? {} : new Error('jack request failed'));
    response.body = parseBody(xhr);
    response.ok = ok;
    response.status = xhr.status;
    response.statusText = xhr.statusText;
    response.text = xhr.responseText;
    response.xhr = xhr;

    return response;
  }

  static function parseBody(xhr: XMLHttpRequest): Dynamic {
    return if (ResponseTypes.isJSON(xhr.getResponseHeader('content-type'))) {
      Json.parse(xhr.responseText);
    }
    else {
      null;
    }
  }
}
