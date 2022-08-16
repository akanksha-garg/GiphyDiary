//
//  GiphyDiaryTests.swift
//  GiphyDiaryTests
//
//  Created by Akanksha Garg on 14/08/22.
//

import XCTest
@testable import GiphyDiary

class GiphyDiaryTests: XCTestCase {
    
    var responseType: APIResponseType?
    var searchGifsViewModel: SearchGifsViewModel!

    override func setUpWithError() throws {
        searchGifsViewModel = SearchGifsViewModel()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        searchGifsViewModel = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLoadAndParseJsonFileSuccess() {
        responseType = .success
        searchGifsViewModel.apiService = self
        searchGifsViewModel.searching = false
        let expectation = expectation(description: "GetTrendingGifsSuccess")
        searchGifsViewModel.fetchTrendingGiphy {(success, error) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1) { [self] (error) in
            XCTAssertEqual(self.searchGifsViewModel.getCurrentGiphyCount(), 50)
        }
    }
    
    func testLoadAndParseManufacturerDataNoNetworkError() {
        responseType = .noNetwork
        searchGifsViewModel.apiService = self
        searchGifsViewModel.searching = false
        let expectation = expectation(description: "GetTrendingGifsNoNetworkError")
        searchGifsViewModel.fetchTrendingGiphy { (success, error) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNil(self.searchGifsViewModel.giphys)
            XCTAssertTrue(self.searchGifsViewModel.serviceError == .noNetwork)
        }
    }
    
    func testLoadAndParseManufacturerDataServiceError() {
        responseType = .failure
        searchGifsViewModel.apiService = self
        searchGifsViewModel.searching = false
        let expectation = expectation(description: "GetTrendingGifsFailure")
        searchGifsViewModel.fetchTrendingGiphy { (success, error) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNil(self.searchGifsViewModel.giphys)
            XCTAssertTrue(self.searchGifsViewModel.serviceError == .serviceError)
        }
    }
    
    func testLoadAndParseManufacturerDataNoDataError() {
        responseType = .noDataError
        searchGifsViewModel.apiService = self
        searchGifsViewModel.searching = false
        let expectation = expectation(description: "GetTrendingGifsFailure")
        searchGifsViewModel.fetchTrendingGiphy { (success, error) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNil(self.searchGifsViewModel.giphys)
            XCTAssertTrue(self.searchGifsViewModel.serviceError == .noDataError)
        }
    }
    
    func testSaveImageInFavoriteFolder() {
        let expectation = expectation(description: "SaveImageInFavoriteFolder")
        let image = UIImage(systemName: Constants.Image.unFav)
        var resultImage: UIImage?
        searchGifsViewModel.saveImageInFavoriteFolder(image: image!, imageName: "TestImage"){ (success, error) in
            if success {
                resultImage = self.searchGifsViewModel.imageExistInFavoriteFolder(imageName: "TestImage").0
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(resultImage)
        }
    }
    
    func testRemoveImageFromFavoriteFolder() {
        let success = searchGifsViewModel.removeImageFromFavoriteFolder(imageName: "TestImage")
        if success {
            let resultImage = self.searchGifsViewModel.imageExistInFavoriteFolder(imageName: "TestImage").0
            XCTAssertNil(resultImage)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension GiphyDiaryTests: NetworkingProtocol {
    
    func callGetAPI(apiURL: String, requestData: [String: String]?, onCompletion:  @escaping (Result<Data, Error>) -> Void) {
        switch responseType {
        case .success:
            let data = readjson(fileName: "Giphy")
            onCompletion(.success(data!))
        case .failure:
            onCompletion(.failure(JsonError.serviceError))
        case .invalidUrl:
            onCompletion(.failure(JsonError.notFound))
        case .noDataError:
            onCompletion(.failure(JsonError.noDataError))
        case .noNetwork:
            onCompletion(.failure(JsonError.noNetwork))
        case .none:
            break
        }
    }
}
