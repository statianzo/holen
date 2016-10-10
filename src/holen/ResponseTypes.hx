package holen;

import js.RegExp;

class ResponseTypes {
  public static inline function isJSON(contentType: String): Bool {
    return new RegExp("[\\/+]json").test(contentType);
  }
}
