import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            HomeView()
        }
        .tint(.white)
    }
}

struct AppBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.04, green: 0.05, blue: 0.09),
                Color(red: 0.11, green: 0.08, blue: 0.18),
                Color(red: 0.03, green: 0.10, blue: 0.12)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .overlay {
            Image("ScreenshotBackdrop")
                .resizable()
                .scaledToFill()
                .opacity(0.18)
                .blur(radius: 1.5)
                .ignoresSafeArea()
        }
        .overlay(
            RadialGradient(
                colors: [Color.cyan.opacity(0.22), .clear],
                center: .topTrailing,
                startRadius: 40,
                endRadius: 360
            )
            .ignoresSafeArea()
        )
    }
}

struct HeroMascotImage: View {
    var body: some View {
        Image("HeroMascot")
            .resizable()
            .scaledToFit()
            .shadow(color: .orange.opacity(0.34), radius: 26, y: 14)
            .shadow(color: .cyan.opacity(0.20), radius: 32, y: -10)
    }
}

struct GlassCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(18)
            .background(.white.opacity(0.10), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(.white.opacity(0.16), lineWidth: 1)
            )
    }
}

struct PrimaryGradientButton: View {
    let title: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
            Text(title)
                .fontWeight(.bold)
        }
        .font(.headline)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            LinearGradient(
                colors: [Color(red: 1.0, green: 0.35, blue: 0.35), Color(red: 1.0, green: 0.72, blue: 0.22)],
                startPoint: .leading,
                endPoint: .trailing
            ),
            in: RoundedRectangle(cornerRadius: 8, style: .continuous)
        )
        .foregroundStyle(.black)
        .shadow(color: .orange.opacity(0.35), radius: 18, y: 8)
    }
}

struct AdPlaceholderView: View {
    var body: some View {
        AdMobBannerSlotView(placement: .bottom)
    }
}

#Preview {
    ContentView()
        .environmentObject(HistoryManager())
}
