//
//  ObservableDictionary.swift
//  
//
//  Created by Mike Enriquez on 3/23/21.
//

import SwiftUI

public class ObservableDictionary<Key: Hashable, T: ObservableObject>: ObservableObject {
    private(set) public var dictionary: [Key:T]
    private var cancellables = [AnyObject]()

    init(dictionary: [Key: T] = [Key: T]()) {
        self.dictionary = dictionary
        self.cancellables = self.dictionary.map { _, value in
            value.objectWillChange.sink(receiveValue: { _ in self.objectWillChange.send()})
        }
    }
}
