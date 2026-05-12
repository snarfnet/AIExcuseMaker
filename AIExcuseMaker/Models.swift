import Foundation

enum ExcuseCategory: String, CaseIterable, Identifiable, Codable {
    case late = "遅刻"
    case absent = "欠勤"
    case forgotReply = "返信忘れ"
    case dateLate = "デート遅刻"
    case partyCancel = "飲み会ドタキャン"
    case homework = "宿題・課題忘れ"
    case workMistake = "仕事ミス"
    case forgotPromise = "友達との約束忘れ"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .late: "clock.badge.exclamationmark"
        case .absent: "bed.double.fill"
        case .forgotReply: "message.badge"
        case .dateLate: "heart.text.square.fill"
        case .partyCancel: "wineglass.fill"
        case .homework: "book.closed.fill"
        case .workMistake: "briefcase.fill"
        case .forgotPromise: "person.2.fill"
        }
    }

    var imageName: String {
        switch self {
        case .late: "CategoryLate"
        case .absent: "CategoryAbsent"
        case .forgotReply: "CategoryForgotReply"
        case .dateLate: "CategoryDateLate"
        case .partyCancel: "CategoryPartyCancel"
        case .homework: "CategoryHomework"
        case .workMistake: "CategoryWorkMistake"
        case .forgotPromise: "CategoryForgotPromise"
        }
    }
}

enum ExcuseTone: String, CaseIterable, Identifiable, Codable {
    case sincere = "誠実"
    case almostCrying = "ちょい泣き"
    case defensive = "逆ギレ気味"
    case conscious = "意識高い系"
    case cute = "可愛い"
    case professional = "社会人っぽい"
    case suspicious = "ギリギリ怪しい"
    case host = "ホスト風"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .sincere: "checkmark.seal.fill"
        case .almostCrying: "drop.fill"
        case .defensive: "flame.fill"
        case .conscious: "sparkles"
        case .cute: "face.smiling.fill"
        case .professional: "building.2.fill"
        case .suspicious: "eye.trianglebadge.exclamationmark.fill"
        case .host: "crown.fill"
        }
    }
}

enum ExcusePower: String, CaseIterable, Identifiable, Codable {
    case light = "弱め"
    case normal = "普通"
    case strong = "強め"
    case kneeling = "土下座級"

    var id: String { rawValue }
}

struct ExcuseResult: Identifiable, Codable, Equatable {
    let id: UUID
    let category: ExcuseCategory
    let tone: ExcuseTone
    let power: ExcusePower
    let text: String
    let createdAt: Date

    init(
        id: UUID = UUID(),
        category: ExcuseCategory,
        tone: ExcuseTone,
        power: ExcusePower,
        text: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.category = category
        self.tone = tone
        self.power = power
        self.text = text
        self.createdAt = createdAt
    }
}
