export type Artifact = {
  id: string;
  assetId: string;
  type: string;
  payload: Record<string, string>;
};

export type Pack = {
  id: string;
  title: string;
  type: string;
  createdAt: string;
  assetIds: string[];
  artifacts: Artifact[];
  exports: { path: string; contentType: string; createdAt: string }[];
};

export function mergePacks(packs: Pack[]): Pack {
  return {
    id: "merged-pack",
    title: "Merged Pack",
    type: "merged",
    createdAt: new Date().toISOString(),
    assetIds: packs.flatMap((p) => p.assetIds),
    artifacts: packs.flatMap((p) => p.artifacts),
    exports: []
  };
}

export function artifactsToCSV(artifacts: Artifact[]): string {
  const rows = ["type,assetId,key,value"];
  for (const artifact of artifacts) {
    for (const [key, value] of Object.entries(artifact.payload)) {
      rows.push(`${artifact.type},${artifact.assetId},${key},${String(value).replaceAll(",", " ")}`);
    }
  }
  return rows.join("\n");
}
