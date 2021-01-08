//
//  extensions.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 20.08.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI
import UIKit
import Firebase
import Combine
import SDWebImageSwiftUI
import WebKit
import ASCollectionView_SwiftUI

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
    
    
    func price() -> String {
            
        var string = String(self.reversed())

        string = String(string.enumerated().map { $0 > 0 && $0 % 3 == 0 ? [" ", $1] : [$1]}.joined())
            
            string = "\(String(string.reversed())) руб."
           
        return string
        
    }
}

struct RoundedEdge: ViewModifier {
    let width: CGFloat
    let color: Color
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content.cornerRadius(cornerRadius - width)
            .padding(width)
            .background(color)
            .cornerRadius(cornerRadius)
            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
    }
}
// defaultPinch

class PinchZoomDefaultView: UIView {

    weak var delegate: PinchZoomDefaultViewDelgate?

    private(set) var scale: CGFloat = 0 {
        didSet {
            delegate?.pinchZoomDefaultView(self, didChangeScale: scale)
        }
    }

    private(set) var anchor: UnitPoint = .center {
        didSet {
            delegate?.pinchZoomDefaultView(self, didChangeAnchor: anchor)
        }
    }

    private(set) var offset: CGSize = .zero {
        didSet {
            delegate?.pinchZoomDefaultView(self, didChangeOffset: offset)
        }
    }

    private(set) var isPinching: Bool = false {
        didSet {
            delegate?.pinchZoomDefaultView(self, didChangePinching: isPinching)
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

protocol PinchZoomDefaultViewDelgate: AnyObject {
    func pinchZoomDefaultView(_ pinchZoomView: PinchZoomDefaultView, didChangePinching isPinching: Bool)
    func pinchZoomDefaultView(_ pinchZoomView: PinchZoomDefaultView, didChangeScale scale: CGFloat)
    func pinchZoomDefaultView(_ pinchZoomView: PinchZoomDefaultView, didChangeAnchor anchor: UnitPoint)
    func pinchZoomDefaultView(_ pinchZoomView: PinchZoomDefaultView, didChangeOffset offset: CGSize)
}

struct PinchZoomDefault: UIViewRepresentable {

    @Binding var scale: CGFloat
    @Binding var anchor: UnitPoint
    @Binding var offset: CGSize
    @Binding var isPinching: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> PinchZoomDefaultView {
        let pinchZoomView = PinchZoomDefaultView()
        pinchZoomView.delegate = context.coordinator
        return pinchZoomView
    }

    func updateUIView(_ pageControl: PinchZoomDefaultView, context: Context) { }

    class Coordinator: NSObject, PinchZoomDefaultViewDelgate {
        func pinchZoomDefaultView(_ pinchZoomView: PinchZoomDefaultView, didChangePinching isPinching: Bool) {
            pinchZoom.isPinching = isPinching
        }
        
        func pinchZoomDefaultView(_ pinchZoomView: PinchZoomDefaultView, didChangeScale scale: CGFloat) {
            pinchZoom.scale = scale
        }
        
        func pinchZoomDefaultView(_ pinchZoomView: PinchZoomDefaultView, didChangeAnchor anchor: UnitPoint) {
            pinchZoom.anchor = anchor
        }
        
        func pinchZoomDefaultView(_ pinchZoomView: PinchZoomDefaultView, didChangeOffset offset: CGSize) {
            pinchZoom.offset = offset
        }
        
        var pinchZoom: PinchZoomDefault

        init(_ pinchZoom: PinchZoomDefault) {
            self.pinchZoom = pinchZoom
        }

            }
}

struct PinchToZoomDefault: ViewModifier {
    @State var scale: CGFloat = 1.0
    @State var anchor: UnitPoint = .center
    @State var offset: CGSize = .zero
    @State var isPinching: Bool = false

    func body(content: Content) -> some View {
        content
//            .scaleEffect(scale, anchor: anchor)
//            .offset(offset)
            // .animation(isPinching ? .none : .spring())
            .overlay(PinchZoomDefault(scale: $scale, anchor: $anchor, offset: $offset, isPinching: $isPinching))
    }
}


// customPinch
@IBDesignable
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
    
   
    
   // var imgString: String

    private var startLocation: CGPoint = .zero
    private var location: CGPoint = .zero
    private var numberOfTouches: Int = 0
    private var newsArray = [News]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.init(imgString : imgString, frame : frame)
       
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch(gesture:)))
        pinchGesture.cancelsTouchesInView = false
        addGestureRecognizer(pinchGesture)
        

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
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

//struct PinchToZoom: ViewModifier {
//    @Binding var scale: CGFloat
//    @Binding var anchor: UnitPoint
//    @Binding var offset: CGSize
//    @Binding var isPinching: Bool
//
//
//    func body(content: Content) -> some View {
//
//        WebImage(url: URL(string: imgString))
//            .resizable()
//            .scaledToFit()
////                .scaleEffect(scale, anchor: anchor)
////                .offset(offset)
////                .animation(isPinching ? .none : .spring())
//
//
//            .overlay(
//                PinchZoom(scale: $scale, anchor: $anchor, offset: $offset, isPinching: $isPinching)
//            )
//
//
//    }
//}
//
//extension View {
//    func pinchToZoom(scale: Binding<CGFloat>, anchor: Binding<UnitPoint>, offset: Binding<CGSize>, isPinching: Binding<Bool>) -> some View {
//        self.modifier(PinchToZoom(scale: scale, anchor: anchor, offset: offset, isPinching: isPinching))
//    }
//    func pinchToZoomDefault() -> some View {
//        self.modifier(PinchToZoomDefault())
//    }
//}

public extension UIAlertController {
    func show() {
        let win = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .green
        win.rootViewController = vc
        win.windowLevel = UIWindow.Level.alert + 1  // Swift 3-4: UIWindowLevelAlert + 1
        win.makeKeyAndVisible()
        vc.present(self, animated: true, completion: nil)
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
    
    var cession  : String
    
    var section : String
    
    var flatNumber  : String
    
    var toUnderground : String
    
}
struct HideRowSeparatorModifier: ViewModifier {
    static let defaultListRowHeight: CGFloat = 44
    var insets: EdgeInsets
    var background: Color
    
