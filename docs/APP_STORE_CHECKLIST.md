# App Store Checklist

## Privacy details
- Data linked to user: none in MVP.
- Data used for tracking: none.
- Photos access: user-selected (Picker-first), optional broad/limited library for screenshots album sync.

## Permission strings
- `NSPhotoLibraryUsageDescription`: "Unshot reads screenshots you select to convert them into expenses, shopping lists, and travel/event packs on your device."
- `NSPhotoLibraryAddUsageDescription`: "Unshot can help remove duplicates by moving selected photos to Recently Deleted."

## Review posture
- Explain picker-first onboarding in submission notes.
- Clarify that OCR uses on-device Vision framework.
- Clarify no external AI APIs are used.

## Compliance files to keep updated
- `docs/PRIVACY.md`
- `docs/APP_STORE_CHECKLIST.md`
- `docs/INDEXING_PIPELINE.md`
