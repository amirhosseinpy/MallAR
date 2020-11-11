//
//  MainViewModel.swift
//  MallAR
//
//  Created by amirhosseinpy on 6/13/1399 AP.
//  Copyright © 1399 Farazpardazan. All rights reserved.
//

import Foundation
import RxSwift

struct MainViewModel {
    let entitiesDestinationPath = PublishSubject<URL>()
    let error = PublishSubject<Error>()
    let isLoading = PublishSubject<Bool>()
    let bag = DisposeBag()
    
    private var netAgent = NetworkAgent(baseUrl: URL(string: "http://military.farazpardazan.com")!)
    
    
    func getEntities() {
        let mainRouter = MainRouter()
        
        isLoading.onNext(true)
        netAgent.request(mainRouter).subscribe(onNext: { models in
            self.downloadModels(models: models ?? [])
            self.isLoading.onNext(false)
        }, onError: { error in
            self.isLoading.onNext(false)
            self.error.onNext(error)
        }).disposed(by: bag)
    }
    
    func downloadModels(models: [EntityModel]) {
        let filteredModels = models.filter { model -> Bool in
            (model.name?.contains(".reality") ?? false)
        }
        
        let fileDownloader = FileDownloader()
        for item in filteredModels {
            fileDownloader.loadFileAsync(urlString: item.url, fileName: item.name) { (destination) in
                guard let destination = destination else { return }
                
                self.entitiesDestinationPath.onNext(destination)
            }
        }
    }
}
