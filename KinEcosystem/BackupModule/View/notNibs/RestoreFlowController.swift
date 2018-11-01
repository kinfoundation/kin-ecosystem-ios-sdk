//
//  RestoreFlowController.swift
//  KinEcosystem
//
//  Created by Corey Werner on 23/10/2018.
//  Copyright © 2018 Kik Interactive. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
class RestoreFlowController: FlowController {
    private var qrPickerController: QRPickerController?
    
    private lazy var _entryViewController: UIViewController = {
        let viewController = RestoreIntroViewController()
        viewController.delegate = self
        viewController.lifeCycleDelegate = self
        return viewController
    }()
    
    override var entryViewController: UIViewController {
        return _entryViewController
    }
}

@available(iOS 9.0, *)
extension RestoreFlowController: LifeCycleProtocol {
    func viewController(_ viewController: UIViewController, willAppear animated: Bool) {
        syncNavigationBarColor(with: viewController)
    }
    
    func viewController(_ viewController: UIViewController, willDisappear animated: Bool) {
        cancelFlowIfNeeded(viewController)
    }
}

// MARK: - Navigation

@available(iOS 9.0, *)
extension RestoreFlowController {
    private func presentQRPickerViewController() {
        guard QRPickerController.canOpenImagePicker else {
            // TODO: how to deal with this case?
            // why would the users device not allow for image picker presentation and
            // is there a way to circumvent this path?
            return
        }
        
        let qrPickerController = QRPickerController()
        qrPickerController.delegate = self
        navigationController.present(qrPickerController.imagePickerController, animated: true)
        self.qrPickerController = qrPickerController
    }
    
    private func pushPasswordViewController(with qrString: String) {
        let restoreViewController = RestoreViewController()
        restoreViewController.lifeCycleDelegate = self
        restoreViewController.imageView.image = QR.generateImage(from: qrString, for: CGSize(width: 100, height: 100))
        navigationController.pushViewController(restoreViewController, animated: true)
    }
}

// MARK: - Flow

@available(iOS 9.0, *)
extension RestoreFlowController: RestoreIntroViewControllerDelegate {
    func restoreIntroViewControllerDidComplete(_ viewController: RestoreIntroViewController) {
        presentQRPickerViewController()
    }
}

@available(iOS 9.0, *)
extension RestoreFlowController: QRPickerControllerDelegate {
    func qrPickerControllerDidComplete(_ controller: QRPickerController, with qrString: String?) {
        controller.imagePickerController.presentingViewController?.dismiss(animated: true)
        
        if let qrString = qrString {
            pushPasswordViewController(with: qrString)
        }
    }
}
