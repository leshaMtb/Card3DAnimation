//
//  MainViewController.swift
//  CardAnimation3D
//
//  Created by Aleksey Shirokov on 14.12.2023.
//

import UIKit
import CoreMotion

class MainViewController: UIViewController {

    private let motionManager = CMMotionManager()

    private lazy var cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(imageLiteralResourceName: "MTC-Logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.allowsEdgeAntialiasing = true
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        animateCardByMotion()

    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(cardImageView)
        cardImageView.frame = .init(x: 16,
                                    y: 100,
                                    width: UIScreen.main.bounds.width - 32,
                                    height: 180)

    }
    
    private func animateCardByMotion() {
        guard motionManager.isDeviceMotionAvailable else {
            return
        }
        motionManager.deviceMotionUpdateInterval = 0.15
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { data, error in
            guard let data else {
                return
            }

            let xGravity = round(data.gravity.x * 10) / 10.0
            let yGravity = (round(data.gravity.y * 10) / 10.0) + 0.6
            UIView.animate(withDuration: 0.15) {
                var transform3D = CATransform3DIdentity
                transform3D.m34 = -1 / 1500
                self.view.layer.sublayerTransform = transform3D
                let angle: CGFloat = .pi / 25
                self.cardImageView.transform3D = CATransform3DRotate(transform3D, angle, -yGravity, -xGravity, 0)
            }
        }
    }
}
