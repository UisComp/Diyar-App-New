# Diyar App — CI/CD with Fastlane

This repo builds and distributes the Flutter app via **Fastlane**, driven by a
**GitHub Actions** workflow (`.github/workflows/flutter.yml`).

## What runs

The pipeline triggers on **`push` to `production` or `testing`** (or manually via
the *Run workflow* button → `workflow_dispatch`). Each push runs two parallel
jobs (Android + iOS), and the destination depends on **which branch** you pushed:

| Branch | Android → Google Play | iOS → App Store Connect |
|--------|-----------------------|--------------------------|
| `testing` | `internal` testing track | **TestFlight** (`fastlane ios testflight`) |
| `production` | `production` track | **App Store review** (`fastlane ios release`) |

So the flow is simply: **push to `testing` = تجريبي**, **push to `production` = إنتاج**.

| Job | Runner | Fastlane lane |
|-----|--------|---------------|
| Android | `ubuntu-latest` | `fastlane android playstore` (track chosen by branch) |
| iOS | `macos-14` | `fastlane ios testflight` (testing) / `fastlane ios release` (production) |

> The `firebase` / `beta` lanes (which also push to Firebase App Distribution)
> still exist in the Fastfiles and can be run manually — but the CI workflow
> above uses only Google Play + App Store, so **Firebase secrets are optional**
> unless you run those lanes yourself.

## Running locally

```bash
# Android (from android/)
cd android && bundle install
bundle exec fastlane android firebase     # Firebase only
bundle exec fastlane android playstore    # Google Play only
bundle exec fastlane android beta         # both

# iOS (from ios/, on a Mac)
cd ios && bundle install
bundle exec fastlane ios firebase         # Firebase only
bundle exec fastlane ios testflight       # TestFlight only
bundle exec fastlane ios beta             # both
```

When running locally, the lanes read the same env vars listed below. Easiest is
to drop the secret files in place (`fastlane/firebase-service-account.json`,
`fastlane/play-service-account.json`) and `export` the iOS variables.

---

## Create the two branches (production + testing)

The workflow only fires on these branches, so create and push them once from the
repo root:

```bash
# make sure main is up to date first
git checkout main
git pull

# production branch
git checkout -b production
git push -u origin production

# testing branch
git checkout main
git checkout -b testing
git push -u origin testing
```

From then on: **`git push origin testing` = تجريبي**, **`git push origin production` = إنتاج**.

---

## GitHub Secrets to configure

Add these under **Repo → Settings → Secrets and variables → Actions → New repository secret**.

### Android

| Secret | What it is / how to get it |
|--------|----------------------------|
| `GOOGLE_SERVICES_JSON` | Full contents of `android/app/google-services.json` (Firebase console → Project settings → your Android app). |
| `ANDROID_KEYSTORE_BASE64` | Your upload keystore, base64-encoded. Generate: `base64 -w0 android/app/upload-keystore.jks` (macOS: `base64 -i ... | tr -d '\n'`). |
| `ANDROID_STORE_PASSWORD` | `storePassword` from your current `android/key.properties`. |
| `ANDROID_KEY_PASSWORD` | `keyPassword` from `key.properties`. |
| `ANDROID_KEY_ALIAS` | `keyAlias` from `key.properties`. |
| `FIREBASE_SERVICE_ACCOUNT_JSON` | *(Optional — only needed for the `firebase` lane, not used by the CI workflow.)* Google service-account JSON with the **Firebase App Distribution Admin** role. |
| `PLAY_SERVICE_ACCOUNT_JSON` | Google Play service-account JSON. Play Console → Setup → API access → create/link a service account, grant it **Release to testing tracks**, download the JSON. |

> **First Google Play upload must be manual.** Play requires the very first
> `.aab` for a new app to be uploaded by hand through the console. After that,
> the workflow handles everything: pushing to `testing` uploads to the
> **internal** track, pushing to `production` uploads to the **production**
> track (both `release_status: completed`). The branch → track mapping lives in
> the workflow (`PLAY_TRACK`), not in the Fastfile.

### iOS

| Secret | What it is / how to get it |
|--------|----------------------------|
| `IOS_GOOGLE_SERVICE_INFO_PLIST` | Contents of `ios/Runner/GoogleService-Info.plist` (Firebase console → your iOS app). |
| `FIREBASE_SERVICE_ACCOUNT_JSON` | Same JSON as Android (Firebase App Distribution Admin). |
| `ASC_KEY_ID` | App Store Connect API key ID. App Store Connect → Users and Access → Integrations → App Store Connect API → generate a key (role: App Manager). |
| `ASC_ISSUER_ID` | The Issuer ID shown on that same API keys page. |
| `ASC_KEY_CONTENT` | The downloaded `.p8` key, **base64-encoded**: `base64 -i AuthKey_XXXX.p8 | tr -d '\n'`. (The Fastfile decodes it.) |
| `MATCH_GIT_URL` | URL of a **private** git repo that stores your signing certs/profiles (e.g. `https://github.com/uiscom/diyar-certificates.git`). |
| `MATCH_PASSWORD` | The passphrase used to encrypt the match repo. |
| `MATCH_GIT_BASIC_AUTHORIZATION` | Base64 of `username:personal_access_token` so CI can clone the private match repo: `echo -n "user:ghp_xxx" | base64`. |

---

## One-time iOS code-signing setup (match) — **no Mac needed**

Code signing on CI uses [`match`](https://docs.fastlane.tools/actions/match).
You do **not** need a Mac: there's a one-time bootstrap workflow that generates
the certs/profiles on GitHub's own macOS runner and stores them in your private
match repo.

Steps:

1. Create an **empty private** GitHub repo to hold the encrypted certs, e.g.
   `uiscom/diyar-certificates`.
2. Add the iOS secrets to the **app** repo: `ASC_KEY_ID`, `ASC_ISSUER_ID`,
   `ASC_KEY_CONTENT`, plus:
   - `MATCH_GIT_URL` = `https://github.com/uiscom/diyar-certificates.git`
   - `MATCH_PASSWORD` = any strong passphrase you choose (remember it)
   - `MATCH_GIT_BASIC_AUTHORIZATION` = base64 of `username:PAT`
     (`echo -n "user:ghp_xxx" | base64` — the PAT needs repo access to the certs repo)
3. Go to **Actions → “iOS Signing Bootstrap (run once)” → Run workflow**.
   It runs `fastlane ios bootstrap_signing` on a macOS runner, creates the App
   Store distribution cert + provisioning profile, and pushes them (encrypted) to
   the certs repo.

After it succeeds once, every deploy on `testing`/`production` fetches those certs
automatically (`match` in `readonly` mode). Bundle ID `com.uis.diyariosapp`,
Team ID `4W6AGQ2622`.

---

## Notes & gotchas

- **Versioning** comes from `pubspec.yaml` (`version: 1.2.3+1`). Bump it before
  cutting a release; TestFlight/Play reject duplicate build numbers.
- The Android `key.properties`, keystore, and all `*-service-account.json` /
  `.p8` files are **git-ignored** (see `.gitignore`) — they live only in GitHub
  Secrets, never in the repo.
- The iOS lanes force **manual signing** with the match profile during the build
  (`update_code_signing_settings`). Your Xcode project stays on Automatic for
  local dev; CI flips it only for the build.
- To distribute to a different Firebase tester group, change `groups: "testers"`
  in both Fastfiles.
- Both jobs upload the built APK/IPA as a downloadable GitHub **Actions artifact**.
