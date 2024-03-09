//
//  Card.swift
//  SwiftUI - Flight Ticket Purchase
//
//  Created by Hamed Majdi on 3/9/24.
//

import Foundation

struct Card: Identifiable{
    var id = UUID()
    var cardImage: String
}

var sampleCards: [Card] = [
    Card(cardImage: "card2"),
    Card(cardImage: "card5"),
    Card(cardImage: "card4"),
    Card(cardImage: "card7"),
    Card(cardImage: "card10"),
    Card(cardImage: "card8"),
    Card(cardImage: "card9"),
    Card(cardImage: "card1"),
    Card(cardImage: "card6"),
    Card(cardImage: "card3")
]
