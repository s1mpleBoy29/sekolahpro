String capitalizeWords(String input) {
  if (input.isEmpty) {
    return input;
  }

  // Split the input string into words
  List<String> words = input.split('_');

  // Capitalize the first letter of each word
  List<String> capitalizedWords = words.map((word) {
    if (word.isEmpty) {
      return word;
    }
    return word[0].toUpperCase() + word.substring(1);
  }).toList();

  // Join the words back into a single string
  return capitalizedWords.join(' ');
}
