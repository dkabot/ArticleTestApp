//
//  ArticleBlock.swift
//  TestApp
//
//  Created by Naomi Morse on 9/21/26.
//
enum ArticleBlock: Decodable, Hashable, Identifiable {
    case text(data: String)
    case heading(data: String)
    case image(name: String)
    case video(type: VideoType, name: String) //TODO "name" might not be a good fit?
    case list(type: ListType, elements: [ArticleBlock])
    case horizontalRule
    
    // Enables Identifiable; works because Hashables are able to be used as identifiers
    var id: Self {
        self
    }
    
    // Can be called directly to flatten a .list instance with no fuss
    // Works on non-lists too, but will do nothing useful
    @FlattenedListBuilder
    var flattened: [ListElement] {
        self
    }
}
