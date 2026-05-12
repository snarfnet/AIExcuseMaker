import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: 22) {
                Spacer(minLength: 24)

                VStack(spacing: 12) {
                    HeroMascotImage()
                        .frame(maxHeight: 250)
                        .padding(.horizontal, -12)

                    Text("AI言い訳メーカー")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    Text("ギリ許されそうな言い訳、秒速生成。")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.74))
                }

                GlassCard {
                    VStack(spacing: 14) {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles")
                        Text("AI風ジョーク生成")
                        }
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.cyan)

                        Text("テンプレートと単語辞書で作る、気まずい場面のネタ文章。")
                            .font(.callout)
                            .foregroundStyle(.white.opacity(0.78))
                            .multilineTextAlignment(.center)
                    }
                }

                VStack(spacing: 12) {
                    NavigationLink {
                        CategorySelectView()
                    } label: {
                        PrimaryGradientButton(title: "言い訳を作る", systemImage: "bolt.fill")
                    }

                    NavigationLink {
                        HistoryView()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "clock.arrow.circlepath")
                            Text("履歴")
                                .fontWeight(.bold)
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(.white.opacity(0.18), lineWidth: 1)
                        )
                        .foregroundStyle(.white)
                    }
                }

                Spacer()
                AdMobBannerSlotView(placement: .homeBottom)
            }
            .padding(22)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environmentObject(HistoryManager())
}
