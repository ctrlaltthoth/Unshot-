# Transfer to Replit

Use the packaging script to build a clean zip you can upload to Replit.

## Build archive

```bash
./scripts/package_for_replit.sh
```

This writes:

- `dist/unshot-replit-<timestamp>.zip`
- `dist/unshot-replit-latest.zip`

## Replit import

1. Open Replit and create/import a project.
2. Upload `dist/unshot-replit-latest.zip`.
3. Unzip it in the Replit shell:

```bash
unzip unshot-replit-latest.zip -d unshot
cd unshot
```

4. Web companion (optional):

```bash
cd web/unshot-web
npm install
npm run dev
```

5. Python tests:

```bash
cd ../../tests
python -m pytest
```
