import js.node.Assert;


@:keep
class JackTests {
  static var server: JackTestsServer;
  @:expose
  static function beforeAll(done) {
    server = new JackTestsServer();
    server.start();
  }

  @:expose
  static function afterAll() {
    server.stop();
  }

  @:expose
  static function jack() {
    Assert.equal(1, 1);
  }
}
