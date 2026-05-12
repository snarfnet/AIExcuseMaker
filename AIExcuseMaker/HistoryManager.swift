import Foundation
import Combine

final class HistoryManager: ObservableObject {
    @Published private(set) var results: [ExcuseResult] = []

    private let storageKey = "ai_excuse_maker_history_v1"
    private let maxFreeItems = 30

    init() {
        load()
    }

    func save(_ result: ExcuseResult) {
        guard results.contains(where: { $0.id == result.id }) == false else { return }
        results.insert(result, at: 0)
        if results.count > maxFreeItems {
            results = Array(results.prefix(maxFreeItems))
        }
        persist()
    }

    func delete(at offsets: IndexSet) {
        for index in offsets.sorted(by: >) {
            results.remove(at: index)
        }
        persist()
    }

    func delete(_ result: ExcuseResult) {
        results.removeAll { $0.id == result.id }
        persist()
    }

    func clear() {
        results.removeAll()
        persist()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        results = (try? JSONDecoder().decode([ExcuseResult].self, from: data)) ?? []
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(results) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
