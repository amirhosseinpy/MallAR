//
//  Experience.swift
//  MallAR
//
//  Created by amirhosseinpy on 8/17/1398 AP.
//  Copyright © 1398 Farazpardazan. All rights reserved.
//

import Foundation
import RealityKit
import Combine

enum Experience {
    private static var streams = [Combine.AnyCancellable]()
    
    public static func loadScene() throws -> Experience.Scene {
        guard let realityFileURL = Foundation.Bundle(for: Experience.Scene.self).url(forResource: "Resources/Coin", withExtension: "reality") else {
            throw Experience.LoadRealityFileError.fileNotFound("Coin.reality")
        }

        let realityFileSceneURL = realityFileURL.appendingPathComponent("Scene", isDirectory: false)
        let anchorEntity = try Experience.Scene.loadAnchor(contentsOf: realityFileSceneURL)
        return createScene(from: anchorEntity)
    }
    
    public static func loadSceneAsync(completion: @escaping (Swift.Result<Experience.Scene, Swift.Error>) -> Void) {
        guard let realityFileURL = Foundation.Bundle(for: Experience.Scene.self).url(forResource: "Coin", withExtension: "reality") else {
            completion(.failure(Experience.LoadRealityFileError.fileNotFound("Coin.reality")))
            return
        }

        var cancellable: Combine.AnyCancellable?
        let realityFileSceneURL = realityFileURL.appendingPathComponent("Scene", isDirectory: false)
        let loadRequest = Experience.Scene.loadAnchorAsync(contentsOf: realityFileSceneURL)
        cancellable = loadRequest.sink(receiveCompletion: { loadCompletion in
            if case let .failure(error) = loadCompletion {
                completion(.failure(error))
            }
            streams.removeAll { $0 === cancellable }
        }, receiveValue: { entity in
            completion(.success(Experience.createScene(from: entity)))
        })
        cancellable?.store(in: &streams)
    }
    
    public enum LoadRealityFileError: Error {
          case fileNotFound(String)
    }
    
    private static func createScene(from anchorEntity: RealityKit.AnchorEntity) -> Experience.Scene {
        let scene = Experience.Scene()
        scene.anchoring = anchorEntity.anchoring
        scene.addChild(anchorEntity)
        return scene
    }
    
    public class Scene: RealityKit.Entity, RealityKit.HasAnchoring {
        var goldCoin: RealityKit.Entity? {
            return self.findEntity(named: "gold_coin")
        }
    }
}

extension Experience {
    public struct AnchorPlacement {

        /// The identifier of the anchor the game is placed on. Used to re-localized the game between levels.
        var arAnchorIdentifier: UUID?

        /// The transform of the anchor the game is placed on . Used to re-localize the game between levels.
        var placementTransform: Transform?

    }
}

