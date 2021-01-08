//
//  OnboardingView.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 06.11.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    @State var leftData = SliderData(side: .left)
        @State var rightData = SliderData(side: .right)
        
        @State var pageIndex = 0
        @State var topSlider = SliderDirection.right
        @State var sliderOffset: CGFloat = 0
        
    @State var safeAreaTop = UIApplication.shared.windows.first?.safeAreaInsets.top
    @State var safeAreaBottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom
    
    @State var getStoriesData = [PostRealmFB]()
    @State var adminNumber = ""
    @State var showHome = false
    
    var body: some View {
        
        if !self.showHome {
            ZStack {
                
                
                VStack(spacing: 15) {
                    if pageIndex == 0 {
                        LottieView(filename: "agency", loopMode: .playOnce, animationSpeed: 0.7)
                    } else if pageIndex == 1 {
                        LottieView(filename: "city", loopMode: .playOnce, animationSpeed: 0.7)
                    } else {
                        LottieView(filename: "find", loopMode: .loop, animationSpeed: 0.7)
                    }
                    
                       
                    Text(Config.textToBeShown[pageIndex])
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                
                    Button {
                        self.showHome = true
                    } label: {
                        
                    

                  
                        Text("Понятно")
                                .font(.system(.body, design: .rounded))
                                                       .fontWeight(.bold)
                            .foregroundColor(Config.colors[pageIndex])
                                                       .padding()
                                .multilineTextAlignment(.center)
                            .background(Capsule().fill(Color.white) .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5))
                    }
                  // }.buttonStyle(MyButtonStyle())
                            
                     
                
                
                }.padding(40)
                .padding(.top, safeAreaTop)
                .padding(.bottom, safeAreaBottom)
                .background(Rectangle().foregroundColor(Config.colors[pageIndex]))
                


                
                
                slider(data: $leftData)
                slider(data: $rightData)

           }
    } else {
            HomeView(adminNumber: $adminNumber)
        }
    
        }
        
        
        
        private func index(of data: SliderData) -> Int {
            let last = Config.colors.count - 1
            if data.side == .left {
                return pageIndex == 0 ? last : pageIndex - 1
                
            } else {
                return pageIndex == last ? 0 : pageIndex + 1
            }
        }
        
        private func swipe(data: Binding<SliderData>) {
            withAnimation() {
                data.wrappedValue = data.wrappedValue.final()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.pageIndex = self.index(of: data.wrappedValue)
                self.leftData = self.leftData.initial()
                self.rightData = self.rightData.initial()
                
                self.sliderOffset = 100
                withAnimation(.spring(dampingFraction: 0.5)) {
                    self.sliderOffset = 0
                }
            }
        }
        
        func wave(data: Binding<SliderData>) -> some View {
            let gesture = DragGesture().onChanged {
                self.topSlider = data.wrappedValue.side
                data.wrappedValue = data.wrappedValue.drag(value: $0)
            }
            .onEnded {
                if data.wrappedValue.isCancelled(value: $0) {
                    withAnimation(.spring(dampingFraction: 0.5)) {
                        data.wrappedValue = data.wrappedValue.initial()
                    }
                } else {
                    self.swipe(data: data)
                }
            }
            .simultaneously(with: TapGesture().onEnded {
                self.topSlider = data.wrappedValue.side
                self.swipe(data: data)
            })
            return WaveView(data: data.wrappedValue).gesture(gesture)
                .foregroundColor(Config.colors[index(of: data.wrappedValue)])
        }
        
        private func circle(radius: Double) -> Path {
            
            return Path { path in
                path.addEllipse(in: CGRect(x: -radius, y: -radius, width: radius * 2, height: radius * 2))
            }
        }
        
        private func polyLine(_ values: Double...) -> Path {
            return Path { path in
                path.move(to: CGPoint(x: values[0], y: values[1]))
                for i in stride(from: 2, to: values.count, by: 2) {
                    path.addLine(to: CGPoint(x: values[i], y: values[i + 1]))
                }
            }
        }
        func  button(data: SliderData) -> some View {
            let arrowWidth = (data.side == .left ? 1 : -1) * Config.arrowWidth / 2
            let arrowHeight = Config.arrowHeight / 2
            
            return ZStack {
               // circle(radius: Config.buttonRadius).stroke()
             //   ).opacity(0.2)
                polyLine(-arrowWidth, -arrowHeight, arrowWidth, 0, -arrowWidth, arrowHeight).stroke(Color.white, lineWidth: 2)
            }
            .offset(data.buttonOffset)
            .opacity(data.buttonOpacity)
        }
        
        func slider(data: Binding<SliderData>) -> some View {
            let value = data.wrappedValue
            
            return ZStack {
                wave(data: data)
                button(data: value)
            }
            .zIndex(topSlider == value.side ? 1 : 0)
            .offset(x: value.side == .left ? -sliderOffset : sliderOffset)
        }
}

