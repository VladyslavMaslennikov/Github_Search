//
//  ActivityIndicator.swift
//  Github_Search
//
//  Created by Vladyslav on 04.02.2021.
//

import UIKit

class ActivityIndicator {
    private let animDuration = 0.2
    private var isHidden = true
    private let indicator: UIActivityIndicatorView
    init(indicator: UIActivityIndicatorView = UIActivityIndicatorView()) {
        self.indicator = indicator
    }
    
    func addIndicator(to controller: UIViewController) {
        let origin = CGPoint(x: (controller.view.frame.size.width / 2), y: controller.view.frame.height - 100)
        let frame = CGRect(origin: origin, size: indicator.frame.size)
        indicator.frame = frame
        indicator.alpha = 0.0
        controller.view.addSubview(indicator)
    }
    
    private func callIndicator() {
        if isHidden {
            UIView.animate(withDuration: animDuration) { [weak self] in
                self?.indicator.alpha = 1.0
            } completion: { [weak self] _ in
                self?.indicator.startAnimating()
                self?.isHidden = false
            }
        } else {
            indicator.stopAnimating()
            UIView.animate(withDuration: animDuration) { [weak self] in
                self?.indicator.alpha = 0.0
                self?.isHidden = true
            }
        }
    }
    
    func triggerUpdateBySwipe(for scrollView: UIScrollView, closure: () -> ()) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - currentOffset <= -80.0 {
            callIndicator()
            closure()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.callIndicator()
            }
        }
    }
}
