abstract interface class Runnable {
  void run();
}

void run(List<Runnable> list) {
  for (final Runnable r in list) {
    r.run();
  }
}
