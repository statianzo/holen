class JackTests extends haxe.unit.TestCase {
  static function main() {
    var runner = new haxe.unit.TestRunner();
    runner.add(new JackTests());
    runner.run();
  }

  function testWork() {
    assertEquals("B", "B");
  }
}
