//
//  PlayerControllerProtocol.swift
//  Course
//
//  Created by Vadim Kuznetsov on 22.04.24.
//

import Foundation

@MainActor
public protocol PlayerControllerProtocol {
    func play()
    func pause()
    func seekTo(to date: Date)
    func stop()
}
