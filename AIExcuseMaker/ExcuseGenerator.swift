import Foundation

struct ExcuseGenerator {
    static let thinkingMessages = [
        "言い訳の矛盾を調整中…",
        "怒られにくさを計算中…",
        "罪悪感を30%追加中…",
        "社会人っぽさを注入中…",
        "ギリ許されるラインを探索中…",
        "土下座角度を最適化中…"
    ]

    private let reasons: [ExcuseCategory: [String]] = [
        .late: ["電車の遅延", "急な体調不良", "家を出る直前のトラブル", "スマホの充電切れ", "予想外の渋滞", "財布を忘れて取りに戻った"],
        .absent: ["朝からの発熱", "家族の急な用事", "病院への付き添い", "体調の急変", "昨夜からの腹痛", "移動が難しい状況"],
        .forgotReply: ["通知を見落としたこと", "返信したつもりになっていたこと", "仕事中に確認だけして閉じたこと", "充電切れ", "別の連絡に埋もれたこと", "寝落ち"],
        .dateLate: ["電車の乗り換えミス", "服選びに迷いすぎたこと", "道を一本間違えたこと", "急な渋滞", "駅の出口を間違えたこと", "緊張で準備が空回りしたこと"],
        .partyCancel: ["急な体調不良", "外せない家の用事", "仕事が長引いたこと", "財布の中身が想像より軽かったこと", "明日の予定の前倒し", "移動中のトラブル"],
        .homework: ["提出日の勘違い", "保存したファイルの行方不明", "家の用事", "体調不良", "別課題との混同", "最後の確認でミスに気づいたこと"],
        .workMistake: ["確認漏れ", "認識のズレ", "共有内容の見落とし", "優先順位の判断ミス", "急ぎ対応中の取り違え", "仕様の理解不足"],
        .forgotPromise: ["カレンダー登録漏れ", "完全な勘違い", "別日程との混同", "通知の見落とし", "寝不足による記憶の抜け", "直前の用事"]
    ]

    private let reflections = [
        "完全に自分の確認不足でした。",
        "もっと早く連絡すべきでした。",
        "ご迷惑をおかけして申し訳ありません。",
        "言い訳に聞こえると思いますが、本当に反省しています。",
        "軽く考えていたわけではありません。"
    ]

    private let nextActions = [
        "次回からは必ず早めに行動します。",
        "到着次第すぐに対応します。",
        "今後同じことがないようにします。",
        "今日はできる限り取り返します。",
        "すぐに状況を整理して埋め合わせます。"
    ]

    func generate(category: ExcuseCategory, tone: ExcuseTone, power: ExcusePower) -> ExcuseResult {
        let reason = reasons[category]?.randomElement() ?? "予想外の事情"
        let reflection = reflections.randomElement() ?? "反省しています。"
        let nextAction = nextActions.randomElement() ?? "今後気をつけます。"
        let text = template(for: tone, power: power)
            .replacingOccurrences(of: "{カテゴリ}", with: category.rawValue)
            .replacingOccurrences(of: "{理由}", with: reason)
            .replacingOccurrences(of: "{反省文}", with: reflection)
            .replacingOccurrences(of: "{今後の対応}", with: nextAction)

        return ExcuseResult(category: category, tone: tone, power: power, text: text)
    }

