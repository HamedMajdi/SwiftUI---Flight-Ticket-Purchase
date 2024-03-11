//
//  PayementStatus.swift
//  SwiftUI - Flight Ticket Purchase
//
//  Created by Hamed Majdi on 3/10/24.
//

enum PayementStatus: String, CaseIterable {
    case started = "Connected..."
    case initiated = "Secure Payement..."
    case finished = "Purchased!"
    
    var symbolImage: String{
        switch self {
        case .started:
            return "wifi"
        case .initiated:
            return "checkmark.shield"
        case .finished:
            return "checkmark"
        }
    }
}
