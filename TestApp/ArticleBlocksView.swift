//
//  ArticleBlocksView.swift
//  TestApp
//
//  Created by Naomi Morse on 9/21/26.
//
import SwiftUI
import YouTubePlayerKit

struct ArticleBlocksView: View {
    // Constant for margin size, which is arbitrary and taken from doc examples
    // Looks good to me, but may not be perfect overall
    static let margin = CGFloat(20)

    // Scales based on user-selected text size; can't be static (fails in runtime)
    // body used as the baseline arbitrarily here, but that sounds fine...?
    @ScaledMetric(relativeTo: .body) var scaledMargin = margin
    
    // The array of blocks to be rendered, assumedly from Article.blocks
    // Not an Article reference directly as I don't see a need to do so
    let blocks: [ArticleBlock]
    
    var body: some View {
        ScrollView {
            // Leading alignment feels appropriate but may not be for every case
            // We're already handling vertical spacing directly
            LazyVStack(alignment: .leading, spacing: .zero) {
                ForEach(blocks) { block in
                    if case .list = block {
                        // This is long enough to justify its own helper
                        listBuilder(list: block)
                    }
                    else {
                        // Not a list, so it's just one element; we can just place it!
                        blockBuilder(block: block)
                    }
                    // Weirdly, Spacer() seems to be discouraged in a lot of
                    // posts I've seen, but it seems like the best option
                    // here (where spacing cannot be constant due to lists)...
                    Spacer(minLength: scaledMargin) // Will be this length, not infinite
                }
            }
        }
        // Won't affect the scrollbar, just the scrollable contents
        .contentMargins(.horizontal, Self.margin, for: .scrollContent)
    }
    
    // Externalized code block to handle entire list contents at once
    // Can't be in blockBuilder below, due to opaque return type loops (compile error)
    @ViewBuilder
    func listBuilder(list: ArticleBlock) -> some View {
        // Docs say to use sections to group items in a LazyVStack,
        // though admittedly I'm not 100% sure this is what they meant...
        Section {
            ForEach(list.flattened) { element in
                // Ensure we don't have any padding for non-indicated lists
                let bulletSize = .none ~= element.listType ? .zero : scaledMargin
                // Indent one text-scaled magin-width per level
                // Bullet itself precedes the block, thus level - 1,
                let elementPadding = bulletSize * CGFloat(element.listLevel - 1)
                
                // HStack to keep the bullet and element horizontally adjacent
                // Alignment keeps bullet in line with top of text rather than centered
                // We're already handling horizontal spacing directly
                HStack(alignment: .firstTextBaseline, spacing: .zero) {
                    // The bullet's textual representation (incl. nothing)
                    Text(Self.getBulletText(element))
                        // Aligns to start of numbers
                        .frame(width: bulletSize, alignment: .leading)
                        // Monospaced bullets (literal) look nicer
                        .monospaced(.bullet ~= element.listType)
                        // Padding will persist to the actual element
                        .padding(.leading, elementPadding)
                    // The actual block we're here for!
                    blockBuilder(block: element.block)
                }
            }
        }
    }
    
    // External switch statement that returns a View for each block type
    @ViewBuilder
    func blockBuilder(block: ArticleBlock) -> some View {
        switch block {
        case let .text(data):
            Text(Self.parseMarkdown(data))
        case let .heading(data):
            Text(Self.parseMarkdown(data))
                // This could be a modifier on Text above, frankly,
                // but it feels notable as its own item logically
                .font(.headline)
        case let .image(name):
            Image(name)
                // Image has to be resizable, even if with no args, to
                // allow it to be made to fit the screen
                .resizable()
                // Not specifying a ratio keeps the original one, but
                // we do need to use this to specify fitting to ratio
                // rather than filling and disregarding it
                .aspectRatio(contentMode: .fit)
        case let .video(type, name):
            switch type {
            case .youtube:
                YouTubePlayerView(YouTubePlayer(source: .video(id: name)))
                    // Forcing 16:9 isn't great, but I don't see a way to
                    // fetch the video's aspect ratio to be responsive...
                    .aspectRatio(16/9, contentMode: .fit)
            default:
                // Videos as a resource is likely simple enough to implement,
                // but this demo doesn't use it, so it isn't right now
                Text("TODO implement").bold()
            }
        case .horizontalRule:
            Divider()
        case .list:
            // Could use default: here, but then if a case is added
            // it could slip through without being implemented here
            EmptyView() // Shouldn't happen
        }
    }
    
    // External switch statement that returns a String for each bullet type
    private static func getBulletText(_ inElement: ListElement) -> String {
        switch inElement.listType {
        case .bullet:
            "•"
        case .decimal:
            inElement.elementNumber.description + "."
        case .none:
            ""
        }
    }
    
    // Ensures a passed String is parsed for any Markdown
    // Feels this may be slightly redundant, but I did have to re-add this to work...?
    private static func parseMarkdown(_ inString: String) -> AttributedString {
        do {
            return try AttributedString(
                markdown:inString)
        } catch {
            // Default error message from docs
            return AttributedString("Couldn't parse the string. \(error.localizedDescription)")
        }
        
    }
}
