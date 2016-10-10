package holen;

/**
   The configuration options for `Holen.ajax`
 **/
typedef AjaxOptions = {
  /**
     Target URL to send the request
   **/
  var url: String;
  /**
    HTTP method (GET, POST, etc.) for the request
   **/
  var method: String;

  /**
    The data to include with the request. Object values will be serialized into
    a string.
   **/
  @:optional var data: Dynamic;

  /**
    Serialization strategy for `data`. Available choices are `json` or `query`.
   **/
  @:optional var serialize: String;
}
