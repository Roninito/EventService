//
//  Events.swift
//  DragTestign
//
//  Created by leerie simpson on 3/6/21.
//

import Foundation
import Combine
import ServiceKit


public class Events: ObservableObject, Serviceable {
    public typealias ServiceProvider = Events
    public var provider: Events { self }
    private var manifest: [String: Event] = [:]
    
    
    public init() {
        registerAsServiceable()
    }
    
    
    private func register(event: Event) {
        manifest[event.id] = event
    }
    
    
    private func event(_ eventID: String) -> Event? {
        manifest[eventID]
    }
    
    
    public subscript(_ key: String = "") -> Event? {
        get { event(key) }
        set { register(event: newValue!) }
    }
    
    
    public func raise(by: Any, _ eventID: String, info: [String: Any]) {
        event(eventID)?.raised = info
    }
}


public class Event: Identifiable {
    public var id: String
    @Published public var raised: [String: Any]
    
    public init(_ eventID: String) {
        self.id = eventID
        self.raised = [:]
    }
}

