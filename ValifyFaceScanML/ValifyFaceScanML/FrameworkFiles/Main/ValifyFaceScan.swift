//
//  ValifyFaceScan.swift
//  ValifyFaceScanML
//
//  Created by Mahmoud Saad on 03/08/2024.
//

import Foundation
import AVFoundation
import UIKit

public class ValifyFaceScan: UINavigationController {
    
    public typealias DidFinishPickingCompletion = (_ items: UIImage?, _ cancelled: Bool) -> Void
    
    public func didFinishPicking(completion: @escaping DidFinishPickingCompletion) {
        
        _didFinishPicking = completion
    }
    
    private var _didFinishPicking: DidFinishPickingCompletion?
    
    public required init() {
        
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) Not Exist ")
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }
    
    deinit {
        
        print(" ValifyFaceScan Deallocated")
    }
    
    private let cameraView = CameraView()

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        cameraView.didCapturePhoto = { [weak self] image in
            
            self?._didFinishPicking?(image, false)
        }
        
        cameraView.didClose = { [weak self] in
            
            self?._didFinishPicking?(nil, true)
        }
        
        viewControllers = [cameraView]
    }
}

