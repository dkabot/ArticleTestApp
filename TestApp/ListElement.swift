//
//  ListElement.swift
//  TestApp
//
//  Created by Naomi Morse on 9/22/26.
//
struct ListElement: Hashable, Identifiable {
    let listLevel: Int
    let listType: ListType
    let elementNumber: Int
    let block: ArticleBlock
    
    // Enables Identifiable; works because Hashables are able to be used as identifiers
    var id: Self {
        self
    }
}
