//
//  AvatarView.swift
//  Ephmrl
//
//  Created by Аскольд on 13.07.2026.
//

import SwiftUI

enum AvatarSize {
    case xs, sm, md, lg, xl, xxl, xxxl, xxxxl
    
    var dimension: CGFloat {
        switch self {
        case .xs: return 20
        case .sm: return 40
        case .md: return 44
        case .lg: return 58
        case .xl: return 76
        case .xxl: return 100
        case .xxxl: return 128
        case .xxxxl: return 160
        }
    }
}

struct AvatarView: View {
    var size: AvatarSize = .md
    var square: Bool = false
    var image: String?
    var id: String = ""
    var name: String = ""
    
    private var dimension: CGFloat {
        size.dimension
    }
    
    var body: some View {
        Group {
            if let imageUrlString = image, let url = URL(string: imageUrlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let loadedImage):
                        loadedImage
                            .resizable()
                            .scaledToFill()
                    case .failure, .empty:
                        defaultAvatarView
                    @unknown default:
                        defaultAvatarView
                    }
                }
            } else {
                defaultAvatarView
            }
        }
        .frame(width: dimension, height: dimension)
        .cornerRadius(square ? 0 : dimension / 2)
    }
    
    private var defaultAvatarView: some View {
        return Circle()
            .fill(
                Theme.colors.primary
            )
            .overlay(
                IconView(name: "star_icon", size: dimension * 0.681, color: Theme.colors.white)
            )
    }
}
