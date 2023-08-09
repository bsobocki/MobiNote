void callIfNotNull(Function()? foo) {
  if (foo != null) {
    foo();
  }
}
