# NovaTube — Master Technical Blueprint

Status: Approved product direction; implementation blueprint v1
Date: 2026-11-26

## 1. Scope and exclusions

NovaTube is a new Android-first Flutter application. It must have its own UI, Dart/Kotlin source, package identity, architecture, state management, persistence, player integration, and build/release process.

The existing FluxTube project is a research reference only. Do not copy its UI, app modules, database, architecture, or source files into NovaTube. Do not edit the root FluxTube application. The current `novatube/` directory is a FluxTube-derived prototype (including `package:fluxtube` imports and a FluxTube namespace); it is not accepted as the clean foundation. New implementation starts in `nova_app/`.

Explicitly excluded from this work: Google Sign-In integration and live runtime availability checks. Do not spend implementation time on either.

## 2. Locked product and visual specification

- Product name: NovaTube
- Product promise: premium video experience, AI-powered learning, personal media
- Slogan: “Watch. Learn. Create.”
- Platform priority: Android
- Theme: dark-only Premium AMOLED
- Primary background: #000000
- Deep navy: #080D18
- Surface: #111722
- Elevated surface: #182233
- Primary accent: #1677FF
- Bright accent: #54B5FF
- Main text: #FFFFFF
- Secondary text: #9BA8BB
- Muted text: #64748B
- Border: #263247
- Semantic colors: success #22C55E, warning #F59E0B, error #EF4444
- Typography: modern sans; select and bundle a consistent font with Hindi and English glyph coverage.
- Preserve the existing NovaTube logo asset exactly; locate and verify the actual asset before wiring it into launcher/splash. Do not redraw or fabricate a replacement.
- Bottom navigation: exactly five tabs — Home, Explore, Search, Library, Profile. AI Studio is entered from video/learning surfaces, not as a sixth tab.

### Primary product areas

1. Home: discovery, continue watching, curated video rows.
2. Explore: categories and discovery.
3. Search: query, suggestions, filters, results, pagination, history.
4. Video experience: player, details, channel, comments, related content, chapters, captions.
5. AI Studio: summary, contextual chat, transcript, Hindi translation, mind map, smart chapters, AI notes, Study Mode.
6. Library: Watch Later, playlists, bookmarks, history, continue watching, notes, personal media.
7. Smart Media Manager: queue, pause/resume where supported, progress, storage and filename management. Only user-owned, licensed, or otherwise authorized media may be downloaded; do not bypass platform restrictions.
8. Profile and settings: playback, language, privacy, storage, accessibility and app preferences.

### Player interaction requirements

- Double tap left/right to seek by 10 seconds.
- Vertical swipe zones for brightness and volume, with platform permission/API constraints respected.
- Pinch zoom only when supported by the chosen rendering surface.
- Mini-player drag/dismiss behavior.
- Tapping a transcript timestamp seeks to that position.
- Provide clear loading, restricted/unavailable, retry, and network error states.

## 3. Independent application architecture

Use a feature-first structure with explicit layers and contracts. Suggested initial structure:

```text
nova_app/
  android/
  assets/
  docs/
  lib/
    app/
      bootstrap/
      navigation/
      theme/
    core/
      errors/
      networking/
      storage/
      platform/
      widgets/
    features/
      home/
      explore/
      search/
      video/
      player/
      channels/
      playlists/
      library/
      ai_studio/
      media_manager/
      profile/
      settings/
    main.dart
  test/
  pubspec.yaml
  analysis_options.yaml
```

Rules:
- No imports from `package:fluxtube/`.
- No reuse of FluxTube application feature modules or app database.
- Define NovaTube-owned domain models and provider interfaces.
- Keep UI, application orchestration, domain contracts, data adapters and Android platform implementation separate.
- Add dependencies only when a concrete feature needs them; record rationale and license.
- Keep secrets out of source control.

## 4. YouTube/media access research findings

The FluxTube source review established this technical pattern (research findings, not an endorsement or compliance determination):

- Flutter calls Android Kotlin through a MethodChannel named `com.fazilvk.fluxtube/newpipe`.
- Kotlin `NewPipeMethodHandler` invokes NewPipe Extractor using a custom OkHttp-backed downloader.
- The reviewed FluxTube dependency set included NewPipe Extractor v0.27.1, OkHttp 4.12.0, Gson 2.11.0, Kotlin Coroutines 1.8.1, and AndroidX Media3 1.4.1.
- FluxTube exposes extraction operations for stream info, fast stream info, trending, search, suggestions, channels/tabs, comments/replies, playlists and related streams.
- SearchBloc chooses Piped, Invidious or NewPipe according to the selected service type; this is explicit provider routing, not an automatic all-provider race.
- Watch screens similarly use provider-specific paths: Piped, Invidious, NewPipe and YouTube Explode. WatchImpl exposes methods for these paths; the source review did not establish a universal automatic fallback chain.
- The NewPipe player path resolves available HLS, DASH, merged audio/video or progressive sources and passes a playback configuration to a native Media3/ExoPlayer surface.
- Piped and Invidious are third-party instance APIs and may become unavailable or rate limited.
- YouTube Explode is a separate Dart extraction library, not the same as official YouTube Data API.

### NovaTube access design

Create NovaTube-owned interfaces and adapters; do not port FluxTube code:

