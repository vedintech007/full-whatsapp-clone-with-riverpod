convertPhoneNumber(String phoneNumber) {
  // when logging in or picking a new phone number
  // it might come with a +233 or some characters
  // this function takes care of that and returns a normal
  // phone value
  if (phoneNumber.contains("-")) {
    phoneNumber = phoneNumber.replaceAll("-", "");
  }

  if (phoneNumber.contains("(")) {
    phoneNumber = phoneNumber.replaceAll("(", "");
  }

  if (phoneNumber.contains(")")) {
    phoneNumber = phoneNumber.replaceAll(")", "");
  }

  if (phoneNumber.contains(" ")) {
    phoneNumber = phoneNumber.replaceAll(" ", "");
  }

  if (phoneNumber.contains("/")) {
    phoneNumber = phoneNumber.replaceAll("/", "");
  }

  if (phoneNumber.startsWith("0")) {
    phoneNumber = phoneNumber.replaceFirst("0", "+233");
  }

  if (phoneNumber.startsWith("233")) {
    phoneNumber = phoneNumber.replaceFirst("233", "+233");
  }

  return phoneNumber;
}
