"use client";

import { useMemo, useState } from "react";
import { artifactsToCSV, mergePacks, Pack } from "../lib/pack";

export function PackHub() {
  const [packs, setPacks] = useState<Pack[]>([]);

  const merged = useMemo(() => (packs.length ? mergePacks(packs) : null), [packs]);

  const onFile = async (file: File) => {
    const text = await file.text();
    const parsed = JSON.parse(text) as Pack;
    setPacks((curr) => [...curr, parsed]);
  };

  const downloadCSV = () => {
    if (!merged) return;
    const blob = new Blob([artifactsToCSV(merged.artifacts)], { type: "text/csv" });
    const a = document.createElement("a");
    a.href = URL.createObjectURL(blob);
    a.download = "merged-pack.csv";
    a.click();
  };

  return (
    <div className="space-y-6">
      <section className="rounded border border-slate-700 p-4">
        <h1 className="text-2xl font-semibold">Unshot Pack Hub</h1>
        <p className="text-slate-300">Upload exported Pack JSON files from iOS and merge artifact exports.</p>
        <input
          className="mt-4 block"
          type="file"
          accept="application/json"
          onChange={(e) => {
            const file = e.target.files?.[0];
            if (file) onFile(file);
          }}
        />
      </section>

      <section className="grid gap-3">
        {packs.map((pack) => (
          <article key={pack.id} className="rounded border border-slate-700 p-4">
            <h2 className="font-semibold">{pack.title}</h2>
            <p className="text-sm text-slate-300">{pack.artifacts.length} artifacts • {pack.assetIds.length} assets</p>
          </article>
        ))}
      </section>

      {merged && (
        <section className="rounded border border-emerald-700 p-4">
          <h2 className="font-semibold">Merged output ready</h2>
          <p className="text-sm text-slate-300">{merged.artifacts.length} artifacts combined.</p>
          <button className="mt-3 rounded bg-emerald-600 px-3 py-2" onClick={downloadCSV}>Export merged CSV</button>
        </section>
      )}
    </div>
  );
}
