//
//  DetailView.swift
//  SwiftUI - Flight Ticket Purchase
//
//  Created by Hamed Majdi on 3/10/24.
//

import SwiftUI

// Detail View
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

#Preview {
    ContentView()
}
