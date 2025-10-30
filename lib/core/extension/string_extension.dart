extension StringExtension on String {
  String capitalize() {
    if (isNotEmpty) {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    } else {
      return this;
    }
  }



  String removeExceptionWord() {
    if (isNotEmpty && toLowerCase().startsWith('exception:')) {
      return substring('exception:'.length).trim();
    } else {
      return this;
    }
  }

}
