import SwiftUI

struct CategorySelectView: View {
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("状況を選ぶ")
                            .font(.system(size: 30, weight: .black, design: .rounded))
                            .foregroundStyle(.white)

                        Text("まずは、どのピンチか教えてください。")
                            .foregroundStyle(.white.opacity(0.68))
                    }

                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(ExcuseCategory.allCases) { category in
                            NavigationLink {
                                ToneSelectView(category: category)
                            } label: {
                                VStack(alignment: .leading, spacing: 10) {
                                    Image(category.imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 82)
                                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .stroke(.white.opacity(0.14), lineWidth: 1)
                                        )

                                    Text(category.rawValue)
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.82)
                                }
                                .frame(maxWidth: .infinity, minHeight: 148, alignment: .leading)
                                .padding(12)
                                .background(.white.opacity(0.10), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .stroke(.white.opacity(0.14), lineWidth: 1)
                                )
                            }
                        }
                    }

                    AdMobBannerSlotView(placement: .categoryBottom)
                        .padding(.top, 10)
                }
                .padding(20)
            }
        }
        .navigationTitle("状況選択")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CategorySelectView()
    }
}
