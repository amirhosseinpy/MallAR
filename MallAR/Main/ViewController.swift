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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var hintLabel: UILabel!
    
    
    private var arView: ARView!
    
    private let viewModel = MainViewModel()
    
    private let bag = DisposeBag()
    
    private var streams = [Combine.AnyCancellable]()
    
    private let cellName = "ItemsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupBindings()
        
        viewModel.getEntities()
        addCoinsToView()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.bringSubviewToFront(collectionView)
        view.bringSubviewToFront(hintLabel)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.8,
              delay:0.0,
              options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
              animations: { self.hintLabel.alpha = 0 },
              completion: nil)
    }
    
    func setupView() {
        self.arView = ARView(frame: .zero)
        self.view.addSubview(self.arView)
        self.arView.snp.makeConstraints { make in
            make.bottom.top.leading.trailing.equalToSuperview()
        }
        
        hintLabel.layer.cornerRadius = 8
    }
    
    func setupCollectionView() {
        collectionView.register(
            UINib(nibName: cellName, bundle: nil),
            forCellWithReuseIdentifier: cellName)
        
        viewModel
            .itemsList
            .bind(to: collectionView.rx.items(cellIdentifier: cellName, cellType: ItemsCell.self)) { (row, element, cell) in
                cell.itemImage.image = UIImage(named: element.imageName ?? "")
                cell.itemImage.layer.cornerRadius = 12
             }
             .disposed(by: bag)
        
        viewModel.getItems()
    }
    
    func setupBindings() {
        viewModel.entitiesDestinationPath.subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (downloadFilePath) in
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
    
    func addCoinsToView() {
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


