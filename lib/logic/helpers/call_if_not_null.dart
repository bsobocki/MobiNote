void callIfNotNull(Function()? foo) {
  foo ?? () {}();
}
