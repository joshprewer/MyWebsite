import Foundation
import Publish
import Plot

extension Node where Context == HTML.BodyContext {
    static func workSection() -> Node {
        return .div(.class("work"),
                    .h1("Work"),
                    .div(.class("work-cards"),
                         .workCard(
                            link: "https://apps.apple.com/gb/app/depop-buy-sell-clothing/id518684914",
                            colour: "depop",
                            imagePath: "depop-ss.png",
                            iconImagePath: "depop-icon.png",
                            text: "Depop"),
                         .workCard(
                            link: "https://apps.apple.com/gb/app/curve-rule-your-money/id1049397112",
                            colour: "curve",
                            imagePath: "curve-ss.png",
                            iconImagePath: "curve-icon.png",
                            text: "Curve"),
                         .workCard(
                            link: "https://ampifymusic.com/launchpad/",
                            colour: "lp",
                            imagePath: "lp-ss.png",
                            iconImagePath: "lp-icon.png",
                            text: "Launchpad"),
                         .workCard(
                            link: "https://ampifymusic.com/groovebox/",
                            colour: "gb",
                            imagePath: "gb-ss.png",
                            iconImagePath: "gb-icon.png",
                            text: "Groovebox"),
                         .workCard(
                            link: "https://ampifymusic.com/blocswave/",
                            colour: "bw",
                            imagePath: "bw-ss.png",
                            iconImagePath: "bw-icon.png",
                            text: "Blocs Wave")
                    )
        )
    }

    static func workCard(link: String,
                         colour: String,
                         imagePath: String,
                         iconImagePath: String,
                         text:String) -> Node {
        return .a(.href(link),
                  .div(.class("card"),
                       .img(.class("card-image"), .src(imagePath)),
                       .div(.class("card-text  \(colour)"),
                            .h2(.text(text)),
                            .img(.class("card-icon"), .src(iconImagePath))
                       )
                  )
            )
    }
}
