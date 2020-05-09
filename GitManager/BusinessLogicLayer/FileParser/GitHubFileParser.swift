//
//  FileParser.swift
//  GitManager
//
//  Created by Антон Текутов on 02.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

class GitHubFileParser: FileParserProtocol {
    
    func parsePage(htmlSource: String) -> String? {
        return	parsePageAsCodeFile(htmlSource: htmlSource) ?? 
            	parsePageAsReadMe(htmlSource: htmlSource) ?? 
            	parsePageAsImage(htmlSource: htmlSource)
    }
    
    func parsePageAsReadMe(htmlSource: String) -> String? {
        var html = htmlSource
        let body = "<body"
        let article = "<article "
        let articleEnd = "</article>"
        if  var indexCutBegin = html.index(of: body),
            var indexCutEnd = html.index(of: article),
            html.endIndex(of: articleEnd) != nil{
            while html[indexCutBegin] != ">" {
                indexCutBegin = html.index(indexCutBegin, offsetBy : 1)
            }
            indexCutBegin = html.index(indexCutBegin, offsetBy : 1)
            indexCutEnd = html.index(indexCutEnd, offsetBy : -1)
            html.removeSubrange(indexCutBegin ... indexCutEnd)
            if var indexArticleEnd = html.endIndex(of: articleEnd) {
                indexArticleEnd = html.index(indexArticleEnd, offsetBy : 1)
                let htmlEnd =  html.index(html.endIndex, offsetBy : -1)
                html.removeSubrange(indexArticleEnd ... htmlEnd)
            }
            html += "</body> </html>"
            return html
        }
        return nil
    }
    
    func parsePageAsCodeFile(htmlSource: String) -> String? {
        var html = htmlSource
        let body = "<body"
        let table = "<table class=\"highlight tab-size js-file-line-container\" "
        let tableEnd = "</table>"
        if  var indexCutBegin = html.index(of: body),
            var indexCutEnd = html.index(of: table),
            html.endIndex(of: tableEnd) != nil{
            while html[indexCutBegin] != ">" {
                indexCutBegin = html.index(indexCutBegin, offsetBy : 1)
            }
            indexCutBegin = html.index(indexCutBegin, offsetBy : 1)
            indexCutEnd = html.index(indexCutEnd, offsetBy : -1)
            html.removeSubrange(indexCutBegin ... indexCutEnd)
            if var indexTabeEnd = html.endIndex(of: tableEnd) {
                indexTabeEnd = html.index(indexTabeEnd, offsetBy : 1)
                let htmlEnd =  html.index(html.endIndex, offsetBy : -1)
                html.removeSubrange(indexTabeEnd ... htmlEnd)
            }
            html += "</body> </html>"
            return html
        }
        return nil
    }
    
    func parsePageAsImage(htmlSource: String) -> String? {
        var html = htmlSource
        let body = "<body"
        let table = "<span class=\"border-wrap\">"
        let tableEnd = "</span>"
        if  var indexCutBegin = html.index(of: body),
            var indexCutEnd = html.index(of: table),
            html.endIndex(of: tableEnd) != nil{
            while html[indexCutBegin] != ">" {
                indexCutBegin = html.index(indexCutBegin, offsetBy : 1)
            }
            indexCutBegin = html.index(indexCutBegin, offsetBy : 1)
            indexCutEnd = html.index(indexCutEnd, offsetBy : -1)
            html.removeSubrange(indexCutBegin ... indexCutEnd)
            if var indexTabeEnd = html.endIndex(of: tableEnd) {
                indexTabeEnd = html.index(indexTabeEnd, offsetBy : 1)
                let htmlEnd =  html.index(html.endIndex, offsetBy : -1)
                html.removeSubrange(indexTabeEnd ... htmlEnd)
            }
            
            if let imageSrcIndex = html.index(of: "img src=\"") {
                let gitUrl = "https://github.com"
                html.insert(contentsOf: gitUrl, at: html.index(imageSrcIndex, offsetBy : 9))
            }
            
            html += "</body> </html>"
            return html
        }
        return nil
    }
}
