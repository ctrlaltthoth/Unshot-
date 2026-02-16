# Unshot Privacy Pledge

## Plain-language promise
- On-device by default.
- No screenshot uploads.
- No analytics SDKs in MVP.
- No ad tracking.

## What data is processed
- Selected screenshots from Photos Picker (or optional Screenshots album if user enables it).
- OCR text and structured artifacts generated locally.
- Exported files are user-initiated and stay in user-controlled destinations.

## What is not collected
- No remote image processing.
- No behavioral analytics events tied to user identity.
- No third-party ad identifiers.

## Deletion behavior
- Duplicate cleanup uses Photos deletion APIs so items move to "Recently Deleted".
- App-local indexing metadata can be cleared from app settings.