    init(insets: EdgeInsets, background: Color) {
        self.insets = insets
        var alpha: CGFloat = 0
        //UIColor.init(background)
        // .getWhite(nil, alpha: &alpha)
        //UIColor(background).getWhite(nil, alpha: &alpha)
            // assert(alpha == 1, "Setting background to a non-opaque color will result in separators remaining visible.")
        self.background = background
    }
    
    func body(content: Content) -> some View {
        content
            .padding(insets)
            .frame(
                minWidth: 0, maxWidth: .infinity,
                minHeight: Self.defaultListRowHeight,
                alignment: .leading
            )
            .listRowInsets(EdgeInsets())
            .background(background)
    }
}

extension EdgeInsets {
    static let defaultListRowInsets = Self(top: 0, leading: 16, bottom: 0, trailing: 16)
}

extension View {
    func hideRowSeparator(insets: EdgeInsets = .defaultListRowInsets, background: Color = Color(.systemBackground)) -> some View {
        modifier(HideRowSeparatorModifier(insets: insets, background: background))
    }
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
    
    var toUnderground : String
    
    var cession : String
    
    
    
    
    
    
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
    var coordinateSpace: CoordinateSpace = .global
    
    var body: some View {
        return GeometryReader { geometry in
            self.makeView(geometry: geometry.frame(in: self.coordinateSpace))
        }
    }
    
