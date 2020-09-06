import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct MyWebsite: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case projects
        case blog
        case about
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

try MyWebsite().publish(withTheme: .MyWebsiteTheme)

private struct MyWebsiteHTMLFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
        return HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body(
                .header(),
                .div(.class("intro"),
                     .div(.class("intro-text"),
                          .h1(.text("Hi there 👋 \n I'm " + index.title)),
                          .div(.id("rectangle")),
                          .h2(.text(context.site.description)),
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

    static func header<T: Website>(
        for context: PublishingContext<T>,
        selectedSection: T.SectionID?
    ) -> Node {
        let sectionIDs = T.SectionID.allCases

        return .header(
            .wrapper(
                .if(sectionIDs.count > 1,
                    .nav(
                        .ul(.forEach(sectionIDs) { section in
                            .li(.a(
                                .class(section == selectedSection ? "selected" : ""),
                                .href(context.sections[section].path),
                                .text(context.sections[section].title)
                                ))
                            })
                    )
                )
            )
        )
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
                    .a(.href(Path("https://www.linkedin.com/in/josh-prewer-80ba8b130")), .img(.class("social-btn"), .src(Path("linkedIn.png")))),
                    .a(.href(Path("https://github.com/joshprewer")), .img(.class("social-btn"), .src(Path("github.png")))),
                    .a(.href(Path("joshua.prewer@gmail.com")), .img(.class("social-btn"), .src(Path("gmail.png"))))
        )
    }

    static func footer<T: Website>(for site: T) -> Node {
        return .footer(
            .p(
                .text("Generated using ")
            )
        )
    }
}
