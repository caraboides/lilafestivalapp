extension Interpolation on String {
  String fill(Map<String, Object> params) => params.entries.fold(
      this,
      (previousValue, entry) =>
          previousValue.replaceAll('{${entry.key}}', entry.value.toString()));
}
