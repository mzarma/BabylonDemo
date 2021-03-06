//
//  PhonePostsViewFactoryTest.swift
//  BabylonHealthDemoTests
//
//  Created by Michail Zarmakoupis on 03/12/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import BabylonHealthDemo

class PhonePostsViewFactoryTest: XCTestCase {
    private weak var weakSUT: PhonePostsViewFactory?
    
    override func tearDown() {
        XCTAssertNil(weakSUT)
        
        super.tearDown()
    }
    
    func test_postsView_startsWithNoPostsText() {
        let postsView = makeSUT().makePostsView { _ in } as! CustomTableViewController
        
        postsView.loadViewIfNeeded()
        
        XCTAssertEqual(postsView.numberOfRows(), 1)
        XCTAssertEqual(postsView.resizableText(for: 0), "No Posts")
    }
    
    func test_postsView_showsNoPostsText_whenLoaderCompletesWithError() {
        let postsView = makeSUT().makePostsView { _ in } as! CustomTableViewController
        postsView.loadViewIfNeeded()
        
        loader.complete!(.error(.composed))
        
        XCTAssertEqual(postsView.numberOfRows(), 1)
        XCTAssertEqual(postsView.resizableText(for: 0), "No Posts")
    }
    
    func test_postsView_showsNoPostsText_whenLoaderCompletesWithZeroUsers() {
        let postsView = makeSUT().makePostsView { _ in } as! CustomTableViewController
        postsView.loadViewIfNeeded()
        
        loader.complete!(.success([]))
        
        XCTAssertEqual(postsView.numberOfRows(), 1)
        XCTAssertEqual(postsView.resizableText(for: 0), "No Posts")
    }
    
    func test_postsView_showsCorrectCells_whenLoaderCompletesUsers() {
        let postsView = makeSUT().makePostsView { _ in } as! CustomTableViewController
        postsView.loadViewIfNeeded()
        
        loader.complete!(.success(testUsers()))
        
        XCTAssertEqual(postsView.numberOfRows(), 4)
        XCTAssertEqual(postsView.resizableText(for: 0), "title11")
        XCTAssertEqual(postsView.resizableText(for: 1), "title12")
        XCTAssertEqual(postsView.resizableText(for: 2), "title21")
        XCTAssertEqual(postsView.resizableText(for: 3), "title22")
        
        XCTAssertEqual(postsView.title, "Posts")
    }
    
    func test_doesNotTriggerSelection_whenRowSelectionAndNoUsers() {
        var selectionCount = 0
        var selectedPost: Post?
        
        let postsView = makeSUT().makePostsView { post in
            selectionCount += 1
            selectedPost = post
        } as! CustomTableViewController
        postsView.loadViewIfNeeded()
        loader.complete!(.success([]))

        postsView.selectRow(0)
        
        XCTAssertEqual(selectionCount, 0)
        XCTAssertNil(selectedPost)
    }
    
    func test_triggersSelection_whenRowSelection() {
        var selectionCount = 0
        var selectedPost: Post?
        
        let postsView = makeSUT().makePostsView { post in
            selectionCount += 1
            selectedPost = post
        } as! CustomTableViewController
        postsView.loadViewIfNeeded()
        loader.complete!(.success(testUsers()))

        postsView.selectRow(2)
        
        let expectedPost = Post(id: 21, title: "title21", body: "body21", comments: [emptyComment(), emptyComment(), emptyComment()])
        
        XCTAssertEqual(selectionCount, 1)
        XCTAssertEqual(selectedPost, expectedPost)
    }
    
