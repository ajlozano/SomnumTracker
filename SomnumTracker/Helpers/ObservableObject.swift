//
//  ObservableObject.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 27/4/23.
//

import Foundation

final class ObservableObject<T> {
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    private var listener: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind (_ listener: @escaping(T) -> Void) {
        listener(value)
        self.listener = listener
    }
}
