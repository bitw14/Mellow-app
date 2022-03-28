//
//  AudioFiles.swift
//  Mellow Software
//
//  Created by Abdul Waheed on 28/03/2022.
//

import Foundation

enum AudioFiles: CaseIterable {
    case bee1
    case bee4
    case birdWings
    case drop
    case insect
    case owl4
    case owl9
    case treeBranches
    case woodPecker4
    case woodPecker8
    
    var processableFormat: (name: String, volume: Double) {
        switch self {
        case .bee1:
            return (name: "Bees 1.m4a", volume: 0.1)
        case .bee4:
            return (name: "Bees 4.m4a", volume: 0.25)
        case .birdWings:
            return (name: "Bird wings flapping 3.m4a", volume: 1.0)
        case .drop:
            return (name: "Dropping object 1.m4a", volume: 0.05)
        case .insect:
            return (name: "Insects 4.m4a", volume: 0.01)
        case .owl4:
            return (name: "Owl 4.m4a", volume: 0.4)
        case .owl9:
            return (name: "Owl 9.m4a", volume: 0.7)
        case .treeBranches:
            return (name: "Tree branches 10.m4a", volume: 0.85)
        case .woodPecker4:
            return (name: "Woodpecker 4.m4a", volume: 0.2)
        case .woodPecker8:
            return (name: "Woodpecker 8.m4a", volume: 0.15)
        }
    }
}
