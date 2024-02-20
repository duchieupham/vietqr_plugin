class StringUtils {
  const StringUtils._privateConsrtructor();

  static const StringUtils _instance = StringUtils._privateConsrtructor();

  static StringUtils get instance => _instance;

  String formatPhoneNumberVN(String phoneNumber) {
    String numericString = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    if (numericString.length >= 10) {
      return phoneNumber.replaceAllMapped(RegExp(r'(\d{3})(\d{3})(\d+)'),
          (Match m) => "${m[1]} ${m[2]} ${m[3]}");
    } else {
      if (numericString.length == 8) {
        return '${numericString.substring(0, 4)} ${numericString.substring(4, 8)}';
      }
      return numericString;
    }
  }
}
