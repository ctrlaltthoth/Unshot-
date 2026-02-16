# Indexing Pipeline

## 1) Ingestion strategy (Picker-first)
- Default onboarding uses `PHPickerViewController` batch selection.
- This avoids broad Photos permission and respects limited-library controls.
- Optional upgrade: connect PhotoKit screenshots smart album (`PHAssetCollectionSubtype.smartAlbumScreenshots`) for continuous sync.

## 2) OCR (Vision, on-device)
- `VNRecognizeTextRequest` fast pass runs first.
- If fast quality is insufficient (short text / low confidence), run accurate pass.
- OCR output is stored as `OCRDocument` with quality and version markers.

## 3) Classification + extraction
- Deterministic keyword classifier assigns categories.
- Extractor plugins generate artifacts (ExpenseRow, ShoppingList, EventCard, PackSummary, Snippet).
- No external AI calls.

## 4) Incremental indexing
- Cache per-asset OCR/version fingerprints.
- Skip unchanged assets.
- Resume on next launch using persistent job queue state.

## 5) Performance bars
- Show progressive category counts and ready artifacts while indexing.
- Target visible value under 60 seconds for 50 screenshots.
- Never block UI; user can cancel indexing.
