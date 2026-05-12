import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

enum AdPlacement: String {
    case homeBottom = "home_bottom"
    case categoryBottom = "category_bottom"
    case settingsBottom = "settings_bottom"
    case resultBottom = "result_bottom"
    case historyBottom = "history_bottom"
    case bottom = "bottom"
}

struct AdService {
    static let shared = AdService()

    func bannerUnitID(for placement: AdPlacement) -> String {
        switch placement {
        case .homeBottom, .categoryBottom, .settingsBottom:
            return "ca-app-pub-9404799280370656/3119341718"
        case .resultBottom, .historyBottom, .bottom:
            return "ca-app-pub-9404799280370656/8180096709"
        }
    }
}

struct AdMobBannerSlotView: View {
    let placement: AdPlacement

    var body: some View {
        AdMobBannerView(unitID: AdService.shared.bannerUnitID(for: placement))
            .frame(height: 50)
            .accessibilityLabel("広告")
    }
}

private struct AdMobBannerView: UIViewRepresentable {
    let unitID: String

    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner)
        banner.adUnitID = unitID
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.keyWindow?.rootViewController {
                banner.rootViewController = rootVC
                banner.load(Request())
            }
        }
        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {}
}
