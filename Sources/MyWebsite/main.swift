import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct MyWebsite: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case work
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://joshprewer.com")!
    var name = "Josh Prewer"
    var description = "Software Developer & Designer"
    var language: Language { .english }
    var imagePath: Path? { nil }
}

extension Theme where Site == MyWebsite {
    static var MyWebsiteTheme: Self {
        Theme(htmlFactory: MyWebsiteHTMLFactory())
    }
}

try MyWebsite().publish(using: [
    .copyResources(),
    .generateHTML(withTheme: .MyWebsiteTheme),
    .deploy(using: .gitHub("joshprewer/joshprewer.github.io", useSSH: true))
])

private struct MyWebsiteHTMLFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
        return HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body(
                .header(),
                .div(.class("intro"),
                     .div(.class("intro-text"),
                          .h1("Hi there 👋"),
                          .h1("I'm Josh Prewer"),
                          .div(.id("rectangle")),
                          .h2(.text(context.site.description)),
                          .p("Working at Focusrite as an iOS Developer designing and building the best iOS music apps. ",
                             .linkedText(text: "Launchpad", link: "https://ampifymusic.com/launchpad/"),
                             ", ",
                             .linkedText(text: "Groovebox", link: "https://ampifymusic.com/groovebox/"),
                             " & ",
                             .linkedText(text: "Blocs Wave", link: "https://ampifymusic.com/blocswave/")),
                          .p("An engineer and musician, looking to collaborate on solving problems with tech, efficiently and pragmatically."),
                          .createSocials()
                    ),
                     .div(.class("intro-pic"),
                          .img(.class("intro-pic-blur"), .src(Path("profile.jpg"))),
                          .img(.class("intro-pic-main"), .src(Path("profile.jpg")))
                    )
                )
            )
        )
    }

    func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
        return HTML()
    }

    func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML {
        return HTML()
    }

    func makePageHTML(for page: Page, context: PublishingContext<Site>) throws -> HTML {
        return HTML()
    }

    func makeTagListHTML(for page: TagListPage, context: PublishingContext<Site>) throws -> HTML? {
        return nil
    }

    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Site>) throws -> HTML? {
        return nil
    }
}

private extension Node where Context == HTML.BodyContext {
    static func wrapper(_ nodes: Node...) -> Node {
        .div(.class("wrapper"), .group(nodes))
    }

    static func itemList<T: Website>(for items: [Item<T>], on site: T) -> Node {
        return .ul(
            .class("item-list"),
            .forEach(items) { item in
                .li(.article(
                    .h1(.a(
                        .href(item.path),
                        .text(item.title)
                        )),
                    .tagList(for: item, on: site),
                    .p(.text(item.description))
                    ))
            }
        )
    }

    static func tagList<T: Website>(for item: Item<T>, on site: T) -> Node {
        return .ul(.class("tag-list"), .forEach(item.tags) { tag in
            .li(.a(
                .href(site.path(for: tag)),
                .text(tag.string)
                ))
            })
    }

    static func createSocials() -> Node {
        return .div(.class("social-links"),
                    .a(.href("https://www.linkedin.com/in/josh-prewer-80ba8b130"), .img(.class("social-btn"), .src("linkedIn.png"))),
                    .a(.href("https://github.com/joshprewer"), .img(.class("social-btn"), .src("github.png"))),
                    .a(.href("mailto:joshua.prewer@gmail.com"), .img(.class("social-btn"), .src("gmail.png")))
        )
    }

    static func linkedText(text: String, link: String) -> Node {
        return .a(.href(link), .text(text))
    }

    static func footer<T: Website>(for site: T) -> Node {
        return .footer(
            .p(
                .text("Generated using ")
            )
        )
    }
}
