//
//  extensions.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 20.08.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI
import NavigationStack
import UIKit
import Firebase


struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct RoundedCorners: View {
    var color: Color = .blue
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0

    var body: some View {
        GeometryReader { geometry in
            Path { path in

                let w = geometry.size.width
                let h = geometry.size.height

                // Make sure we do not exceed the size of the rectangle
                let tr = min(min(self.tr, h/2), w/2)
                let tl = min(min(self.tl, h/2), w/2)
                let bl = min(min(self.bl, h/2), w/2)
                let br = min(min(self.br, h/2), w/2)

                path.move(to: CGPoint(x: w / 2.0, y: 0))
                path.addLine(to: CGPoint(x: w - tr, y: 0))
                path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                path.addLine(to: CGPoint(x: w, y: h - br))
                path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                path.addLine(to: CGPoint(x: bl, y: h))
                path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: tl))
                path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
            }
            .fill(self.color)
        }
    }
}


enum UIUserInterfaceIdiom : Int {
    case Unspecified
    case phone
    case pad
}

struct ScreenSize {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenMaxLength = max(ScreenSize.screenWidth, ScreenSize.screenHeight)
    static let screenMinLength = min(ScreenSize.screenWidth, ScreenSize.screenHeight)
}

struct DeviceType {
    
    static let iPhone4OrLess  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength < 568.0
    static let iPhoneSE = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 568.0
    static let iPhone8 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 667.0
    static let iPhone8Plus = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 736.0
    static let iPhoneXr = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 896.0
    static let iPhoneXs = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 812.0
    static let iPhoneXsMax = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 896.0
    static let iPad = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 1024.0
}

extension UserDefaults {

    static func isFirstLaunch() -> Bool {
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "first_start_key")
        if (isFirstLaunch) {
            UserDefaults.standard.set(true, forKey: "first_start_key")
        }
        return isFirstLaunch
    }

}
extension String {
    func separate(every stride: Int = 4, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
}
class PinchZoomView: UIView {

    weak var delegate: PinchZoomViewDelgate?

    private(set) var scale: CGFloat = 0 {
        didSet {
            delegate?.pinchZoomView(self, didChangeScale: scale)
        }
    }

    private(set) var anchor: UnitPoint = .center {
        didSet {
            delegate?.pinchZoomView(self, didChangeAnchor: anchor)
        }
    }

    private(set) var offset: CGSize = .zero {
        didSet {
            delegate?.pinchZoomView(self, didChangeOffset: offset)
        }
    }

    private(set) var isPinching: Bool = false {
        didSet {
            delegate?.pinchZoomView(self, didChangePinching: isPinching)
        }
    }

    private var startLocation: CGPoint = .zero
    private var location: CGPoint = .zero
    private var numberOfTouches: Int = 0

    init() {
        super.init(frame: .zero)

        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch(gesture:)))
        pinchGesture.cancelsTouchesInView = false
        addGestureRecognizer(pinchGesture)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    @objc private func pinch(gesture: UIPinchGestureRecognizer) {

        switch gesture.state {
        case .began:
            isPinching = true
            startLocation = gesture.location(in: self)
            anchor = UnitPoint(x: startLocation.x / bounds.width, y: startLocation.y / bounds.height)
            numberOfTouches = gesture.numberOfTouches

        case .changed:
            if gesture.numberOfTouches != numberOfTouches {
                // If the number of fingers being used changes, the start location needs to be adjusted to avoid jumping.
                let newLocation = gesture.location(in: self)
                let jumpDifference = CGSize(width: newLocation.x - location.x, height: newLocation.y - location.y)
                startLocation = CGPoint(x: startLocation.x + jumpDifference.width, y: startLocation.y + jumpDifference.height)

                numberOfTouches = gesture.numberOfTouches
            }

            scale = gesture.scale

            location = gesture.location(in: self)
            offset = CGSize(width: location.x - startLocation.x, height: location.y - startLocation.y)

        case .ended, .cancelled, .failed:
            isPinching = false
            scale = 1.0
            anchor = .center
            offset = .zero
        default:
            break
        }
    }

}

