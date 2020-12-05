//
//  PageViewController.swift
//  MallAR
//
//  Created by amirhosseinpy on 9/8/1399 AP.
//  Copyright © 1399 AP Farazpardazan. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PageViewController: UIViewController {
 
    var pageIndex: Int = 0
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var enterButton: UIButton!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupAction()
    }
    
    func setupView() {
        switch pageIndex {
        case 0:
            setupFirstPage()
        case 1:
            setupSecondPage()
        case 2:
            setupThirdPage()
        case 3:
            setupForthPage()
        default:
            return
        }
    }
    
    func setupFirstPage() {
        self.view.backgroundColor = UIColor(netHex: 0x435389)
        mainImage.isHidden = true
        self.descriptionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.descriptionLabel.text = "به اپلیکیشن واقعیت افزوده مال خوش امدید"
    }
    
    func setupSecondPage() {
        self.view.backgroundColor = UIColor(netHex: 0x435389)
        self.mainImage.image = UIImage(named: "mall")
        self.descriptionLabel.text = "در این اپلیکیشن شما میتوانید در این مال گردش کرده و سکه ها و ایتم هایی که ما برای شما در جایی پنهان کردیم را پیدا کنید و امتیاز ان را کسب نمایید."
    }
    
    func setupThirdPage() {
        self.view.backgroundColor = UIColor(netHex: 0x435389)
        self.mainImage.image = UIImage(named: "location")
        self.descriptionLabel.text = "برای موفقیت بیشتر در مکان های پر رفت و امد به دنبال شی های مجازی بگردید"
    }
    
    func setupForthPage() {
        self.view.backgroundColor = UIColor(netHex: 0x435389)
        self.mainImage.image = UIImage(named: "map")
        self.descriptionLabel.text = ""
        
        enterButton.layer.cornerRadius = 24
        enterButton.isHidden = false
    }
    
    func setupAction() {
        enterButton.rx.tap.subscribe { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let viewController = storyboard.instantiateViewController(identifier: "ViewController")
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
            
        }.disposed(by: bag)

    }
}
