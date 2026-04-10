//
//  ContentView.swift
//  RunaSwiftUISample
//
//  Created by Wu, Wei | David | GATD on 2026/04/10.
//

import SwiftUI
import RUNABanner

struct BannerViewRepresentable: UIViewRepresentable {
    @Binding var isReady: Bool
    @Binding var designatedSize: CGSize
    let adSpotId: String

    func makeUIView(context: Context) -> RUNABannerView {
        let bannerView = RUNABannerView()
        bannerView.adSpotId = adSpotId
        bannerView.size = .aspectFit
        bannerView.position = .topLeft
        bannerView.load { banner, event in
            switch event.eventType {
            case .succeeded:
                print("BannerViewRepresentable Success")
                isReady = true
                designatedSize = banner.designatedContentSize
            case .failed:
                print("BannerViewRepresentable Failed: \(event.error)")
                isReady = false
            case .clicked:
                print("BannerViewRepresentable Clicked")
            default:
                break
            }
        }
        return bannerView
    }

    func updateUIView(_ uiView: RUNABannerView, context: Context) {
        print("updateUIView - Banner NOT recreated")
    }
}

struct ContentView: View {

    @State var showBanner = true
    @State var designatedSize: CGSize = .zero

    var body: some View {
        VStack {
            List {
                HStack {
                    Text("PlaceHolder 1")
                        .frame(height: 50)
                }
                .background {
                    Color.blue.opacity(0.5)
                }
                if showBanner {
                    HStack {
                        BannerViewRepresentable(isReady: $showBanner, designatedSize: $designatedSize, adSpotId: "776")
                    }
                    .background {
                        Color.green.opacity(0.5)
                    }
                    .aspectRatio(designatedSize.width / designatedSize.height, contentMode: .fill)
                }
                HStack {
                    Text("PlaceHolder 2")
                        .frame(height: 100)
                }.background {
                    Color.red.opacity(0.5)
                }
            }
        }
        .padding()
        .navigationTitle(Text("RUNA Sample"))
    }
}

#Preview {
    ContentView()
}
