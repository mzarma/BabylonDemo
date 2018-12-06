//
//  DataLoaderTestHelpers.swift
//  BabylonHealthDemoTests
//
//  Created by Michail Zarmakoupis on 06/12/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation
@testable import BabylonHealthDemo

let validPostsData = "[{\"userId\": 1,\"id\": 1,\"title\": \"post title 1\",\"body\": \"post body 1\"},{\"userId\": 1,\"id\": 2,\"title\": \"post title 2\",\"body\": \"post body 2\"}]".data(using: .utf8)!
let validUsersData = "[{\"id\": 1,\"name\": \"user name 1\",\"username\": \"user username 1\",\"email\": \"\",\"address\": {\"street\": \"\",\"suite\": \"\",\"city\": \"\",\"zipcode\": \"\",\"geo\": {\"lat\": \"\",\"lng\": \"\"}},\"phone\": \"\",\"website\": \"\",\"company\": {\"name\": \"\",\"catchPhrase\": \"\",\"bs\": \"\"}},{\"id\": 2,\"name\": \"user name 2\",\"username\": \"user username 2\",\"email\": \"\",\"address\": {\"street\": \"\",\"suite\": \"\",\"city\": \"\",\"zipcode\": \"\",\"geo\": {\"lat\": \"\",\"lng\": \"\"}},\"phone\": \"\",\"website\": \"\",\"company\": {\"name\": \"\",\"catchPhrase\": \"\",\"bs\": \"\"}}]".data(using: .utf8)!
let validCommentsData = "[{\"postId\": 1,\"id\": 1,\"name\": \"comment name 1\",\"email\": \"\",\"body\": \"comment body 1\"},{\"postId\": 1,\"id\": 2,\"name\": \"comment name 2\",\"email\": \"\",\"body\": \"comment body 2\"}]".data(using: .utf8)!

let testUsers = [
    User(id: 1, name: "user name 1", username: "user username 1",
         posts: [
            Post(id: 1, title: "post title 1", body: "post body 1", comments: [
                Comment(id: 1, name: "comment name 1", body: "comment body 1"),
                Comment(id: 2, name: "comment name 2", body: "comment body 2")]),
            Post(id: 2, title: "post title 2", body: "post body 2", comments: [])]),
    User(id: 2, name: "user name 2", username: "user username 2", posts: [])]

let testLocalUsers = [
    LocalUser(id: 1, name: "user name 1",
              username: "user username 1",posts: [
                LocalPost(id: 1, title: "post title 1",
                          body: "post body 1", comments: [
                            LocalComment(id: 1, name: "comment name 1",
                                         body: "comment body 1"),
                            LocalComment(id: 2, name: "comment name 2",
                                         body: "comment body 2")]),
                LocalPost(id: 2, title: "post title 2",
                          body: "post body 2", comments: [])]),
    LocalUser(id: 2, name: "user name 2",
              username: "user username 2", posts: [])
]
