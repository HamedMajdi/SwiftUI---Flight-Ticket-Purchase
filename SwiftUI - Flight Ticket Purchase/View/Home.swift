//
//  Home.swift
//  SwiftUI - Flight Ticket Purchase
//
//  Created by Hamed Majdi on 3/9/24.
//

import SwiftUI

struct Home: View {
    
    var size: CGSize
    var safeArea: EdgeInsets
    
    //Gesture Properties
    @State var offsetY: CGFloat = 0
    @State var currentCardOffset: CGFloat = 0
    
    //Animator State Object
    @StateObject var animator: Animator = .init()
    var body: some View {
        VStack(spacing: 0){
            HeaderView()
                .overlay(alignment: .bottomTrailing){
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(.white)
                                    .shadow(color: .black.opacity(0.35), radius: 5, x: 5, y: 5)
                            )
                    }
                    .offset(x: -15, y: 15)
                    .offset(x: animator.startAnimation ? 80 : 0)
                }
                .zIndex(1)
            PayementCardsView()
                .zIndex(0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background{
            ZStack(alignment: .bottom){
                ZStack{
                    //Cloud View (we use multiple cloud for better animation0)
                    if animator.showCloudView{
                        Group{
                            CloudView(delay: 1, size: size, cloudName: "Cloud2")
                                .offset(y: size.height * -0.1)
                            CloudView(delay: 0, size: size, cloudName: "Cloud2")
                                .offset(y: size.height * 0.3)
                            CloudView(delay: 2.5, size: size, cloudName: "Cloud")
                                .offset(y: size.height * 0.2)
                            CloudView(delay: 2.5, size: size, cloudName: "Cloud2")

                        }
                    }
                }
                .frame(maxHeight: .infinity)
                
                
                if animator.showLoadingView{
                    BackgroundView()
                        .transition(.scale)
                        .opacity(animator.showFinalView ? 0 : 1)
                }
            }
        }
        .allowsHitTesting(!animator.showFinalView) ///whenever the final view shows up, disable the actions on the overlayed view
        .background{
            if animator.startAnimation{
                DetailView(size: size, safeArea: safeArea)
                    .environmentObject(animator)
            }
        }
        .overlayPreferenceValue(RectKey.self, { value in
            if let anchor = value["PLANEBOUNDS"]{
                GeometryReader{proxy in ///why GeometryReader? because it can be used to extract CGRect form the anchor
                    let rect = proxy[anchor]
                    let planeRect = animator.initialPlaneBounds
                    let status = animator.currentPatmentStatus
                    // Resetting Plane when the final view is shown
                    let animationStatus = status == .finished && !animator.showFinalView
                    
                    Image("Airplane")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: planeRect.width, height: planeRect.height)
                    
                        //Flight Movement Animation
                        .rotationEffect(.init(degrees: animationStatus ? -10 : 0))
                        .shadow(color: .black.opacity(0.25), radius: 1, x: status == .finished ? -400 : 0, y: status == .finished ? 170 : 0)
                        .offset(x: planeRect.minX, y: planeRect.minY)
                        ///moving the plane a bit down to look like it is centered when the 3D animation is happening
                        .offset(y: animator.startAnimation ? 50 : 0)
                        .scaleEffect(animator.showFinalView ? 0.9 : 1)
                        .offset(y: animator.startAnimation ? 50 : 0)
                        .onAppear{
                            animator.initialPlaneBounds = rect
                        }
                        .animation(.easeInOut(duration: animationStatus ? 3.5 : 2.5), value: animationStatus)
                    
                }
            }
        })
        .overlay{
            if animator.showCloudView{
                CloudView(delay: 2.2, size: size, cloudName: "Cloud2")
                    .offset(y: -size.height * 0.25)
                    .opacity(0.8)
            }
        }
        .background{
            Color("BG")
                .ignoresSafeArea()
        }
        