    private func template(for tone: ExcuseTone, power: ExcusePower) -> String {
        switch (tone, power) {
        case (.sincere, .light):
            return "すみません。{理由} の影響で少し遅れています。{今後の対応}"
        case (.sincere, .normal):
            return "本当にすみません。{理由} の影響で{カテゴリ}になってしまいました。{反省文} {今後の対応}"
        case (.sincere, .strong):
            return "申し訳ありません。{理由} があったとはいえ、結果として迷惑をかけました。{反省文} {今後の対応}"
        case (.sincere, .kneeling):
            return "大変申し訳ありません。{理由} は理由にならないと分かっています。{反省文} 信頼を戻せるよう、今日から行動で示します。"

        case (.almostCrying, .light):
            return "ごめんなさい…。{理由} で完全に焦っています。怒られて当然ですが、{今後の対応}"
        case (.almostCrying, .normal):
            return "本当にごめんなさい…。{理由} で{カテゴリ}になりました。{反省文} 今ちょっと泣きそうです。"
        case (.almostCrying, .strong):
            return "ごめんなさい、本当にやらかしました…。{理由} のせいにしたくないです。{反省文} {今後の対応}"
        case (.almostCrying, .kneeling):
            return "ごめんなさい…。もう土下座の気持ちです。{理由} がありましたが、全部こちらの責任です。{今後の対応}"

        case (.defensive, .light):
            return "すみません、ただ今回は{理由} があって、正直どうにもなりませんでした。とはいえ{今後の対応}"
        case (.defensive, .normal):
            return "申し訳ないです。でも{理由} はさすがに読めませんでした。{反省文} ここから巻き返します。"
        case (.defensive, .strong):
            return "すみません。こちらにも落ち度はありますが、{理由} が重なりました。責任は取ります。{今後の対応}"
        case (.defensive, .kneeling):
            return "申し訳ありません。言いたいことはありますが、まず謝ります。{理由} がありました。{反省文} 今日中にできる限り戻します。"

        case (.conscious, .light):
            return "{理由} により、想定していた行動設計が崩れました。次のアクションとして、{今後の対応}"
        case (.conscious, .normal):
            return "{カテゴリ}について、{理由} が発生しました。今回の学びは初動の重要性です。{今後の対応}"
        case (.conscious, .strong):
            return "{理由} をきっかけに、リスク管理の甘さが出ました。{反省文} 再発防止までセットで動きます。"
        case (.conscious, .kneeling):
            return "今回の{カテゴリ}は、信頼資産を削る重大な事象だと捉えています。{理由} が背景です。{今後の対応}"

        case (.cute, .light):
            return "ごめんなさいっ。{理由} でちょっとだけやらかしました…。ゆるしてほしいです。{今後の対応}"
        case (.cute, .normal):
            return "ほんとにごめんね。{理由} で{カテゴリ}になっちゃいました。反省してます。ちゃんと埋め合わせします。"
        case (.cute, .strong):
            return "ごめんなさい…。かわいく言っても許されないのは分かってます。{理由} でした。{今後の対応}"
        case (.cute, .kneeling):
            return "ごめんなさい、これは完全にしょんぼり案件です。{理由} があっても私が悪いです。全力で埋め合わせします。"

        case (.professional, .light):
            return "申し訳ありません。{理由} により予定に影響が出ています。まずは状況共有まで失礼します。"
        case (.professional, .normal):
            return "申し訳ありません。{理由} により{カテゴリ}が発生しました。{反省文} {今後の対応}"
        case (.professional, .strong):
            return "このたびは申し訳ありません。{理由} が原因です。影響範囲を確認し、優先度を上げて対応します。"
        case (.professional, .kneeling):
            return "大変申し訳ありません。{カテゴリ}によりご迷惑をおかけしました。{理由} が背景ですが、責任を持ってリカバリーします。"

        case (.suspicious, .light):
            return "すみません、細かく言うと長いのですが、{理由} がありました。今は説明より先に{今後の対応}"
        case (.suspicious, .normal):
            return "本当に偶然が重なりました。{理由} です。怪しく聞こえるのは分かっています。{反省文}"
        case (.suspicious, .strong):
            return "信じてもらえるか不安ですが、{理由} がありました。証拠は薄いです。でも反省は濃いです。{今後の対応}"
        case (.suspicious, .kneeling):
            return "かなり怪しく聞こえると思いますが、{理由} です。疑われても仕方ありません。{反省文} 行動で取り返します。"

        case (.host, .light):
            return "ごめん、姫。{理由} で少しだけ遅れた。でも気持ちはもう到着してる。{今後の対応}"
        case (.host, .normal):
            return "ごめんね、姫。{理由} で{カテゴリ}になった。今日はその分、言葉じゃなく行動で返すよ。"
        case (.host, .strong):
            return "姫、本当にごめん。{理由} はあったけど、寂しくさせた時点で俺の負け。必ず埋め合わせする。"
        case (.host, .kneeling):
            return "姫、これは俺が悪い。{理由} なんて言い訳にしたくない。今夜の信頼、土下座級で取り戻させて。"
        }
    }
}