protocol PinchZoomViewDelgate: AnyObject {
    func pinchZoomView(_ pinchZoomView: PinchZoomView, didChangePinching isPinching: Bool)
    func pinchZoomView(_ pinchZoomView: PinchZoomView, didChangeScale scale: CGFloat)
    func pinchZoomView(_ pinchZoomView: PinchZoomView, didChangeAnchor anchor: UnitPoint)
    func pinchZoomView(_ pinchZoomView: PinchZoomView, didChangeOffset offset: CGSize)
}

struct PinchZoom: UIViewRepresentable {

    @Binding var scale: CGFloat
    @Binding var anchor: UnitPoint
    @Binding var offset: CGSize
    @Binding var isPinching: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> PinchZoomView {
        let pinchZoomView = PinchZoomView()
        pinchZoomView.delegate = context.coordinator
        return pinchZoomView
    }

    func updateUIView(_ pageControl: PinchZoomView, context: Context) { }

    class Coordinator: NSObject, PinchZoomViewDelgate {
        var pinchZoom: PinchZoom

        init(_ pinchZoom: PinchZoom) {
            self.pinchZoom = pinchZoom
        }

        func pinchZoomView(_ pinchZoomView: PinchZoomView, didChangePinching isPinching: Bool) {
            pinchZoom.isPinching = isPinching
        }

        func pinchZoomView(_ pinchZoomView: PinchZoomView, didChangeScale scale: CGFloat) {
            pinchZoom.scale = scale
        }

        func pinchZoomView(_ pinchZoomView: PinchZoomView, didChangeAnchor anchor: UnitPoint) {
            pinchZoom.anchor = anchor
        }

        func pinchZoomView(_ pinchZoomView: PinchZoomView, didChangeOffset offset: CGSize) {
            pinchZoom.offset = offset
        }
    }
}

struct PinchToZoom: ViewModifier {
    @State var scale: CGFloat = 1.0
    @State var anchor: UnitPoint = .center
    @State var offset: CGSize = .zero
    @State var isPinching: Bool = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(scale, anchor: anchor)
            .offset(offset)
            .animation(isPinching ? .none : .spring())
            .overlay(PinchZoom(scale: $scale, anchor: $anchor, offset: $offset, isPinching: $isPinching))
    }
}

extension View {
    func pinchToZoom() -> some View {
        self.modifier(PinchToZoom())
    }
}
struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void

    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}

struct Bank : Identifiable{
 var id: Int
 
 var name : String
 var img : String
 
 
 var minSumOfCredit : CGFloat
 
 var maxSumOfCredit : CGFloat
 
 var maxPV : CGFloat
 
 
 
 var totalWorkDuration : CGFloat = 1
 
 var accentColor : Color
 
 var ifNotFromRussia : Bool
 
 var ifcheckMoneyTypePFR : Bool
 
 var if2docs : Bool
 
 var maxYearCreditDuration : CGFloat
 
 var minYearCreditDuration : CGFloat
 
 var workTypes : [WorkType]
 
 var checkMoneyTypes : [CheckMoneyType]
 
 var specialIpotekaTypes : [SpecialIpotekaType]
 
 var err : String
 
 var totalPercent : Double
 
}

struct WorkType : Identifiable{
 var id: Int
 var typeName : String
 var minPercentOfBusinessIfTypeIsBusiness : CGFloat
 var minCurrentWorkDuration : CGFloat
 var minPV : CGFloat
 
 init(id: Int, typeName: String, minPercentOfBusinessIfTypeIsBusiness: CGFloat = 1, minCurrentWorkDuration: CGFloat, minPV: CGFloat) {
     self.id = id
     self.typeName = typeName
     self.minPercentOfBusinessIfTypeIsBusiness = minPercentOfBusinessIfTypeIsBusiness
     self.minCurrentWorkDuration = minCurrentWorkDuration
     self.minPV = minPV
 }
 
}

struct CheckMoneyType : Identifiable{
 var id: Int
 var typeName : String
 
