import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var historyManager: HistoryManager

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        ZStack {
            AppBackground()

            if historyManager.results.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "tray")
                        .font(.system(size: 46, weight: .bold))
                        .foregroundStyle(.white.opacity(0.52))

                    Text("履歴はまだありません")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)

                    Text("生成した言い訳はここに保存されます。")
                        .foregroundStyle(.white.opacity(0.64))
                }
                .padding(24)
            } else {
                VStack(spacing: 10) {
                    List {
                        ForEach(historyManager.results) { result in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text(result.category.rawValue)
                                        .font(.caption.weight(.bold))
                                        .padding(.horizontal, 9)
                                        .padding(.vertical, 5)
                                        .background(.cyan.opacity(0.22), in: Capsule())

                                    Text(result.tone.rawValue)
                                        .font(.caption.weight(.bold))
                                        .padding(.horizontal, 9)
                                        .padding(.vertical, 5)
                                        .background(.orange.opacity(0.22), in: Capsule())

                                    Spacer()
                                }

                                Text(result.text)
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(.white)
                                    .lineSpacing(4)

                                Text(dateFormatter.string(from: result.createdAt))
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.52))
                            }
                            .padding(.vertical, 10)
                            .listRowBackground(Color.white.opacity(0.08))
                            .swipeActions {
                                Button(role: .destructive) {
                                    historyManager.delete(result)
                                } label: {
                                    Label("削除", systemImage: "trash")
                                }
                            }
                        }
                        .onDelete(perform: historyManager.delete)
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)

                    AdMobBannerSlotView(placement: .historyBottom)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 12)
                }
            }
        }
        .navigationTitle("履歴")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if historyManager.results.isEmpty == false {
                Button(role: .destructive) {
                    historyManager.clear()
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HistoryView()
    }
    .environmentObject(HistoryManager())
}