    func makeView(geometry: CGRect) -> some View {
        DispatchQueue.main.async {
            withAnimation {
                
                self.rect = geometry
            }
           
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
struct CustomToggle : View {
    @Binding var isActive : Bool
    var body: some View {
        ZStack {
            Capsule().fill(isActive ? Color("ColorMain") : Color.init(.systemGray4)).frame(width: 55, height: 30)
            HStack {
                if isActive {
                    Spacer()
                }
                Circle().fill(Color.white).frame(width: 25, height: 25).onTapGesture {
                    self.isActive.toggle()
                }
                if !isActive {
                    Spacer()
                }
            }.padding(.horizontal, 3)
        }.frame(width: 55, height: 30).animation(.spring())
    }
}



extension View {
    /// Presents a sheet.
    ///
    /// - Parameters:
    ///     - height: The height of the presented sheet.
    ///     - item: A `Binding` to an optional source of truth for the sheet.
    ///     When representing a non-nil item, the system uses `content` to
    ///     create a sheet representation of the item.
    ///
    ///     If the identity changes, the system will dismiss a
    ///     currently-presented sheet and replace it by a new sheet.
    ///
    ///     - onDismiss: A closure executed when the sheet dismisses.
    ///     - content: A closure returning the content of the sheet.
    public func sheet<Item: Identifiable, Content: View>(height: SheetHeight, item: Binding<Item?>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping (Item) -> Content) -> some View {
        self.sheet(item: item, onDismiss: onDismiss) { item in
            SheetView(height: height, content: { content(item) })
        }
    }
    
    /// Presents a sheet.
    ///
    /// - Parameters:
    ///     - height: The height of the presented sheet.
    ///     - isPresented: A `Binding` to whether the sheet is presented.
    ///     - onDismiss: A closure executed when the sheet dismisses.
    ///     - content: A closure returning the content of the sheet.
    public func sheet<Content: View>(height: SheetHeight, isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) -> some View {
        self.sheet(isPresented: isPresented, onDismiss: onDismiss) {
            SheetView(height: height, content: content)
        }
    }
    
    func parseObj(_ query: QuerySnapshot) -> taObjects {
        
        
        var object = taObjects(id: "", address: "", complexName: "", deadline: "", developer: "", geo: GeoPoint(latitude: 0.0, longitude: 0.0), img: "", type: "", underground: "", toUnderground: "", cession: "")

        if let i = query.documents.first,
            let coords = i.get("geo"),
           let address = i.get("address") as? String,
           let complexName = i.get("complexName") as? String,
           let deadline = i.get("deadline") as? String ,
           let developer = i.get("developer") as? String ,
           let id = i.get("id") as? Int,
           let img = i.get("img") as? String,
           let cession = i.get("cession") as? String,
           let type = i.get("type") as? String ,
           let toUnderground = i.get("toUnderground") as? String,
           let underground = i.get("underground") as? String 
           {
                            let point = coords as! GeoPoint
                            
                            
            object = taObjects(id: String(id), address: address, complexName: complexName, deadline: deadline, developer: developer, geo: point, img: img, type: type, underground: underground, toUnderground: toUnderground, cession: cession)
        }
        return object
    }
     func parse(_ i: DocumentSnapshot) -> taFlatPlans {
        let id = i.get("id") as? Int ?? 0
      let img = i.get("img") as? String ?? ""
          let price = i.get("price") as? Int ?? 0
          let room = i.get("room") as? String ?? ""
          let type = i.get("type") as? String ?? ""
         
          let complexName = i.get("complexName") as? String ?? ""
          let deadline = i.get("deadline") as? String ?? ""
          
          let floor = i.get("floor") as? Int ?? 0
          let developer = i.get("developer") as? String ?? ""
          
          let district = i.get("district") as? String ?? ""
          
        let totalS =  i.get("totalS") as? Double ??  Double(i.get("totalS") as? Int ?? 0)
            
        
        
        let kitchenS =  i.get("kitchenS") as? Double ??  Double(i.get("kitchenS") as? Int ?? 0)

        let repair = i.get("repair") as? String ?? ""
          let roomType = i.get("roomType") as? String ?? ""
          let underground = i.get("underground") as? String ?? ""
        
        let cession = i.get("cession") as? String ?? ""
        
        let section = i.get("section") as? String ?? ""
        
        let flatNumber = i.get("flatNumber") as? String ?? ""
        
        let toUnderground = i.get("toUnderground") as? String ?? ""
  
        return taFlatPlans(id: "\(id)", img: img, complexName: complexName, price: String(price), room: room, deadline: deadline, type: type, floor: String(floor), developer: developer, district: district , totalS: String(totalS), kitchenS: String(kitchenS), repair: repair, roomType: roomType, underground: underground, cession : cession, section: section, flatNumber : flatNumber, toUnderground: toUnderground)
          
    }
}

public enum SheetHeight {
    case points(CGFloat)
    case percentage(CGFloat)
    /// When the provided content's height can be infered it will show up as that. ScrollView and List don't have this by default so they will show as 50%. You can use .frame(height:) to change that.
    case infered
    
    fileprivate func emptySpaceHeight(in size: CGSize) -> CGFloat? {
        switch self {
        case .points(let height):
            let remaining = size.height - height
            return max(remaining, 0)
        case .percentage(let percentage):
            precondition(0...100 ~= percentage)
            let remaining = 100 - percentage
            return size.height / 100 * remaining
        case .infered:
            return nil
        }
    }
}

private struct SheetView<Content: View>: View {
    var height: SheetHeight
    var content: () -> Content
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ParentInvisible {
            GeometryReader { geometry in
                VStack {
                    Spacer(minLength: self.height.emptySpaceHeight(in: geometry.size)).onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    ZStack(alignment: .bottom) {
                        SafeAreaFillView(geometry: geometry)
                        self.content().clipShape(SheetShape(geometry: geometry))
                    }
                }
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

private struct SafeAreaFillView: View {
    var geometry: GeometryProxy
    
    var body: some View {
        Color(.systemBackground)
            .frame(width: geometry.size.width, height: geometry.safeAreaInsets.bottom)
            .offset(y: geometry.safeAreaInsets.bottom)
    }
}

private struct ParentInvisible<Content: View>: UIViewControllerRepresentable {
    var content: () -> Content
    
    func makeUIViewController(context: Context) -> UIHostingController<Content> {
        let host = UIHostingController(rootView: content())
        host.view.backgroundColor = .clear
        return host
    }
    
    func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: Context) {
        uiViewController.parent?.view.backgroundColor = .clear
    }
}

private struct SheetShape: Shape {
    var geometry: GeometryProxy
    let radius = 8

    func path(in rect: CGRect) -> Path {
        var rect = rect
        rect.size.height += geometry.safeAreaInsets.bottom
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


extension Spacer {
    /// https://stackoverflow.com/a/57416760/3393964
    public func onTapGesture(count: Int = 1, perform action: @escaping () -> Void) -> some View {
        ZStack {
            Color.black.opacity(0.001).onTapGesture(count: count, perform: action)
            self
        }
    }
}

extension Array where Element: Equatable {

    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }

}

struct FlatOrder : Identifiable{
    var id : String
        
    var orderDesign : String
}



struct ImagePicker: UIViewControllerRepresentable {
 
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
 
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        
        imagePicker.delegate = context.coordinator
 
        return imagePicker
    }
 
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
 
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
     
        var parent: ImagePicker
     
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
     
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
     
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ImagesPicker: UIViewControllerRepresentable {
 
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImages: [ImagesArray]
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagesPicker>) -> UIImagePickerController {
 
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        
        imagePicker.delegate = context.coordinator
 
        return imagePicker
    }
 
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagesPicker>) {
 
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
     
        var parent: ImagesPicker
     
        init(_ parent: ImagesPicker) {
            self.parent = parent
        }
     
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                
                DispatchQueue.main.async {
                    self.parent.selectedImages.append(ImagesArray(id: "\(self.parent.selectedImages.count)", image: image))
                }
            }
     
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

enum ActiveSheet {
   case first, second
}

struct KeyboardAwareModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0

    private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
                .map { $0.cgRectValue.height },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
       ).eraseToAnyPublisher()
    }

    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onReceive(keyboardHeightPublisher) { self.keyboardHeight = $0 }
    }
}

extension View {
    func KeyboardAwarePadding() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAwareModifier())
    }
}
struct WebView: UIViewRepresentable {
    
    var view = WKWebView()
   
    var url: String
    var colorScheme  : colorScheme
    func makeUIView(context: Context) -> WKWebView {
        
        view.load(URLRequest(url: URL(string: url)!))
        view.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        view.backgroundColor = colorScheme == .dark ? .black : .white
        view.scrollView.minimumZoomScale = 1.0
        view.scrollView.maximumZoomScale = 1.0
        
        view.scrollView.isScrollEnabled = false
        
        view.scrollView.setZoomScale(1.0, animated: false)
        view.scrollView.delegate = context.coordinator
        return view
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    final class Coordinator: NSObject, UIScrollViewDelegate, UIWebViewDelegate {
     
        var parent: WebView
     
        init(_ parent: WebView) {
            self.parent = parent
        }
     
        func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
            parent.view.scrollView.pinchGestureRecognizer?.isEnabled = false
            }
        
    }
   
}
enum colorScheme {
    case dark, light
}
