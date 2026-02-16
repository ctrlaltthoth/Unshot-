# Unshot Architecture

## Core thesis
Unshot is a converter, not a cleaner. The product surface is optimized for "ready artifacts" from screenshots (expenses, shopping lists, event cards, pack summaries).

## Monorepo layout
- `ios/Unshot/`: SwiftUI iOS app.
- `web/unshot-web/`: Next.js App Router companion for rendering and merging exported packs.
- `shared/schema/`: JSON schemas for Pack and Artifact.
- `tests/`: classifier, parser, and dedupe tests.

## iOS storage choice: GRDB (SQLite)
We choose SQLite via GRDB for:
1. deterministic migrations,
2. small local footprint,
3. direct SQL control for indexing and dedupe scans,
4. simple portability to web/export workflows.

## Pipeline order (required build order)
1. Vertical slice: Picker import -> fast OCR -> categorize -> home tiles -> list -> detail.
2. Extraction artifacts.
3. Packs and export.
4. Dedupe.
5. Optional PhotoKit screenshots album sync.
6. Web companion pack rendering + merge/export.

## Concurrency and resiliency
- Actor-backed job queue with throttling hooks.
- Persistent job state + backoff + cancellation.
- Low Power Mode can reduce concurrency and skip accurate OCR pass.
