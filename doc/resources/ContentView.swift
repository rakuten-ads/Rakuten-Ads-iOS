//
//  ContentView.swift
//  RUNA-SDK-Sample-SwiftUI
//
//  Created by Wu, Wei | David | GATD on 2023/03/03.
//

import SwiftUI
import RUNABanner
import UIKit

struct ContentView: View {

    let dataMatrix: [Int] = [Int](11...17)

    let colors:[UIColor] = [
        UIColor(red: 77.0/255.0, green: 69.0/255.0, blue: 93.0/255.0, alpha: 1),
        UIColor(red: 233/255.0, green: 100/255.0, blue: 121/255.0, alpha: 1),
        UIColor(red: 245.0/255.0, green: 233.0/255.0, blue: 207.0/255.0, alpha: 1),
        UIColor(red: 125.0/255.0, green: 185.0/255.0, blue: 182.0/255.0, alpha: 1),
    ]

    @State var bannerLoadSucceeded:Bool = false

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .center) {

                    Text("Hello, RUNA!")
                        .padding()

                    ForEach(0..<dataMatrix.count, id: \.self) { idx in
                        VStack {
                            if idx == 2 {
                                Text("View All")
                                RUNABannerAdapterView(loadSucceeded: $bannerLoadSucceeded, adspotId: "21882")
                                    .frame(width:UIScreen.main.bounds.width,
                                           height: bannerLoadSucceeded ? UIScreen.main.bounds.width / (360 / 237) : 0)
                            }

                            HStack {
                                Text("\(dataMatrix[idx])")
                            }.frame(width:UIScreen.main.bounds.width,height: 100)
                                .background(rotatingColor(idx))
                        }
                    }
                }
            }
        }
    }

    private func rotatingColor(_ position: Int) -> Color {
        Color(colors[position % colors.count])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RUNABannerAdapterView: UIViewRepresentable {

    @Binding var loadSucceeded: Bool
    let adspotId: String
    fileprivate let banner: RUNABannerView = RUNABannerView()

    var isReady = false

    func makeUIView(context: Context) -> some UIView {
        print("[runa] make view")
        return banner
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("[runa] update")
        if loadSucceeded {
            print("[runa] show")
        } else {
            print("[runa] hide")
        }
    }

    func makeCoordinator() -> Coordinator {
        print("[runa] make coordinator")
        return Coordinator(adapterView: self)
    }

    class Coordinator {
        private var adapterView: RUNABannerAdapterView

        init(adapterView: RUNABannerAdapterView) {
            self.adapterView = adapterView

            adapterView.banner.adSpotId = adapterView.adspotId
            adapterView.banner.size = .aspectFit

            adapterView.banner.load {[weak self] view, event in
                guard let self = self else { return }
                switch event.eventType {
                case .succeeded:
                    print("[runa] banner load succeeded: code \(event.error)")
                    self.adapterView.loadSucceeded = true
                case .failed:
                    print("[runa] banner load failed: code \(event.error)")
                    self.adapterView.loadSucceeded = false
                case .clicked:
                    print("[runa] banner clicked: url \(self.adapterView.banner.clickURL ?? "none")")
                default:
                    break
                }
            }
        }
    }
}
