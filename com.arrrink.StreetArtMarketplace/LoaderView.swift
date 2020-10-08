//
//  LoaderView.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 08.10.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI

struct LoaderView : View {
    @State private var fillPoint = 0.0
    @State private var colorIndex = 0
    
    var colors : [Color] = [Color("ColorMain"), .yellow, Color("ColorLightBlue"), .green, .purple]
    private var animation : Animation {
        Animation.easeInOut(duration: 0.7).repeatForever(autoreverses: false)
    }
    
    private var timer : Timer {
        Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { _ in
            if self.colorIndex + 1 >= self.colors.count {
                self.colorIndex = 0
            } else {
                self.colorIndex += 1
            }
        }
    }
    var body: some View {
        Ring(fillpoint: fillPoint).stroke(colors[colorIndex], lineWidth: 10)
            .frame(width: 50, height: 50)
            .onAppear() {
                withAnimation(self.animation) {
                    self.fillPoint = 1.0
                    _ = self.timer
                }
            }
            .padding()
    }
}

struct Ring : Shape {
    var fillpoint : Double
    var delayPoint : Double = 0.5
    var animatableData: Double {
        get {
            return fillpoint
        }
        set {
            fillpoint = newValue
        }
        
    }
    func path(in rect: CGRect) -> Path {
        var start : Double
        let end = 360 * fillpoint
        
        if fillpoint > delayPoint {
            start = (2 * fillpoint) * 360
        } else {
            start = 0
        }
        var path = Path()
        path.addArc(center: CGPoint(x: rect.size.width / 2, y: rect.size.height / 2), radius: rect.size.width / 2,
                    startAngle: .degrees(start), endAngle: .degrees(end), clockwise: false)
        return path
    }
}