        ///whenever the status changes to finish, toggle the cloud view
        .onChange(of: animator.currentPatmentStatus){
            if animator.currentPatmentStatus == .finished{
                animator.showCloudView = true
                
                // Enabling Final ViewAfter sime Time
                DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                    animator.showFinalView = true
                }
            }
            
        }
    }
    
    // Top Header View
    @ViewBuilder
    func HeaderView() -> some View{
        VStack{
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width * 0.4) /// what does size.width * 0.4 do? It sets the width of the image to 40% of the screen width
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack{
                FlightDetailView(place: "Istanbul", code: "IST", timing: "20 Feb, 14:30")
                
                VStack(spacing: 8){
                    Image(systemName: "chevron.right")
                        .font(.title2)
                    
                    Text("13H 30m")
                }
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                FlightDetailView(place: "Los Angles", code: "LAX", timing: "21 Feb, 04:00")
                
            }
            .padding(.top, 20)
            
            /// Ariplane Image View
            Image("Airplane")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 160)
            //hiding the original plane
                .opacity(0)
                .anchorPreference(key: RectKey.self, value: .bounds, transform: { anchor in
                    return ["PLANEBOUNDS" : anchor]
                })
                .padding(.bottom,-10)
            
        }
        .padding([.horizontal, .top], 15)
        .padding(.top, safeArea.top) /// what does safeArea.top do? It adds padding to the top of the screen
        .background{
            Rectangle()
                .fill(.linearGradient(
                    colors:[Color("BlueTop"), Color("BlueTop"), Color("BlueBottom")],
                    startPoint: .top,
                    endPoint: .bottom))
        }
        // Applying 3D Rotation
        .rotation3DEffect(.init(degrees: animator.startAnimation ? 90 : 0), axis: (x: 1, y: 0, z: 0), anchor: .init(x: 0.5, y: 0.8))
        
        .offset(y: animator.startAnimation ? -100 : 0)
    }
    
    //
    func buyTicket(){
        /// animating content
        withAnimation(.easeInOut(duration: 0.5)){
            animator.startAnimation = true
        }
        
        // showing loading view after some time
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            withAnimation(.easeInOut(duration: 0.7)){
                animator.showLoadingView = true
            }
        }
    }
    
    // Credit Cards View
    @ViewBuilder
    func PayementCardsView() -> some View{
        VStack{
            Text("SELECT PAYMENT METHOD")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.vertical)
            
            GeometryReader{ _ in /// what does _ in mean in geometry reader? it means that we don't care about the size of the screen
                VStack(spacing: 0){
                    ForEach(sampleCards.indices){index in
                        CardView(index: index)
                        
                    }
                }
                .padding(.horizontal, 30)
                .offset(y: offsetY)
                .offset(y: currentCardOffset * -200)
                
                //Gradinet View
                Rectangle()
                    .fill(.linearGradient(
                        colors: [
                            .clear,
                            .clear,
                            .clear,
                            .clear,
                            .white.opacity(0.3),
                            .white.opacity(0.7),
                            .white
                        ], startPoint: .top, endPoint: .bottom))
                    .allowsHitTesting(false) // what does this mean? It means that the rectangle is not clickable. Reason: Since the rectanle is an overlay view, it will prevent all interactions whth the view below, so activating this modifier will entirely disable the rectangl's interatction
                
                // Purchase Button
                Button {
                    buyTicket()
                } label: {
                    Text("Confirm $1,367.00")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background{
                            Capsule()
                                .fill(Color("BlueTop").gradient)
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, safeArea.bottom == 0 ? 15 : safeArea.bottom)
            }
            .coordinateSpace(name: "SCROLL")
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onChanged({ value in
                    offsetY = value.translation.height * 0.3
                })
                .onEnded({ value in
                    let translation = value.translation.height
                    withAnimation(.easeInOut){
                        // Increasing/Decreasing index based on condition
                        // 100 because Card height is 200
                        if translation > 0 && translation > 100 && currentCardOffset > 0{
                            currentCardOffset -= 1
                        }
                        if translation < 0 && -translation > 100 && currentCardOffset < CGFloat(sampleCards.count - 1){
                            currentCardOffset += 1
                        }
                        
                        offsetY = .zero
                    }
                })
        )
        .background{
            Color.white
                .ignoresSafeArea()
        }
        .clipped()
        
        // Applying 3D rotation
        .rotation3DEffect(.init(degrees: animator.startAnimation ? -90 : 0), axis: (x: 1, y: 0, z: 0), anchor: .init(x: 0.5, y: 0.25))
        .offset(y: animator.startAnimation ? 100 : 0)
    }
    
    // Card View
    @ViewBuilder
    func CardView(index: Int) -> some View{
        GeometryReader{proxy in /// proxy means that we are getting the size of the screen
            let size = proxy.size
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let progress = minY / size.height
            let constrainedProgress = progress > 1 ? 1 : progress < 0 ? 0: progress
            Image(sampleCards[index].cardImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width, height: size.height)
                .shadow(color: .black.opacity(0.14), radius: 8, x: 6, y: 6)
                .rotation3DEffect(.init(degrees: constrainedProgress * 40.0), axis: (x: 1, y: 0, z: 0), anchor: .bottom)
                .padding(.top, progress * -160)
            // Moving Current Card to the top
                .offset(y: progress < 0 ? progress * 250 : 0)
        }
        .frame(height: 200)
        .zIndex(Double(sampleCards.count - index))
        .onTapGesture {
            print(index)
        }
    }
    
    // Background Loading View with Ring Animations
    @ViewBuilder
    func BackgroundView() -> some View{
        VStack{
            //PayementStatus
            VStack(spacing: 0){
                ForEach(PayementStatus.allCases, id: \.rawValue){ status in
                    Text(status.rawValue)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray.opacity(0.5))
                        .frame(height: 30)
                }
            }
            .offset(y: animator.currentPatmentStatus == .started ? -30 : animator.currentPatmentStatus == .finished ? -60 : 0)
            .frame(height: 40, alignment: .top)
            .clipped()
            
            ZStack{
                //rings 1
                Circle()
                    .fill(Color("BG"))
                    .shadow(color: .white.opacity(0.45), radius: 5, x: 5, y: 5)
                    .shadow(color: .white.opacity(0.45), radius: 5, x: -5, y: -5)
                    .scaleEffect(animator.ringAnimation[0] ? 5 : 1)
                    .opacity(animator.ringAnimation[0] ? 0 : 0.5)

                //ring 2
                Circle()
                    .fill(Color("BG"))
                    .shadow(color: .white.opacity(0.45), radius: 5, x: 5, y: 5)
                    .shadow(color: .white.opacity(0.45), radius: 5, x: -5, y: -5)
                    .scaleEffect(animator.ringAnimation[1] ? 5 : 1)
                    .opacity(animator.ringAnimation[1] ? 0 : 0.5)

                
                Circle()
                    .fill(Color("BG"))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                    .scaleEffect(1.22)
                
                Circle()
                    .fill(.white)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                
                Image(systemName: animator.currentPatmentStatus.symbolImage)
                    .font(.largeTitle)
                    .foregroundStyle(.gray.opacity(0.5))
            }
            .frame(width: 80, height: 80)
            .padding(.top, 20)
            .zIndex(0)
        }
        // Using Timer to stimulate the loading
        .onReceive(Timer.publish(every: 2.3, on: .main, in: .common).autoconnect()){ _ in
            withAnimation(.easeInOut(duration: 03)){
                if animator.currentPatmentStatus == .initiated {
                    animator.currentPatmentStatus = .started
                } else {
                    animator.currentPatmentStatus = .finished
                }
            }
        }
        .onAppear(){
            withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)){
                animator.ringAnimation[0] = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35){
                withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)){
                    animator.ringAnimation[1] = true
                }
            }
        }
        .padding(.bottom, size.height * 0.15)
        
    }
    
     
}

