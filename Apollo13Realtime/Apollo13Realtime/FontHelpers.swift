//
//  FontHelpers.swift
//  Apollo13Realtime
//
//  Created by Mike Muszynski on 6/3/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import UIKit

extension UIFont {
    static var menloRegular15: UIFont {
        let descriptor = UIFontDescriptor(name: "Menlo", size: 15.0)
        return UIFont(descriptor: descriptor, size: 0)
    }
    static var menloMonoSpace15: UIFont {
        let descriptor = UIFontDescriptor(name: "Menlo", size: 15.0)
        return UIFont(descriptor: descriptor.withSymbolicTraits(.traitMonoSpace)!, size: 0)
    }
    static var menloBold15: UIFont {
        let descriptor = UIFontDescriptor(name: "Menlo", size: 15.0)
        return UIFont(descriptor: descriptor.withSymbolicTraits(.traitBold)!, size: 0)
    }
    static var menloItalic15: UIFont {
        let descriptor = UIFontDescriptor(name: "Menlo", size: 15.0)
        return UIFont(descriptor: descriptor.withSymbolicTraits(.traitItalic)!, size: 0)
    }
    
    fileprivate static var trebuchetMSFontDescriptor = UIFontDescriptor(name: "Trebuchet MS", size: 15.0)
    
    static var trebuchetMSRegular15: UIFont {
        return UIFont(descriptor: trebuchetMSFontDescriptor, size: 0)
    }
    static var trebuchetMSMonoSpace15: UIFont {
        return UIFont(descriptor: trebuchetMSFontDescriptor.withSymbolicTraits(.traitMonoSpace)!, size: 0)
    }
    static var trebuchetMSBold15: UIFont {
        return UIFont(descriptor: trebuchetMSFontDescriptor.withSymbolicTraits(.traitBold)!, size: 0)
    }
    static var trebuchetMSItalic15: UIFont {
        return UIFont(descriptor: trebuchetMSFontDescriptor.withSymbolicTraits(.traitItalic)!, size: 0)
    }
}
