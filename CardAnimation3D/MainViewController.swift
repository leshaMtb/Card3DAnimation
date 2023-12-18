//
//  MainViewController.swift
//  CardAnimation3D
//
//  Created by Aleksey Shirokov on 14.12.2023.
//

import UIKit
import CoreMotion

class MainViewController: UIViewController {

    let motionManager = CMMotionManager()

    private lazy var card: UIView = {
        let card = UIView()
        card.backgroundColor = .magenta
        card.layer.cornerRadius = 6
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()

    private lazy var cardLabel: UILabel = {
        let label = UILabel()
        label.text = "Bank Name"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        animateCardByMotion()

    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(card)
        card.frame = .init(x: 20,
                           y: 100,
                           width: UIScreen.main.bounds.width - 40,
                           height: 180)
        card.addSubview(cardLabel)
        cardLabel.frame = .init(x: 20,
                                y: 20,
                                width: 100,
                                height: 30)
    }

    private func animateCardByMotion() {
        guard motionManager.isDeviceMotionAvailable else {
            return
        }
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { data, error in
            guard let data else {
                return
            }
            let xRotation = round(data.rotationRate.x * 10) / 10.0
            let yRotation = round(data.rotationRate.y * 10) / 10.0
            guard xRotation > 0.1 || xRotation < -0.1 || xRotation == 0.0,
                  yRotation > 0.1 || yRotation < -0.1 || yRotation == 0.0 else {
                return
            }
            UIView.animate(withDuration: 0.1) {
                var transform3D = CATransform3DIdentity
                transform3D.m34 = -1 / 1500
                self.view.layer.sublayerTransform = transform3D
                let angle: CGFloat = .pi / 16
                self.card.transform3D = CATransform3DRotate(transform3D, angle, xRotation, yRotation, 0)
            }
        }
    }
}
