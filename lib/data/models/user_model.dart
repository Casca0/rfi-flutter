import '../../domain/entities/user.dart';
import 'package:pocketbase/pocketbase.dart';

/// Modelo de dados para User que implementa serialização JSON
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.discordId,
    required super.username,
    super.avatarUrl,
    required super.createdAt,
    super.updatedAt,
  });

  /// Cria UserModel a partir de JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      discordId: json['discord_id'] ?? json['id'] ?? '',
      username: json['username'] ?? json['global_name'] ?? '',
      avatarUrl: json['avatar_url'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  /// Converte UserModel para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'discord_id': discordId,
      'username': username,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Cria UserModel a partir de um record do PocketBase
  factory UserModel.fromPocketBaseRecord(RecordModel record) {
    final username = record.getStringValue(
      'username',
      record.getStringValue('discord_username', record.getStringValue('name')),
    );

    return UserModel(
      id: record.id,
      discordId: record.getStringValue('discord_id', record.id),
      username: username,
      avatarUrl: record.getStringValue('avatar_url'),
      createdAt: DateTime.tryParse(record.get('created')) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(record.get('updated')),
    );
  }

  /// Converte para Entity do domínio
  User toEntity() {
    return User(
      id: id,
      discordId: discordId,
      username: username,
      email: email,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
