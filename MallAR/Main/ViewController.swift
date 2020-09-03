//
//  ViewController.swift
//  MallAR
//
//  Created by amirhosseinpy on 7/12/1398 AP.
//  Copyright © 1398 Farazpardazan. All rights reserved.
//

import UIKit
import ARKit
import RealityKit
import SnapKit
import RxSwift
import Combine


class ViewController: UIViewController, ARSCNViewDelegate {
    
    private var arView: ARView!
    
    private let viewModel = MainViewModel()
    
    private let bag = DisposeBag()
    
    private var streams = [Combine.AnyCancellable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupBindings()
        
        viewModel.getEntities()
    }
    
    func setupView() {
        self.arView = ARView(frame: .zero)
        self.view.addSubview(self.arView)
        self.arView.snp.makeConstraints { make in
            make.bottom.top.leading.trailing.equalToSuperview()
        }
    }
    
    func setupBindings() {
        viewModel.entitiesDestinationPath.subscribeOn(MainScheduler.instance).subscribe(onNext: { [weak self] (downloadFilePath) in
            self?.loadAnchors(entityPath: downloadFilePath)
        }).disposed(by: bag)
    }
    
    func loadAnchors(entityPath: URL) {
        var cancellable: Combine.AnyCancellable?
        let loadRequest = Exprience.AluminumCoin.loadAnchorAsync(contentsOf: entityPath)
        cancellable = loadRequest.sink(receiveCompletion: { loadCompletion in
            if case let .failure(error) = loadCompletion {
                print(error)
            }
            self.streams.removeAll { $0 === cancellable }
        }, receiveValue: { entity in
            let item = self.createItem(from: entity)
            self.arView.scene.anchors.append(item)
        })
        cancellable?.store(in: &streams)
    }
    
    func createItem(from anchorEntity: RealityKit.AnchorEntity) -> EntityItem {
        let item = EntityItem()
        item.anchoring = anchorEntity.anchoring
        item.addChild(anchorEntity)
        return item
    }
    
    func addConinsToView() {
        Exprience.loadAluminumCoinAsync(completion: { [weak self] result in
            switch result {
                case .failure(let error):
                    print(error)
                case .success(let aluminumCoin):
                    self?.arView.scene.anchors.append(aluminumCoin)
            }
        })
        
        Exprience.loadGoldenCoinAsync(completion: { [weak self] result in
            switch result {
                case .failure(let error):
                    print(error)
                case .success(let goldenCoin):
                    self?.arView.scene.anchors.append(goldenCoin)
            }
        })
    }
}

public class EntityItem: RealityKit.Entity, RealityKit.HasAnchoring {

}


