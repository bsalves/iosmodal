//
//  RepositoryDetails.swift
//  Modal
//
//  Created by Bruno Alves on 24/08/20.
//  Copyright © 2020 Bruno Alves. All rights reserved.
//

import Foundation

// MARK: - RepositoryDetails
struct RepositoryDetails: Codable {
    let id: Int
    let name: String
    let fullName: String
    let owner: Organization
    let repositoryDetailsDescription: String
    let stargazersCount: Int
    let watchersCount: Int
    let language: String?
    let forksCount: Int
    let forks: Int
    let watchers: Int
    let subscribersCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case owner
        case repositoryDetailsDescription = "description"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case language
        case forksCount = "forks_count"
        case forks
        case watchers
        case subscribersCount = "subscribers_count"
    }
}

// MARK: - Organization
struct Organization: Codable {
    let login: String
    let id: Int
    let nodeID: String
    let avatarURL: String
    let gravatarID: String
    let url, htmlURL, followersURL: String
    let followingURL, gistsURL, starredURL: String
    let subscriptionsURL, organizationsURL, reposURL: String
    let eventsURL: String
    let receivedEventsURL: String
    let type: String
    let siteAdmin: Bool

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
    }
}
