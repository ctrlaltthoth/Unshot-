import SwiftUI

struct HomeView: View {
    @State private var indexing = false

    private let tiles: [(String, String)] = [
        ("Receipts", "6 (4 totals ready)"),
        ("Recipes", "5 (3 shopping lists ready)"),
        ("Tickets", "2 (2 event cards ready)"),
        ("Confirmations", "3 (3 packs ready)")
    ]

    var body: some View {
        NavigationStack {
            List {
                Section("Convert screenshots into useful things") {
                    Button("Select screenshots") {}
                    Button("Connect Screenshots Album") {}
                        .foregroundStyle(.secondary)
                }

                Section("Categories") {
                    ForEach(tiles, id: \.0) { tile in
                        NavigationLink {
                            CategoryListView(title: tile.0)
                        } label: {
                            HStack {
                                Text(tile.0)
                                Spacer()
                                Text(tile.1)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                if indexing {
                    Section {
                        HStack {
                            ProgressView()
                            Text("Indexing screenshots…")
                            Spacer()
                            Button("Cancel") { indexing = false }
                        }
                    }
                }
            }
            .navigationTitle("Unshot")
            .searchable(text: .constant(""))
        }
    }
}

struct CategoryListView: View {
    let title: String

    var body: some View {
        List {
            Text("Filters: date range, has total, has URL, converted")
            Text("Sort: newest, highest confidence, most useful")
            NavigationLink("Sample item") {
                DetailView()
            }
        }
        .navigationTitle(title)
    }
}

struct DetailView: View {
    var body: some View {
        List {
            Section("Extracted Fields") {
                Text("Total: $45.80")
                Text("Date: 2026-02-10")
                Text("URL: https://example.com")
            }
            Section("OCR Text") {
                Text("Collapsed OCR preview…")
            }
            Section {
                Button("Convert") {}
                Button("Add to Pack") {}
                Button("Export") {}
            }
        }
        .navigationTitle("Detail")
    }
}
