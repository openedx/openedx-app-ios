//
//  RouterImpl.swift
//  OpenEdX
//
//  Created by Vladimir Chekyrta on 13.09.2022.
//

import UIKit
import SwiftUI
import Core
import Authorization
import Course
import Discussion
import Discovery
import Dashboard
import Profile

public protocol Router: AuthorizationRouter,
                 DiscoveryRouter,
                 ProfileRouter,
                 DashboardRouter,
                 CourseRouter,
                 DiscussionRouter {}
