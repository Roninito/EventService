//
//  Events.swift
//  DragTestign
//
//  Created by leerie simpson on 3/6/21.
//

import Foundation
import Combine
import ServiceKit
import JavaScriptCore


@objc public protocol EventJSExports: JSExport {
	var id: String { get }
	func raiseWith(_ value: JSValue)
}

@objc public class Event: NSObject, ObservableObject, Identifiable, NSSecureCoding, EventJSExports {
	public static var supportsSecureCoding: Bool = true
	@objc public dynamic var id: String
    @Published public var raised: [String: Any]
	
    public init(_ eventID: String) {
        self.id = eventID
        self.raised = [:]
    }
	
	public required init?(coder: NSCoder) {
		id = coder.decodeObject(of: NSString.self, forKey: "id")! as String
		raised = coder.decodeObject(of: NSDictionary.self, forKey: "raised") as! [String: Any]
	}

	public func encode(with coder: NSCoder) {
		coder.encode(NSString(utf8String: id), forKey: "id")
		coder.encode(NSDictionary(dictionary: raised), forKey: "raised")
	}
	
	@objc public func raiseWith(_ value: JSValue ) {
		if let dic = value.toObject() as? [String: Any] {
			raised = dic
		}
		else {
			print("Unable to raise value passed through script because it was not convertible to value.toObject() as! [String: Any]")
		}
	}
}

