//
//  Models.swift
//  Instagram
//
//  Created by Mac Book Pro on 2022/08/11.
//

import Foundation

enum Gender{
    case male, female, other
}

struct User{
    let username : String
    let bio : String
    let name : (first: String, last : String)
    let profilePhoto : URL
    let birthDate : Date
    let gender : Gender
    let counts : UserCount
    let joinDate : Date
}

struct UserCount {
    let followers : Int
    let following : Int
    let posts : Int
}

public enum UserPostType{
    case photo, video
}

/// Represnet UserPost
public struct UserPost{
    let identifier : String
    let postType : UserPostType
    let thumbnailImage: URL
    let postURL : URL
    let caption : String?
    let likeCount: [PostLikes]
    let comments : [PostComment]
    let createDate : Date
    let taggedUsers : [String]
}
struct PostLikes{
    let username : String
    let postIdentifier : String
}

struct CommentLikes{
    let username : String
    let commentIdentifier : String
}


struct PostComment{
    let identifier : String
    let username : String
    let text : String
    let createDate : Date
    let likes : [CommentLikes]
}
