package holen;

class HttpStatusRanges {
  public static inline function getRange(status: Int) {
    return Math.floor(status / 100);
  }
  public static inline var Ok = 2;
  public static inline var Redirect = 3;
  public static inline var ClientError = 4;
  public static inline var ServerError = 5;
}

