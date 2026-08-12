//
//  Item.swift
//  SmartTravelJournal
//
//  Modello di esempio del template SwiftData di Xcode.
//  Verrà sostituito da Trip e JournalEntry nel Lab 2.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date

    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
