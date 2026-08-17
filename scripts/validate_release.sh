#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

printf '%s\n' '== Preflight =='
./scripts/preflight.sh

if ! command -v flutter >/dev/null 2>&1; then
  echo "ERROR: Flutter no está instalado o no está en PATH." >&2
  exit 1
fi

mkdir -p build/reports

echo "== Flutter doctor =="
flutter doctor -v | tee build/reports/flutter-doctor.txt

echo "== Dependencies =="
flutter pub get

echo "== Format =="
dart format --output=none --set-exit-if-changed lib test | tee build/reports/dart-format.txt

echo "== Analyze =="
flutter analyze | tee build/reports/flutter-analyze.txt

echo "== Tests =="
flutter test | tee build/reports/flutter-test.txt

echo "== Web release =="
flutter build web --release | tee build/reports/flutter-build-web.txt

echo "== Android AAB release =="
flutter build appbundle --release --analyze-size | tee build/reports/flutter-build-aab.txt

echo "== Outputs =="
find build -maxdepth 3 -type f \( -name '*.aab' -o -name '*.json' -o -name '*.html' \) -printf '%p %s bytes\n' \
  | sort | tee build/reports/output-sizes.txt

echo "Validación completada. Revisa build/reports/ y no compartas archivos de firma ni secretos."
