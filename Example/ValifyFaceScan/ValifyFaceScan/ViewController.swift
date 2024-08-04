//
//  ViewController.swift
//  ValifyFaceScan
//
//  Created by Mahmoud Saad on 02/08/2024.
//

import UIKit
import ValifyFaceScanML

class ViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Valify Your Identity"
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: "textColor") ?? UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if userImage.image == nil {
            userImage.image = UIImage(named: "lunchScreen")
        }
    }
}

extension ViewController {
    
    @IBAction func takePhotoAction(_ button: UIButton) {
        
        let faceScan = ValifyFaceScan()
        faceScan.didFinishPicking { [unowned faceScan] photo, _ in
            self.userImage.image = photo
            faceScan.dismiss(animated: true, completion: nil)
         }
        present(faceScan, animated: true, completion: nil)
    }
}
