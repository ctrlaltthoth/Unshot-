# QA Plan

## Edge cases
- Limited Photos access and revoked access mid-session.
- OCR low-quality screenshots and multilingual text.
- Receipts with multiple totals or tip lines.
- Ingredient lists with unicode fractions.
- Tickets with missing seat/gate lines.
- Duplicate groups with edited/cropped variants.
- App termination mid-index and resume behavior.

## Test plan
- Unit tests for classifier category scoring.
- Parser tests for receipt totals and ingredient extraction.
- Dedupe tests for exact and near duplicate scoring behavior.
- Manual pass for onboarding, conversion actions, pack export, and web upload/merge.