 var if2docsIfBusiness : Bool
 var minPVIf2docs : CGFloat
 var percent : CGFloat
 
 init(id: Int, typeName: String, if2docsIfBusiness : Bool = true, minPVIf2docs: CGFloat = 0.35, percent: CGFloat) {
     self.id = id
     self.typeName = typeName
     self.if2docsIfBusiness = if2docsIfBusiness
     self.minPVIf2docs = minPVIf2docs
     self.percent = percent
 }
}

struct SpecialIpotekaType : Identifiable{
 var id: Int
 
 var typeName : String
 var minPV : CGFloat
 var percent : CGFloat
 
 init(id: Int, typeName: String, minPV: CGFloat = 0.15, percent: CGFloat) {
     self.id = id
     self.typeName = typeName
     self.minPV = minPV
     self.percent = percent
 }
 
 
}


struct taFlatPlans : Identifiable, Hashable, Decodable {
   
    var id : String
    var img : String
    var complexName : String
    var price : String
    var room : String
    var deadline : String
    var type : String
    var floor : String
    var developer : String
    var district : String
    var totalS : String
    var kitchenS : String
    var repair : String
    var roomType : String
    var underground : String
    
}
struct taObjects : Identifiable, Hashable {
    
    var id : String
    
    var address : String
    
    var complexName : String
    
    var deadline : String
    
    var developer : String
    
    var geo : GeoPoint
    
    var img : String
    
    var type : String
    
    var underground : String
    
    var timeToUnderground : String
    
    var typeToUnderground : String
    
    
    
    
    
    
}
struct BlurView : UIViewRepresentable {
    
    var style : UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView{
        
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
        
    }
}
extension String {
    func toUpperCase() -> String {
        return localized.uppercased(with: .current)
    }
    private var localized : String {
        return NSLocalizedString( self, comment:"")
    }
}

struct DetailViewScrollData : Identifiable {
    
    var id : Int
    var offset : CGFloat
    
}
struct GeometryGetter: View {
    @Binding var rect: CGRect
    
    var body: some View {
        return GeometryReader { geometry in
            self.makeView(geometry: geometry)
        }
    }
    
    func makeView(geometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.rect = geometry.frame(in: .global)
        }

        return Rectangle().fill(Color.clear)
    }
}
extension View {

  func showModal<T>(_ binding: Binding<Bool>, _ view: @escaping () -> T) -> some View where T: View {

    let windowHeightOffset = (UIApplication.shared.windows.first?.frame.height ?? 600) * -1

    return ZStack {

      self

      view().frame(maxWidth: .infinity, maxHeight: .infinity).edgesIgnoringSafeArea(.all).offset(x: 0, y: binding.wrappedValue ? 0 : windowHeightOffset)

    }

  }
}
struct ViewControllerHolder {
    weak var value: UIViewController?
    init(_ value: UIViewController?) {
        self.value = value
    }
}

struct ViewControllerKey: EnvironmentKey {
    static var defaultValue: ViewControllerHolder { return ViewControllerHolder(UIApplication.shared.windows.first?.rootViewController ) }
}

extension EnvironmentValues {
    var viewController: ViewControllerHolder {
        get { return self[ViewControllerKey.self] }
        set { self[ViewControllerKey.self] = newValue }
    }
}

extension UIViewController {
    func present<Content: View>(presentationStyle: UIModalPresentationStyle = .automatic, transitionStyle: UIModalTransitionStyle = .coverVertical, animated: Bool = true, completion: @escaping () -> Void = {}, @ViewBuilder builder: () -> Content) {
        let toPresent = UIHostingController(rootView: AnyView(EmptyView()))
        toPresent.modalPresentationStyle = presentationStyle
        toPresent.rootView = AnyView(
            builder()
                .environment(\.viewController, ViewControllerHolder(toPresent))
        )
        if presentationStyle == .overCurrentContext {
            toPresent.view.backgroundColor = .clear
        }
        self.present(toPresent, animated: animated, completion: completion)
    }
}
