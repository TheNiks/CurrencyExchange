//
//  ProgressLoadingViewable.swift
//  CurrencyExchange
//
//  Created by Nikunj Modi on 20/11/22.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

protocol ProgressLoadingViewable {
    func startAnimating()
    func stopAnimating()
}
extension ProgressLoadingViewable where Self : MainViewController {
    func startAnimating(){
        let animateLoading = ProgressLoadingView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        view.addSubview(animateLoading)
        view.bringSubviewToFront(animateLoading)
        animateLoading.restorationIdentifier = "loadingView"
        animateLoading.center = view.center
        animateLoading.loadingViewMessage = "LOADING_MESSAGE".localized(withComment: "Loading Message")
       
        animateLoading.clipsToBounds = true
        animateLoading.startAnimation()
    }
    
    func stopAnimating() {
        for item in view.subviews
            where item.restorationIdentifier == "loadingView" {
                UIView.animate(withDuration: 0.3, animations: {
                    item.alpha = 0
                }) { (_) in
                    item.removeFromSuperview()
                }
        }
    }
}

extension MainViewController: ProgressLoadingViewable {}

extension Reactive where Base: MainViewController {
    
    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    internal var isAnimating: Binder<Bool> {
        return Binder(self.base, binding: { (vc, active) in
            if active {
                vc.startAnimating()
            } else {
                vc.stopAnimating()
            }
        })
    }
    
}

extension MainViewController {
    public func add(asChildViewController viewController: UIViewController,to parentView:UIView) {
        // Add Child View Controller
        addChild(viewController)
        parentView.addSubview(viewController.view)
        viewController.view.frame = parentView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
}
