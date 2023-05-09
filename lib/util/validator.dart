String? validateName(String? name) {
  if (name == null || name.trim().isEmpty) {
    return 'Name cannot be empty.';
  } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name.trim())) {
    return 'Name must contain only letters and spaces.';
  } else {
    return null;
  }
}

String? validateEmail(String? email) {
  if (email == null || email.trim().isEmpty) {
    return 'Email cannot be empty.';
  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
      .hasMatch(email.trim())) {
    return 'Invalid email format.';
  } else {
    return null;
  }
}

String? validatePassword(String? password) {
  if (password == null || password.trim().isEmpty) {
    return 'Password cannot be empty.';
  } else if (password.length < 8) {
    return 'Password must be at least 8 characters long.';
  } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
    return 'Password must contain at least one uppercase letter.';
  } else if (!RegExp(r'[a-z]').hasMatch(password)) {
    return 'Password must contain at least one lowercase letter.';
  } else if (!RegExp(r'[0-9]').hasMatch(password)) {
    return 'Password must contain at least one number.';
  } else {
    return null;
  }
}
