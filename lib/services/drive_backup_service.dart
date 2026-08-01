import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import '../data/database/app_database.dart';

class DriveBackupService {
  static const _fileName = 'motocheck_backup.json';

  // ── Cliente HTTP autenticado con las credenciales de la cuenta Google ──────

  static Future<_AuthClient> _authClient(GoogleSignInAccount account) async {
    final headers = await account.authHeaders;
    return _AuthClient(headers);
  }

  // ── Buscar archivo de respaldo existente en appDataFolder ─────────────────

  static Future<String?> _existingFileId(drive.DriveApi api) async {
    final list = await api.files.list(
      spaces: 'appDataFolder',
      q: "name='$_fileName'",
      $fields: 'files(id)',
    );
    return list.files?.firstOrNull?.id;
  }

  /// Devuelve la fecha de modificación del respaldo en Drive, o null si no existe.
  static Future<DateTime?> getLastBackupTime({
    required GoogleSignInAccount account,
  }) async {
    final client = await _authClient(account);
    try {
      final api = drive.DriveApi(client);
      final list = await api.files.list(
        spaces: 'appDataFolder',
        q: "name='$_fileName'",
        $fields: 'files(id,modifiedTime)',
      );
      return list.files?.firstOrNull?.modifiedTime;
    } catch (_) {
      return null;
    } finally {
      client.close();
    }
  }

  // ── Respaldar ─────────────────────────────────────────────────────────────

  static Future<void> backup({
    required AppDatabase db,
    required GoogleSignInAccount account,
  }) async {
    final client = await _authClient(account);
    try {
      final api = drive.DriveApi(client);
      final jsonMap = await db.exportToJson();
      final bytes = utf8.encode(jsonEncode(jsonMap));
      final media = drive.Media(
        Stream.fromIterable([bytes]),
        bytes.length,
        contentType: 'application/json',
      );
      final fileId = await _existingFileId(api);
      if (fileId != null) {
        await api.files.update(
          drive.File()..name = _fileName,
          fileId,
          uploadMedia: media,
        );
      } else {
        await api.files.create(
          drive.File()
            ..name = _fileName
            ..parents = ['appDataFolder'],
          uploadMedia: media,
        );
      }
    } finally {
      client.close();
    }
  }

  // ── Restaurar ─────────────────────────────────────────────────────────────

  /// Devuelve true si encontró y restauró un respaldo, false si no existe ninguno.
  static Future<bool> restore({
    required AppDatabase db,
    required GoogleSignInAccount account,
  }) async {
    final client = await _authClient(account);
    try {
      final api = drive.DriveApi(client);
      final fileId = await _existingFileId(api);
      if (fileId == null) return false;

      final media = await api.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final chunks = <int>[];
      await for (final chunk in media.stream) {
        chunks.addAll(chunk);
      }

      final jsonMap = jsonDecode(utf8.decode(chunks)) as Map<String, dynamic>;
      await db.importFromJson(jsonMap);
      return true;
    } finally {
      client.close();
    }
  }
}

// ── Cliente HTTP que inyecta los headers de autenticación de Google ──────────

class _AuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final _inner = http.Client();

  _AuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();
}