#Preview {
    ContentView()
}

//Cloud View
struct CloudView: View {
    var delay: Double
    var size: CGSize
    @State private var moveCloud: Bool = false
    var cloudName: String
    
    var body: some View {
        ZStack{
            Image(cloudName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width * 3)
                .offset(x: moveCloud ? -size.width * 2 : size.width * 2)
        }
        .onAppear{
            
            // Duration is = Speed of the movement of the cloud
            withAnimation(.easeInOut(duration: 6.5).delay(delay)){
                moveCloud.toggle()
            }
        }
    }
}



class Animator: ObservableObject {
    @Published var startAnimation: Bool = false
    
    //inital plane position
    @Published var initialPlaneBounds: CGRect = .zero
    
    @Published var currentPatmentStatus: PayementStatus = .initiated
    
    @Published var ringAnimation: [Bool] = [false, false]
    
    // Loading Status
    @Published var showLoadingView: Bool = false
    
    // Cloud View Status
    @Published var showCloudView: Bool = false
    
    // Final View Status
    @Published var showFinalView: Bool = false
}

// Anchonr Preference Key
/// The reason we need it is that since the flight Image rotates when 3D animation is applied, we must first determine its percise location on the screen in order to add the same image as on overlay. Using anchorPreference, we can recover its precise location on the screen.


///This Swift code defines a structure RectKey that conforms to the PreferenceKey protocol. PreferenceKey is a protocol in SwiftUI used to communicate values hierarchically in the view tree. Here’s what each part of the code does:
///static var defaultValue: [String: Anchor<CGRect>] = [:]: This line defines a static variable defaultValue which is a dictionary with keys of type String and values of type Anchor<CGRect>. The Anchor struct in SwiftUI represents a value that’s anchored to a specific location in the view. Here, it’s anchored to a CGRect, which represents a rectangle in the coordinate system. The defaultValue is initially an empty dictionary.
///static func reduce(value: inout [String: Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]): This is a static function required by the PreferenceKey protocol. It’s used to determine what to do when a new value is set. The value parameter is the current value of the preference key, and nextValue is a closure that returns the new value.
///value.merge(nextValue()){$1}: This line merges the current value and the new value. If there are any duplicate keys, the $1 in the closure means that the value from nextValue() will be used.

struct RectKey: PreferenceKey{
    
    static var defaultValue: [String: Anchor<CGRect>] = [:]

    //what does the function below doex exactly? it collects the anchor values and returns it
    //what is the inputs and outputs of it? It takes in the anchor values and returns it
    /// what does value: inout [String: Anchor<CGRect>] mean? It means that we are modifying the value of the anchor
    
    static func reduce(value: inout [String: Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>])
    {
        value.merge(nextValue()){$1}
    }
}
