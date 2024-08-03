//
//  PreviewPhotoView.swift
//  ValifyPhotoML
//
//  Created by Esraa on 20/01/2024.
//

import UIKit

class PreviewPhotoView: UIViewController {
    
     var didConfirmPhoto: ((UIImage?) -> Void)?
     var image: UIImage?
    
     @IBOutlet weak var pickedImage: UIImageView!
    
 
    public class func initWith(_ image: UIImage?) -> PreviewPhotoView {
        
        let vc = PreviewPhotoView(nibName: "PreviewPhotoView", bundle: Bundle.local)
        vc.image = image
        return vc
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        pickedImage.image = image
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        navigationItem.leftBarButtonItem = UIBarButtonItem()
    }
}

// MARK: - Actions -

extension PreviewPhotoView {
    
    @IBAction func retakePhoto(_ button: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func usePhoto(_ button: UIButton) {
        
        didConfirmPhoto?(image)
    }
}