- `MediaCatalogProvider`: discovery/search/catalog metadata contract.
- `SearchProvider`: search, suggestions and pagination.
- `VideoDetailsProvider`: metadata, channel, chapters and captions when available.
- `CommentProvider`: comments and pagination when supported.
- `PlaybackSourceProvider`: returns only source descriptors that are permitted and technically available.
- `ProviderCoordinator`: explicit provider selection, health/error state and controlled fallback policy. Never silently imply every provider is available.
- `NovaPlaybackController`: owns playback lifecycle and communicates with a native player abstraction where appropriate.
- `CaptionRepository`: caption source, language and provenance.
- `ExtractionCache`: bounded TTL cache; do not cache expiring media URLs beyond safe lifetimes.

Provider order must be configurable and documented. Provider failure must be visible and recoverable. Do not promise a working YouTube extractor or stream for all videos, regions, accounts, or devices.

### Compliance and licensing gate

NewPipe/Piped/Invidious/YouTube Explode extraction can raise platform-terms, distribution, copyright, privacy and open-source-license issues. Technical feasibility is not legal permission. Before enabling an adapter in a distributed build:
- review current YouTube Terms and applicable API policies;
- review NewPipe Extractor license obligations (including GPL-3.0 implications) and all dependency licenses;
- do not bypass DRM, age gates, access controls, paywalls or rate limits;
- do not implement unauthorized downloading, audio-only extraction, or restricted background playback;
- prefer official/authorized playback and media sources where required;
- provide attribution and playback behavior consistent with the applicable platform requirements.

This blueprint records the FluxTube mechanism for research. It does not certify that reproducing it is permitted.

## 5. Playback architecture

Keep the Flutter player controls separate from the native playback engine. Define a platform-neutral player contract with operations for load, play, pause, seek, speed, track selection, captions, resize mode, position/duration and lifecycle.

The Android implementation may use Media3 after a separate dependency/license/policy review. The resolver must model:
- HLS manifest source;
- DASH manifest source;
- single progressive source;
- separate audio/video source only where combining them is permitted and technically supported.

Handle expiring URLs, live streams, unsupported codecs, restricted videos, buffering and lifecycle/PiP explicitly. Do not assume every source has every stream type.

## 6. Data, persistence and AI Studio

- Use NovaTube-owned schema and migrations; choose local persistence only after defining required entities and migrations.
- Initial entities: video reference/metadata cache, watch progress, playlist, bookmark, history, note, caption reference and download task metadata.
- Do not store credentials or sensitive tokens in plain preferences.
- AI Studio must consume captions/transcripts only when lawfully and technically available; show source/language and distinguish generated summaries/translations from original captions.
- AI features must fail gracefully when transcripts are unavailable.

## 7. APK build and release pipeline

Research audit of the existing workflow showed a Flutter debug APK workflow using GitHub Actions, Java 17, Flutter stable (the audited workflow pinned 3.47.1), `flutter pub get`, `flutter build apk --debug`, and artifact upload.

NovaTube must own a separate workflow rooted at `nova_app/`. Initial CI:
1. checkout;
2. Java 17 setup;
3. Flutter stable setup with a pinned, verified version;
4. `flutter pub get`;
5. `dart format --output=none --set-exit-if-changed .`;
6. `flutter analyze`;
7. `flutter test`;
8. debug APK build and artifact upload.

Release APK signing is a later phase and must use GitHub Secrets or a secure local keystore process. Never commit keystore files or passwords. A successful build is not proof that app features or provider access work.

## 8. Implementation phases and acceptance gates

### Phase 0 — Clean foundation
- Create a fresh Flutter project in `nova_app/`.
- Set a unique applicationId and namespace (proposed: `app.novatube.mobile`; verify availability before store publication).
- Establish dark theme tokens, typography, app shell and five-tab navigation.
- Confirm no FluxTube package imports or source files in the new project.
- Add CI and pass format/analyze/test/debug build.

### Phase 1 — Core shell
- Implement navigation, reusable components, loading/error/empty states, settings foundation and local persistence.
- Verify the exact existing NovaTube logo asset.

### Phase 2 — Access contracts and metadata
- Implement provider interfaces and normalized NovaTube models.
- Add provider adapters only after license and platform-policy gate.
- Test mapping, pagination, timeouts, rate-limit and error handling with fixtures/mocks.

### Phase 3 — Player
- Implement player abstraction and Android Media3 adapter if approved.
- Test lifecycle, seek, speed, captions, quality selection, live and error cases.

### Phase 4 — Product features
- Search, Home/Explore, channel/video detail, Library, AI Studio and authorized media manager.

### Phase 5 — QA and release
- Device tests, accessibility, performance, dependency/license audit, debug APK, signed release APK and install verification.

## 9. Current implementation boundary

The repository currently contains a `novatube/` directory whose pubspec package name is `fluxtube`, whose main.dart imports `package:fluxtube/`, and whose Android namespace is `com.fazilvk.fluxtube` despite a NovaTube applicationId. It is therefore not a clean independent NovaTube foundation. Preserve it as a legacy research prototype; do not extend it. Start new source under `nova_app/`.

Google Sign-In integration and live runtime availability checks are explicitly out of scope per user direction.
