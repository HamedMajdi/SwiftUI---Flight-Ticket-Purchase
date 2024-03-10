//
//  FlightDetailsView.swift
//  SwiftUI - Flight Ticket Purchase
//
//  Created by Hamed Majdi on 3/10/24.
//

import SwiftUI

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

#Preview {
    FlightDetailsView("", code: "", timing: "")
}
