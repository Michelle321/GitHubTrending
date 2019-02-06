//
//  ProjectViewModel.swift
//  GitHubTrends
//
//  Created by Yunjuan Li on 2019-02-04.
//  Copyright © 2019 Michelle. All rights reserved.
//

import Foundation

struct Project {
    let name: String
    let description: String
    let starsCount: Int
    let forksCount: Int
    let readmeUrlString: String
    let user: User

    init(_ project: ProjectDTO){
        name = project.name
        description = project.description
        starsCount = project.starsCount
        forksCount = project.forksCount
        user = project.user[0]
        readmeUrlString = project.locationUrl + "/blob/master/README.md"
    }
}
