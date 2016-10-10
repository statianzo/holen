package holen;

@:jsRequire('querystring')
extern class QueryString {
  public static function stringify(val: Dynamic): String;
  public static function parse(val: String): Dynamic;
}
