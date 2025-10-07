//
//  LogStore.swift
//  GittyCat
//
//  Created by Krushn Dayshmookh on 07/10/25.
//

import Foundation

final class LogStore: ObservableObject {
    @Published var lines: [String] = []

    func append(_ s: String) {
        DispatchQueue.main.async {
            self.lines.append("[\(Date())] " + s)
        }
    }
}
