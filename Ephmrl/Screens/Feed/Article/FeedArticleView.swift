//
//  FeedArticleView.swift
//  Ephmrl
//
//  Created by Аскольд on 14.07.2026.
//

import SwiftUI
import Nuke
import NukeUI

struct FeedArticleView: View {
    let article: Article
    let targetWidth: CGFloat
    
    var body: some View {
        VStack(spacing: Theme.spacing.md) {
            FeedArticleImageView(url: article.image, targetWidth: targetWidth)
                .clipShape(RoundedRectangle(cornerRadius: Theme.radius.lg))
            
            VStack(alignment: .leading, spacing: Theme.spacing.md) {
                Text(article.title)
                    .font(Theme.font.button)
                    .foregroundStyle(Theme.colors.text)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                HStack(spacing: Theme.spacing.sm) {
                    AvatarView(size: .xs, id: article.author.id, name: article.author.username)
                    
                    Text(article.author.nickname)
                        .font(Theme.font.body)
                        .foregroundStyle(Theme.colors.text)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Theme.colors.secondaryText)
                        .frame(width: 5, height: 5)
                    
                    Text(article.formattedDate)
                        .font(Theme.font.body)
                        .foregroundStyle(Theme.colors.secondaryText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, Theme.spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding(Theme.spacing.lg)
    }
}
