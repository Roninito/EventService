//
//  Events.swift
//  DragTestign
//
//  Created by leerie simpson on 3/6/21.
//

import Foundation
import Combine
import ServiceKit


public class Event: Identifiable {
    public var id: String
    @Published public var raised: [String: Any]
    
    public init(_ eventID: String) {
        self.id = eventID
        self.raised = [:]
    }
}

