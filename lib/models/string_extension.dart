extension StringExtension on String {
  String format(List params) => interpolate(this, params);
}

String interpolate(String string, List params) {
  String result = string;
  for (int i = 0; i < params.length; i++) {
    result = result.replaceAll('%$i\$', params[i].toString());
  }
  return result;
}