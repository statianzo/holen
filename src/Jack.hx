import js.Promise;
import js.Error;
import js.html.XMLHttpRequest;

class HttpStatusRanges {
  public static inline var Ok = 2;
  public static inline var Redirect = 3;
  public static inline var ClientError = 4;
  public static inline var ServerError = 5;
}

class XhrReadyStates {
  public static inline var Done = 4;
}

class XhrEvents {
  public static inline var ReadyStateChange = 'readystatechange';
}

typedef Response = {
  var xhr: XMLHttpRequest;
  var status: Int;
  var ok: Bool;
}

class Jack {
  @:keep
  @:expose('jack')
  static function jack(options:AjaxOptions):Promise<Response> {
    return new Promise<Response>(function(resolve, reject) {
      var xhr = new XMLHttpRequest();
      xhr.open(options.method, options.url);
      xhr.addEventListener(XhrEvents.ReadyStateChange, function() {
        if (xhr.readyState == XhrReadyStates.Done) {
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
    var response = ok ? {} : new Error('hi');

    return cast response;
  }
}
