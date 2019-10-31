//
//  StringToBase64.swift
//  GitManager
//
//  Created by Антон Текутов on 31.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import Alamofire

extension String {

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
