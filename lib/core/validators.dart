class Validators {
  static String? name(String? v) {
    if (v == null || v.trim().isEmpty) return 'Вкажіть імʼя';
    if (v.contains(RegExp(r'[0-9]'))) return 'Імʼя не може містити цифри';
    return null;
  }

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Вкажіть email';
    if (!v.contains('@')) return 'Невірний email';
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Введіть пароль';
    if (v.length < 6) return 'Мінімум 6 символів';
    return null;
  }
}
