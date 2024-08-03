//
//  Bundle + Extension .swift
//  ValifyFaceScanML
//
//  Created by Mahmoud Saad on 03/08/2024.
//

import Foundation

import Foundation

extension Bundle {
    
    static var local: Bundle {
        
        #if SWIFT_PACKAGE
        return .module
        #else
        return Bundle(for: BundleToken.self)
        #endif
    }
}

private final class BundleToken {}