    func test_postDetailView() {
        let post = Post(id: 21, title: "title21", body: "body21", comments: [emptyComment(), emptyComment(), emptyComment()])
        let postDetailView = makeSUT().makePostDetailView(post: post) as! CustomTableViewController
        postDetailView.loadViewIfNeeded()
        
        XCTAssertEqual(postDetailView.numberOfRows(), 6)
        XCTAssertEqual(postDetailView.titleText(for: 0), "Author")
        XCTAssertEqual(postDetailView.resizableText(for: 1), "")
        XCTAssertEqual(postDetailView.titleText(for: 2), "Description")
        XCTAssertEqual(postDetailView.resizableText(for: 3), "body21")
        XCTAssertEqual(postDetailView.titleText(for: 4), "Comments")
        XCTAssertEqual(postDetailView.resizableText(for: 5), "3")
    }
    
    func test_postDetailViewWithUser() {
        var post: Post?
        let sut = makeSUT()
        
        let postsView = sut.makePostsView { post = $0 } as! CustomTableViewController
        postsView.loadViewIfNeeded()
        loader.complete!(.success(testUsers()))
        
        postsView.selectRow(2)
        let postDetailView = sut.makePostDetailView(post: post!) as! CustomTableViewController
        postDetailView.loadViewIfNeeded()
        
        XCTAssertEqual(postDetailView.numberOfRows(), 6)
        XCTAssertEqual(postDetailView.titleText(for: 0), "Author")
        XCTAssertEqual(postDetailView.resizableText(for: 1), "user2")
        XCTAssertEqual(postDetailView.titleText(for: 2), "Description")
        XCTAssertEqual(postDetailView.resizableText(for: 3), "body21")
        XCTAssertEqual(postDetailView.titleText(for: 4), "Comments")
        XCTAssertEqual(postDetailView.resizableText(for: 5), "3")

        XCTAssertEqual(postDetailView.title, "title21")
    }

    // MARK: - Helpers
    
    private let loader = DataLoaderStub()
    
    private func makeSUT() -> PhonePostsViewFactory {
        let sut = PhonePostsViewFactory(loader: loader)
        weakSUT = sut
        return sut
    }
    
    private func testUsers() -> [User] {
        let post11 = Post(id: 11, title: "title11", body: "body11", comments: [emptyComment(), emptyComment()])
        let post12 = Post(id: 12, title: "title12", body: "body12", comments: [emptyComment()])
        let post21 = Post(id: 21, title: "title21", body: "body21", comments: [emptyComment(), emptyComment(), emptyComment()])
        let post22 = Post(id: 22, title: "title22", body: "body22", comments: [emptyComment(), emptyComment()])
        
        let user1 = User(id: 1, name: "user1", username: "username1", posts: [post11, post12])
        let user2 = User(id: 2, name: "user2", username: "username2", posts: [post21, post22])

        return [user1, user2]
    }
    
    private func emptyComment() -> Comment {
        return Comment(id: 0, name: "", body: "")
    }

    private class DataLoaderStub: DataLoader {
        var complete: ((DataLoaderResult)-> Void)?
        
        func loadData(completion: @escaping (DataLoaderResult) -> Void) {
            complete = completion
        }
    }
}

extension CustomTableViewController {
    func numberOfRows() -> Int {
        return tableView.dataSource!.tableView(tableView, numberOfRowsInSection: 0)
    }
    
    func resizableCell(for row: Int) -> TableViewResizableCell {
        return tableView.dataSource!.tableView(tableView, cellForRowAt: indexPath(for: row)) as! TableViewResizableCell
    }
    
    func titleCell(for row: Int) -> TableViewTitleCell {
        return tableView.dataSource!.tableView(tableView, cellForRowAt: indexPath(for: row)) as! TableViewTitleCell
    }
    
    func selectRow(_ row: Int) {
        tableView.delegate!.tableView!(tableView, didSelectRowAt: indexPath(for: row))
    }
    
    func indexPath(for row: Int) -> IndexPath {
        return IndexPath(row: row, section: 0)
    }
    
    func resizableText(for row: Int) -> String {
        return resizableCell(for: row).labelText
    }
    
    func titleText(for row: Int) -> String {
        return titleCell(for: row).labelText
    }
}
