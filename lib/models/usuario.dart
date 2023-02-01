class Usuario {
  late bool online;
  late String email;
  late String nombre;
  late String uid;

  Usuario({
    required this.uid,
    required this.nombre,
    required this.email,
    required this.online,
  });
}