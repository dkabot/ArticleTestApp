import SwiftUI
import Playgrounds

struct ArticleView: View {
    var body: some View {
        // Locate file by name; surprisingly not from asset store?
        if let articleFileURL = Bundle.main.url(forResource: "ConsoleForChildren", withExtension: "json") {
            // Open the file into raw data
            // Not sure if mappedIfSafe is useful, frankly
            if let fileContents = try? Data(contentsOf: articleFileURL, options: .mappedIfSafe) {
                // Docs show getting this into a let,
                // rather than doing a one-liner
                let decoder = JSONDecoder()
                // Decode the Article out of its source JSON
                if let article = try? decoder.decode(Article.self, from: fileContents) {
                    // Render the Article's contents!
                    ArticleBlocksView(blocks: article.blocks)
                    // We can access the Article itself, too:
                    //Text(article.id.uuidString)
                    //Text(article.title)
                }
                else {
                    // See below below
                    Text("Failed to decode Data!")
                }
            }
            else {
                // See below
                Text("Failed to initialize Data of article!")
            }
        }
        else {
            // Can't use guard let in ViewBuilder, for some reason,
            // even though you can use if let just fine
            Text("Failed to get article!")
        }
    }
}

#Preview {
    ArticleView()
}
