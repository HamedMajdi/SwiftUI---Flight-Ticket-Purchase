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
                }
                .zIndex(1)
            PayementCardsView()
                .zIndex(0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background{
            Color("BG")
                .ignoresSafeArea()
        }
    }
    
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
    }
    
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
                
                Button {
                    
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
    }
    
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
}

#Preview {
    ContentView()
}


/// Flight Details
struct FlightDetailView: View {
    var alignment: HorizontalAlignment = .leading
    var place: String
    var code: String
    var timing: String
    
    var body: some View {
        
        VStack(alignment: alignment, spacing: 6){
            Text(place)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))
            
            Text(code)
                .font(.title)
                .foregroundStyle(.white)
            
            Text(timing)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
    }
}

// Detail View
// TODO: Move this view to it's own file
struct DetailView: View {
    
    var size: CGSize
    var safeArea: EdgeInsets
    
    var body: some View {
        VStack{
            VStack{
                VStack(spacing: 0){
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 35)
                    
                    Text("Your order was submitted")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.top, 20)
                    
                    Text("We are waiting for booking confirmation")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 30)
                .padding(.bottom, 40)
                .background{
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.white.opacity(0.1))
                }
                
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
                .padding(15)
                .padding(.bottom, 70)
                .background{
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.ultraThinMaterial)
                }
                .padding(.top, -20)
            }
            .padding(.horizontal, 20)
            .padding(.top, safeArea.top + 15)
            .padding([.horizontal, .bottom], 15)
            .background{
                Rectangle()
                    .fill(Color("BlueTop"))
                    .padding(.bottom, 90)
            }
            
            //Contact Information View
            GeometryReader{proxy in
                ViewThatFits{
                    ContactInformation()
                    ScrollView(.vertical, showsIndicators: false){
                        ContactInformation()
                    }
                }
            }
        }
        
    }
    
    @ViewBuilder
    func ContactInformation() -> some View{
        VStack(spacing: 15){
            HStack{
                InfoView(title: "Flight", subtitle: "CA 1549")
                InfoView(title: "Class", subtitle: "Premium")
                InfoView(title: "Aircraft", subtitle: "B 737-Max9")
                InfoView(title: "Possibility", subtitle: "CA 1549")
            }
            
            ContactView(name: "Hamed Majdi", email: "majdi.haamed@gmail.com", profile: "user1")
                .padding(.top, 30)
            
            ContactView(name: "Craig Federighi", email: "craig.fed@gmail.com", profile: "user2")
                .padding(.top, 10)
            
            VStack(alignment: .leading, spacing: 4){
                Text("Total Price")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                
                Text("$1,367.00")
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            .padding(.leading, 15)
            
            
            
            // Home Screen Button
            Button{
                
            } label: {
                Text("Go to Home Screen")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background{
                            Capsule()
                            .fill(Color("BlueTop").gradient)
                    }
            }
            .padding(.top, 15)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, safeArea.bottom)
        }
        .padding(15)
    }
    
    @ViewBuilder
    func ContactView(name: String, email: String, profile: String) -> some View{
        HStack{
            VStack(alignment: .leading, spacing: 4){
                Text(name)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                
                Text(email)
                    .font(.callout)
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(profile)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 45, height: 45)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
        }
        .padding(.horizontal, 15)
    }
    
    @ViewBuilder
    func InfoView(title: String, subtitle: String) -> some View{
        VStack(alignment: .center, spacing: 4){
            Text(title)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
            
            Text(subtitle)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}