// DATA

struct Config {
    
    static let leftWaveY = 100.0
    static let rightWaveY = 300.0
    static let buttonRadius = 24.0
    static let buttonMargin = 8.0
    static let arrowWidth = 4.0
    static let arrowHeight = 10.0
    static let swipeVelocity = 0.45
    static let swipeCancelThreshold = 0.15
    static let waveMinLedge = 15.0
    static let waveMinHR = 48.0
    static let waveMinVR = 82.0
    static let lottie = ["agency", "city", "find"]
    static let colors = [Color("ColorMain"), Color.orange, Color.purple]
                        
    static let textToBeShown = ["Все новостройки Санкт-Петербурга в одном приложении",
        "Только актуальная информация", "Бесплатная консультация лучших экспертов рынка"]
            
}

enum SliderDirection {
    case left
    case right
}

struct SliderData {
    let side: SliderDirection
    let centerY: Double
    let progress: Double
    
    init(side: SliderDirection, centerY: Double, progress: Double) {
        self.side = side
        self.centerY = centerY
        self.progress = progress
    }
    
    init(side: SliderDirection) {
        self.init(side: side, centerY: side == .left ? Config.leftWaveY : Config.rightWaveY, progress: 0)
    }
    
    static var screenWidth: Double {
        return Double(UIScreen.main.bounds.width)
    }
    
    static var screenHeight: Double {
        return Double(UIScreen.main.bounds.height)
    }
    
    var waveLedgeX: Double {
        let ledge = Config.waveMinLedge.interpolate(to: SliderData.screenWidth, in: progress, min: 0.2, max: 0.8)
        return side == .left ? ledge : SliderData.screenWidth - ledge
    }
    
    var waveHorizontalRadius: Double {
        let p1: Double = 0.4
        let to = SliderData.screenWidth * 0.8
        if progress <= p1 {
            return Config.waveMinHR.interpolate(to: to, in: progress, max: p1)
        } else if progress >= 1 {
            return to
        }
        let t = (progress - p1) / (1 - p1)
        let m: Double = 9.8
        let beta: Double = 40.0 / (2 * m)
        let omega = pow(-pow(beta, 2) + pow(50.0 / m, 2), 0.5)
        return to * exp(-beta * t) * cos(omega * t)
    }
    
    var buttonOffset: CGSize {
        let sign = side == .left ? 1.0 : -1.0
        let hs = Config.buttonRadius + Config.buttonMargin
        return CGSize(width: waveLedgeX + sign * (waveHorizontalRadius - hs) , height: centerY)
    }
    
    var buttonOpacity: Double {
        return max( 1 - progress * 5.0, 0)
    }
    
    var waveVerticalRadius: Double {
        return Config.waveMinVR.interpolate(to: SliderData.screenHeight * 0.9, in: progress, max: 0.4)
    }
    
    func initial() -> SliderData {
        return SliderData(side: side, centerY: centerY, progress: 0)
    }
    
