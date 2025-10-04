import 'package:equatable/equatable.dart';

/// Entidade que representa um usuário do Discord no domínio da aplicação
class User extends Equatable {
  final String id;
  final String discordId;
  final String username;
  final String? email;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.discordId,
    required this.username,
    this.email,
    this.avatarUrl,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    discordId,
    username,
    email,
    avatarUrl,
    createdAt,
    updatedAt,
  ];

  User copyWith({
    String? id,
    String? discordId,
    String? username,
    String? email,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      discordId: discordId ?? this.discordId,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
