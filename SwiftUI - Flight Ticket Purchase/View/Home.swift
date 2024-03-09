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
                .zIndex(1)
            PayementCardsView()
                .zIndex(0)
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
    
    ///Flight Details
    @ViewBuilder
    func FlightDetailView(alignment: HorizontalAlignment = .leading, place: String, code: String, timing: String) -> some View{
        
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
        }
        .frame(height: 200)
        .zIndex(Double(sampleCards.count - index))
    }
}

#Preview {
    ContentView()
}
