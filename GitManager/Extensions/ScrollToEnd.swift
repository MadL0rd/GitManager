//
//  ScrollToEnd.swift
//  GitManager
//
//  Created by Антон Текутов on 18.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

extension UIScrollView {
   func scrollToBottom(animated: Bool) {
     if self.contentSize.height < self.bounds.size.height { return }
     let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
     self.setContentOffset(bottomOffset, animated: animated)
  }
}
