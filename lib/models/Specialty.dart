enum Specialty {
  generaliste('Médecine générale'),
  cardio('Cardiologie'),
  pediatrie('Pédiatrie'),
  gyneco('Gynécologie-Obstétrique'),
  dermato('Dermatologie'),
  orl('ORL et Chirurgie'),
  ophtalmo('Ophtalmologie'),
  gastro('Gastro-Entérologie'),
  pneumo('Pneumologie'),
  dentiste('Dentisterie');

  final String displayName;

  const Specialty(this.displayName);

  static Specialty? fromString(String? value) {
    if (value == null) return null;
    return Specialty.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw FormatException('Invalid specialty: $value'),
    );
  }
}