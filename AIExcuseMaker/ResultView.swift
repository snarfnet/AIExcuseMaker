import SwiftUI
import UIKit

struct ResultView: View {
    let category: ExcuseCategory
    let tone: ExcuseTone
    let power: ExcusePower

    @EnvironmentObject private var historyManager: HistoryManager
    @State private var result: ExcuseResult?
    @State private var displayedText = ""
    @State private var isThinking = true
    @State private var progress = 0.0
    @State private var thinkingMessage = ExcuseGenerator.thinkingMessages.randomElement() ?? "AI風に考え中…"
    @State private var copied = false

    private let generator = ExcuseGenerator()

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 18) {
                    GlassCard {
                        VStack(spacing: 12) {
                            HeroMascotImage()
                                .frame(height: 128)
                                .padding(.top, -8)
                                .padding(.bottom, -14)

                            HStack {
                                Label(category.rawValue, systemImage: category.iconName)
                                Spacer()
                                Text(tone.rawValue)
                                Text(power.rawValue)
                            }
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white.opacity(0.76))

                            if isThinking {
                                VStack(spacing: 14) {
                                    Image(systemName: "brain.head.profile")
                                        .font(.system(size: 42, weight: .bold))
                                        .foregroundStyle(.cyan)
                                        .symbolEffect(.pulse)

                                    Text("AIが考え中…")
                                        .font(.title2.weight(.black))
                                        .foregroundStyle(.white)

                                    Text(thinkingMessage)
                                        .font(.callout.weight(.semibold))
                                        .foregroundStyle(.white.opacity(0.72))

                                    ProgressView(value: progress)
                                        .progressViewStyle(.linear)
                                        .tint(.orange)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 30)
                            } else {
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        Label("AI風生成結果", systemImage: "sparkles")
                                            .font(.caption.weight(.bold))
                                            .foregroundStyle(.cyan)
                                        Spacer()
                                        Text("LOCAL")
                                            .font(.caption2.weight(.black))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(.white.opacity(0.12), in: Capsule())
                                            .foregroundStyle(.white.opacity(0.72))
                                    }

                                    Text(displayedText)
                                        .font(.system(size: 23, weight: .bold, design: .rounded))
                                        .foregroundStyle(.white)
                                        .lineSpacing(7)
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    Text("※この文章はAIではなく、ローカルのテンプレート合成で作っています。")
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.52))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                            }
                        }
                    }

                    if let result {
                        VStack(spacing: 10) {
                            Button {
                                UIPasteboard.general.string = result.text
                                copied = true
                            } label: {
                                ActionRow(title: copied ? "コピーしました" : "コピーする", systemImage: copied ? "checkmark" : "doc.on.doc.fill")
                            }

                            Button {
                                startGeneration()
                            } label: {
                                ActionRow(title: "もう一度生成", systemImage: "arrow.clockwise")
                            }

                            ShareLink(item: shareText(for: result)) {
                                ActionRow(title: "Xでシェア", systemImage: "square.and.arrow.up")
                            }
                        }
                    }

                    AdMobBannerSlotView(placement: .resultBottom)
                }
                .padding(20)
            }
        }
        .navigationTitle("生成結果")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if result == nil {
                startGeneration()
            }
        }
    }

    private func startGeneration() {
        let newResult = generator.generate(category: category, tone: tone, power: power)
        result = newResult
        displayedText = ""
        copied = false
        isThinking = true
        progress = 0
        thinkingMessage = ExcuseGenerator.thinkingMessages.randomElement() ?? "AI風に考え中…"

        Task {
            for step in 1...20 {
                try? await Task.sleep(nanoseconds: 100_000_000)
                await MainActor.run {
                    progress = Double(step) / 20
                }
            }

            await MainActor.run {
                isThinking = false
            }

            await typeText(newResult.text)

            await MainActor.run {
                historyManager.save(newResult)
            }
        }
    }

    private func typeText(_ text: String) async {
        for character in text {
            try? await Task.sleep(nanoseconds: 24_000_000)
            await MainActor.run {
                displayedText.append(character)
            }
        }
    }

    private func shareText(for result: ExcuseResult) -> String {
        """
        \(result.text)

        #AI言い訳メーカー #AI風ジョーク
        """
    }
}

private struct ActionRow: View {
    let title: String
    let systemImage: String

    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .frame(width: 24)
            Text(title)
                .fontWeight(.bold)
            Spacer()
        }
        .font(.headline)
        .foregroundStyle(.white)
        .padding(15)
        .background(.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(.white.opacity(0.16), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        ResultView(category: .late, tone: .sincere, power: .normal)
    }
    .environmentObject(HistoryManager())
}
