import js.Promise;
import js.Error;
import js.html.XMLHttpRequest;
import js.html.XMLHttpRequestResponseType;
import haxe.Json;

class Jack {
  @:keep
  @:expose('jack')
  public static function jack(options: AjaxOptions):Promise<Response> {
    return new Promise<Response>(function(resolve, reject) {
      var xhr = new XMLHttpRequest();
      var body = transformRequest(options.data, options.serialize);
      xhr.open(options.method, options.url);
      xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
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
      xhr.send(body);
    });
  }

  static inline function transformRequest(data: Dynamic, serialize: String): Dynamic {
    return if (isObject(data) ) {
      if (serialize == 'json') {
        Json.stringify(data);
      }
      else {
        QueryString.stringify(data);
      }
    }
    else {
      data;
    }
  }

  static inline function buildResponse(xhr: XMLHttpRequest, options) : Response  {
    var statusRange = HttpStatusRanges.getRange(xhr.status);
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

  static function isObject(val: Dynamic): Bool {
    return typeof(val) == 'object' && val != null;
  }

  static inline function typeof(val: Dynamic): String {
    return untyped __js__('typeof(val)');
  }
}
