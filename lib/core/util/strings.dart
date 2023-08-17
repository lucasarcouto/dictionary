/// Given a [text], this method will capitalize ONLY the very first character.
/// The rest of the [text] will remain untouched.
String capitalizeFirstLetter(String text) {
  return '${text[0].toUpperCase()}${text.substring(1).toLowerCase()}';
}