    func final() -> SliderData {
        return SliderData(side: side, centerY: centerY, progress: 1)
    }
    
    func drag(value: DragGesture.Value) -> SliderData {
        let dx = (side == .left ? 1 : -1) * Double(value.translation.width)
        let progress = min(1.0, max(0, dx * Config.swipeVelocity / SliderData.screenWidth))
        return SliderData(side: side, centerY: Double(value.location.y), progress: progress)
    }
    
    func isCancelled(value: DragGesture.Value) -> Bool {
        return drag(value: value).progress < Config.swipeCancelThreshold
    }
    
    
}


extension Color {
    init(netHex: Int) {
        self.init(red: netHex.ff(16), green: netHex.ff(08), blue: netHex.ff(00))
    }
}

extension Int {
    func ff(_ shift: Int) -> Double {
        return Double((self >> shift) & 0xff) / 255
        
    }
}

extension Double {
    func interpolate(to: Double, in fraction: Double, min: Double = 0, max: Double = 1) -> Double {
        if fraction <= min {
            return self
        } else if fraction >= max {
            return to
        }
        
        return self + (to - self) * (fraction - min) / (max - min)
    }
}

struct WaveView: Shape {
    
    private let side: SliderDirection
    private var centerY: Double
    private var progress: Double
    
    
    init(data: SliderData) {
        self.side = data.side
        self.centerY = data.centerY
        self.progress = data.progress
    }
    
    internal var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(centerY, progress) }
        set {
            centerY = newValue.first
            progress = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let data  = SliderData(side: side, centerY: centerY, progress: progress)
        let waveLedge = data.waveLedgeX
        let hr = data.waveHorizontalRadius
        let vr = data.waveVerticalRadius
        let curveStartY = vr + data.centerY
        let isLeft = self.side == .left
        let sign = isLeft ? 1.0 : -1.0
        
        
        let x = isLeft ? -50.0 : SliderData.screenWidth + 50
        path.move(to: CGPoint(x: waveLedge, y: -100))
        path.addLine(to:  CGPoint(x: x, y: -100))
        path.addLine(to: CGPoint(x: x, y: SliderData.screenHeight))
        path.addLine(to: CGPoint(x: waveLedge, y: SliderData.screenHeight))
        path.addLine(to: CGPoint(x: waveLedge, y: curveStartY))
        
        
        
        var index = 0
        while index <  WaveView.data.count {
            let x1 = waveLedge + sign * hr * WaveView.data[index]
            let y1 = curveStartY - vr * WaveView.data[index + 1]
            let x2 = waveLedge + sign * hr * WaveView.data[index + 2]
            let y2 = curveStartY - vr * WaveView.data[index + 3]
            let x = waveLedge + sign * hr * WaveView.data[index + 4]
            let y = curveStartY - vr * WaveView.data[index + 5]
            index += 6
            
            path.addCurve(
                to: CGPoint(x: x, y: y),
                control1: CGPoint(x: x1, y: y1),
                control2: CGPoint(x: x2, y: y2)
            )
        }
        
        return path
  
    }
    private static let data = [ 0, 0.13461, 0.05341, 0.24127, 0.15615, 0.33223,
                                0.23616, 0.40308, 0.33052, 0.45611, 0.50124, 0.53505,
                                0.51587, 0.54182, 0.56641, 0.56503, 0.57493, 0.56896,
                                0.72837, 0.63973, 0.80866, 0.68334, 0.87740, 0.73990,
                                0.96534, 0.81226,       1, 0.89361,       1,       1,
                                1, 1.10014, 0.95957, 1.18879, 0.86084, 1.27048,
                                0.78521, 1.33305, 0.70338, 1.37958, 0.52911, 1.46651,
                                0.52418, 1.46896, 0.50573, 1.47816, 0.50153, 1.48026,
                                0.31874, 1.57142, 0.23320, 1.62041, 0.15411, 1.68740,
                                0.05099, 1.77475,       0, 1.87092,       0,       2]
    
}
