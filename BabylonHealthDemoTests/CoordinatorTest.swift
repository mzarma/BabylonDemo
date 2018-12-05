//
//  CoordinatorTest.swift
//  BabylonHealthDemoTests
//
//  Created by Michail Zarmakoupis on 03/12/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import BabylonHealthDemo

class CoordinatorTest: XCTestCase {
    private weak var weakSUT: Coordinator?
    
    override func tearDown() {
        XCTAssertNil(weakSUT)
        
        super.tearDown()
    }
    
    func test_startShowsPostsView() {
        let sut = makeSUT()
        
        XCTAssertEqual(navigation.viewControllers, [])
        
        sut.start()
        
        XCTAssertEqual(navigation.viewControllers, [postsView])
    }
    
    func test_start_presentsPostDetailView_withCorrectPost() {
        let sut = makeSUT()
        
        XCTAssertEqual(navigation.viewControllers, [])
        
        sut.start()
        
        XCTAssertEqual(navigation.viewControllers, [postsView])
        
        let comment1 = Comment(id: 10, name: "comment name 1", body: "comment body 1")
        let comment2 = Comment(id: 11, name: "comment name 2", body: "comment body 2")
        let post = Post(id: 12, title: "a title", body: "a body", comments: [comment1, comment2])
        postsViewFactory.select?(post)
        
        XCTAssertEqual(navigation.viewControllers, [postsView, postDetailView])
        XCTAssertEqual(postDetailViewFactory.selectedPost, post)
    }
    
    // MARK: - Helpers
    
    private let navigation = NonAnimatingUINavigationController()
    private let postsViewFactory = PostsViewFactorySpy()
    private let postDetailViewFactory = PostDetailViewFactorySpy()
    
    private let postsView = UIViewController()
    private let postDetailView = UIViewController()
    
    private func makeSUT() -> Coordinator {
        let sut = Coordinator(navigation: navigation, postsViewFactory: postsViewFactory, postDetailViewFactory: postDetailViewFactory)
        
        postsViewFactory.stubPostsView = postsView
        postDetailViewFactory.stubPostDetailView = postDetailView
        
        weakSUT = sut
        return sut
    }
    
    private class NonAnimatingUINavigationController: UINavigationController {
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: false)
        }
    }
    
    private class PostsViewFactorySpy: PostsViewFactory {
        var stubPostsView: UIViewController?
        var select: ((Post) -> Void)?
        
        func makePostsView(_ selected: @escaping (Post) -> Void) -> UIViewController {
            select = selected
            return stubPostsView!
        }
    }
    
    private class PostDetailViewFactorySpy: PostDetailViewFactory {
        var selectedPost: Post?
        var stubPostDetailView: UIViewController?
        
        func makePostDetailView(post: Post) -> UIViewController {
            selectedPost = post
            return stubPostDetailView!
        }
    }
}
