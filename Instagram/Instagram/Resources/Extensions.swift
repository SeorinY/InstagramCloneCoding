//
//  Extensions.swift
//  Instagram
//
//  Created by Mac Book Pro on 2022/07/28.
//

import Foundation
import UIKit

extension UIView{
    
    //view.frame.size.width => view.width 로 간단하게 할 수 있어짐
    public var width : CGFloat{
        return frame.size.width
    }
    
    public var height : CGFloat{
        return frame.size.height
    }

    public var top : CGFloat{
        return frame.origin.y
    }

    public var bottom : CGFloat{
        return frame.origin.y + frame.size.height
    }

    public var left : CGFloat{
        return frame.origin.x
    }

    public var right : CGFloat{
        return frame.origin.x + frame.size.width
    }
}


extension String{
    func safeDatabaseKey() -> String{
        return self.replacingOccurrences(of: "@", with: "-").replacingOccurrences(of: ".", with: "-")
    }
}
