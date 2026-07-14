//
//  FeedArticleImageView.swift
//  Ephmrl
//
//  Created by Аскольд on 14.07.2026.
//

import SwiftUI
import Nuke
import NukeUI

struct FeedArticleImageView: View {
    let url: String
    let targetWidth: CGFloat
    
    var body: some View {
        let targetHeight = targetWidth * (9.0 / 16.0)
        
        let imageURL = URL(string: url)
        
        let imageRequest: ImageRequest? = if let resultURL = imageURL {
            ImageRequest(
                url: resultURL,
                processors: [
                    ImageProcessors.Resize(
                        size: CGSize(width: targetWidth, height: targetHeight),
                        unit: .points,
                        contentMode: .aspectFill,
                        crop: true
                    )
                ]
            )
        } else {
            nil
        }
        
        LazyImage(request: imageRequest) { state in
            if let image = state.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Theme.colors.foregroundTransparent
            }
        }
        .aspectRatio(16/9, contentMode: .fit)
        .clipped()
    }
}
