import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:sudoku/model/sudoku_generator.dart';

class GenerationBenchmark extends BenchmarkBase {
  const GenerationBenchmark() : super("Template");

  static void main() {
    new GenerationBenchmark().report();
  }

  void run() {
    generateBoard(20);
  }

  void setup() {}

  void teardown() {}
}

main() {
  // Run TemplateBenchmark
  GenerationBenchmark.main();
}
