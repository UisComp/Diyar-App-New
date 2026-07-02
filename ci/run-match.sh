#!/usr/bin/env bash
# One-time iOS code-signing setup — RUN THIS ON A MAC.
#
# It creates the App Store distribution certificate + provisioning profile and
# stores them (encrypted) in your private "certificates" git repo, so the CI
# macOS runner can fetch them in read-only mode.
#
# Usage:
#   1) Create an EMPTY private GitHub repo, e.g.  UisComp/diyar-certificates
#   2) Fill in the values below (or export them in your shell), then:
#        chmod +x ci/run-match.sh && ./ci/run-match.sh
#
set -euo pipefail

# ── Fill these in ──────────────────────────────────────────────────────────
export MATCH_GIT_URL="${MATCH_GIT_URL:-https://github.com/UisComp/diyar-certificates.git}"
export MATCH_PASSWORD="${MATCH_PASSWORD:?Set MATCH_PASSWORD to a strong passphrase}"

export ASC_KEY_ID="${ASC_KEY_ID:?Set ASC_KEY_ID}"
export ASC_ISSUER_ID="${ASC_ISSUER_ID:?Set ASC_ISSUER_ID}"
# Path to the .p8 you downloaded from App Store Connect:
ASC_P8_PATH="${ASC_P8_PATH:?Set ASC_P8_PATH to your AuthKey_XXXX.p8}"
export ASC_KEY_CONTENT="$(base64 -i "$ASC_P8_PATH" | tr -d '\n')"
# ───────────────────────────────────────────────────────────────────────────

cd "$(dirname "$0")/../ios"

if ! command -v bundle >/dev/null 2>&1; then
  echo "Installing bundler..."; gem install bundler
fi

echo "Installing Ruby gems (fastlane)..."
bundle install

echo "Running match (appstore) — this generates and stores your signing assets..."
bundle exec fastlane match appstore \
  --app_identifier "com.uis.diyariosapp" \
  --team_id "4W6AGQ2622" \
  --readonly false

cat <<EOF

✅ match finished.

Now add these GitHub secrets (or pass them to ci/setup-github-secrets.ps1):
  MATCH_GIT_URL                 = $MATCH_GIT_URL
  MATCH_PASSWORD                = (the passphrase you used)
  MATCH_GIT_BASIC_AUTHORIZATION = base64 of "github-username:personal-access-token"
                                  e.g.  echo -n "user:ghp_xxx" | base64

  ASC_KEY_ID                    = $ASC_KEY_ID
  ASC_ISSUER_ID                 = $ASC_ISSUER_ID
  ASC_KEY_CONTENT               = base64 of your .p8 (already computed above)
EOF
