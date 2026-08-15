#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

failures=0

fail() {
  printf 'ERROR: %s\n' "$1" >&2
  failures=$((failures + 1))
}

printf '%s\n' '== MotoCheck preflight =='

printf '%s\n' '== Repository =='
git rev-parse --is-inside-work-tree >/dev/null || fail 'No se encontró un repositorio Git.'
git status --short

printf '%s\n' '== Forbidden tracked files =='
for pattern in \
  'android/key.properties' \
  '*.jks' \
  '*.keystore' \
  'GoogleService-Info.plist' \
  'google-services.json' \
  '.env' \
  '.env.*'; do
  matches=$(git ls-files -- "$pattern")
  if [[ -n "$matches" ]]; then
    printf '%s\n' "$matches"
    fail "Hay archivos sensibles rastreados que coinciden con $pattern"
  fi
done

printf '%s\n' '== Required templates =='
for path in \
  android/key.properties.example \
  ios/Runner/GoogleSignInConfig.example.xcconfig \
  ios/Runner/GoogleSignInInfo.plist.example \
  web/google_sign_in_config.example.json \
  docs/ENGINEERING_ALGORITHM.md \
  docs/REQUIREMENTS_REGISTER.md; do
  [[ -f "$path" ]] || fail "Falta $path"
done

printf '%s\n' '== Local-first entrypoint =='
if grep -R --include='*.dart' -nE 'AuthGate|AuthScreen' lib test >/dev/null; then
  fail 'Persisten referencias al flujo de login obligatorio.'
fi
if ! grep -q 'home: const MainShell()' lib/app.dart; then
  fail 'MotoCheck no inicia directamente en MainShell.'
fi

printf '%s\n' '== OAuth variable routing =='
if ! grep -q 'GOOGLE_WEB_CLIENT_ID' lib/services/google_auth_service.dart; then
  fail 'No se encontró la variable GOOGLE_WEB_CLIENT_ID.'
fi
if ! grep -q 'GOOGLE_IOS_CLIENT_ID' lib/services/google_auth_service.dart; then
  fail 'No se encontró la variable GOOGLE_IOS_CLIENT_ID.'
fi

if ((failures > 0)); then
  printf 'Preflight finalizó con %d error(es).\n' "$failures" >&2
  exit 1
fi

printf '%s\n' 'Preflight completado correctamente.'
