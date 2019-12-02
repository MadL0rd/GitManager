//
//  FileParserProtocol.swift
//  GitManager
//
//  Created by Антон Текутов on 02.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

protocol FileParserProtocol: class {
    func parsePageAsReadMe(htmlSource : String) -> String?
    func parsePageAsCodeFile(htmlSource : String) -> String?
}
