//
//  FeedMockData.swift
//  Ephmrl
//
//  Created by Аскольд on 14.07.2026.
//

import Foundation

struct Author: Identifiable {
    let id: String
    let username: String
    let nickname: String
}

struct Article: Identifiable {
    let id: String
    let title: String
    let image: String
    let date: Date
    let author: Author
    
    var formattedDate: String {
        Self.dateFormatter.string(from: date)
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
}

struct FeedMockData {
    static let articles: [Article] = [
        Article(
            id: "2f8c4e7a1b9d",
            title: "How to Start iOS Development in 2026",
            image: "https://i.pinimg.com/736x/8d/f4/0f/8df40f5c3e506e954e9f03ee2d917128.jpg",
            date: createDate(daysAgo: 1),
            author: Author(id: "d3f5a1e2b6c4", username: "askold_dev", nickname: "Askold")
        ),
        Article(
            id: "6a9d2f5e8b1c",
            title: "10 Hidden SwiftUI Features You Should Know",
            image: "https://i.pinimg.com/736x/42/8f/81/428f81b57a28a1a1e2d58ac84efcdb25.jpg",
            date: createDate(daysAgo: 3),
            author: Author(id: "e4f8a9b2c3d1", username: "elena_design", nickname: "Elena")
        ),
        Article(
            id: "1c5b8e9d2f4a",
            title: "Mobile Design Trends for This Season",
            image: "https://i.pinimg.com/736x/0b/72/ea/0b72eac1cefa0d79c8c5bea075363432.jpg",
            date: createDate(daysAgo: 5),
            author: Author(id: "e4f8a9b2c3d1", username: "elena_design", nickname: "Elena")
        ),
        Article(
            id: "8f3e1a7b9d2c",
            title: "10 Hidden SwiftUI Features You Should Know",
            image: "https://i.pinimg.com/736x/8d/f4/0f/8df40f5c3e506e954e9f03ee2d917128.jpg",
            date: createDate(daysAgo: 7),
            author: Author(id: "a2b6c8d1e3f5", username: "maxim_tech", nickname: "Max")
        ),
        Article(
            id: "9d5e1b8c2a4f",
            title: "A Journey into the Mountains: Photo Report",
            image: "https://i.pinimg.com/736x/42/8f/81/428f81b57a28a1a1e2d58ac84efcdb25.jpg",
            date: createDate(daysAgo: 10),
            author: Author(id: "b7c3d1e9f2a4", username: "travel_blogger", nickname: "Alex")
        ),
        Article(
            id: "5b2a4f9d1e8c",
            title: "How AI is Changing the Way We Code",
            image: "https://i.pinimg.com/736x/0b/72/ea/0b72eac1cefa0d79c8c5bea075363432.jpg",
            date: createDate(daysAgo: 12),
            author: Author(id: "d3f5a1e2b6c4", username: "askold_dev", nickname: "Askold")
        )
    ]
    
    private static func createDate(daysAgo: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
    }
}
