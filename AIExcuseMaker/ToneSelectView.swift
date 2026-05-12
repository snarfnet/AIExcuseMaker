import SwiftUI

struct ToneSelectView: View {
    let category: ExcuseCategory

    @State private var selectedTone: ExcuseTone = .sincere
    @State private var selectedPower: ExcusePower = .normal

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    GlassCard {
                        HStack(spacing: 14) {
                            Image(systemName: category.iconName)
                                .font(.title.weight(.bold))
                                .foregroundStyle(.yellow)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(category.rawValue)
                                    .font(.title2.weight(.black))
                                    .foregroundStyle(.white)
                                Text("言い訳の雰囲気を調整します。")
                                    .font(.callout)
                                    .foregroundStyle(.white.opacity(0.68))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    SectionTitle(title: "雰囲気")

                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(ExcuseTone.allCases) { tone in
                            SelectableChip(
                                title: tone.rawValue,
                                systemImage: tone.iconName,
                                isSelected: selectedTone == tone
                            ) {
                                selectedTone = tone
                            }
                        }
                    }

                    SectionTitle(title: "強さ")

                    VStack(spacing: 10) {
                        ForEach(ExcusePower.allCases) { power in
                            Button {
                                selectedPower = power
                            } label: {
                                HStack {
                                    Text(power.rawValue)
                                        .font(.headline)
                                    Spacer()
                                    if selectedPower == power {
                                        Image(systemName: "checkmark.circle.fill")
                                    }
                                }
                                .foregroundStyle(.white)
                                .padding(15)
                                .background(selectedPower == power ? .orange.opacity(0.34) : .white.opacity(0.10), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .stroke(selectedPower == power ? .orange : .white.opacity(0.14), lineWidth: 1)
                                )
                            }
                        }
                    }

                    NavigationLink {
                        ResultView(category: category, tone: selectedTone, power: selectedPower)
                    } label: {
                        PrimaryGradientButton(title: "AI風に生成する", systemImage: "sparkles")
                    }
                    .padding(.top, 6)

                    AdMobBannerSlotView(placement: .settingsBottom)
                }
                .padding(20)
            }
        }
        .navigationTitle("設定")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct SectionTitle: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline.weight(.bold))
            .foregroundStyle(.white.opacity(0.86))
    }
}

private struct SelectableChip: View {
    let title: String
    let systemImage: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                    .frame(width: 22)
                Text(title)
                    .font(.subheadline.weight(.bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .padding(.horizontal, 10)
            .background(isSelected ? .cyan.opacity(0.28) : .white.opacity(0.10), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(isSelected ? .cyan : .white.opacity(0.14), lineWidth: 1)
            )
        }
    }
}

#Preview {
    NavigationStack {
        ToneSelectView(category: .late)
    }
}
