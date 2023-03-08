//
//  NetworkTests.swift
//  weatherappTests
//
//  Created by Sanket Pimple on 3/8/23.
//
import XCTest
@testable import weatherapp

final class NetworkTests: XCTestCase {

    var sut: NetworkManager!
    var url: URL {
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")!
        components.queryItems = [
            URLQueryItem(name: "lat", value: "37.785834"),
             URLQueryItem(name: "lon", value: "-122.406417"),
            URLQueryItem(name: "units", value: Unit.imperial.rawValue),
            URLQueryItem(name: "appid", value: "00000000000")
        ]
        return components.url!
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = NetworkManager(apiHandler: APIHandlerMock(isSuccess: true, isCorrectResponse: true))
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testSuccessfulCall() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        sut.fetchRequest(type: WeatherModel.self, url: url) { result in
            switch result {
            case .success(let weather):
                XCTAssertTrue(type(of: weather) == WeatherModel.self)
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func testFailedCall() throws {
        sut = NetworkManager(apiHandler: APIHandlerMock(isSuccess: false, isCorrectResponse: true))
        sut.fetchRequest(type: WeatherModel.self, url: url) { result in
            switch result {
            case .success(_):
                XCTFail("API call should not succeed")
            case .failure(_):
                XCTAssert(true)
            }
        }
    }

    func testBadResponse() throws {
        sut = NetworkManager(apiHandler: APIHandlerMock(isSuccess: true, isCorrectResponse: false))
        sut.fetchRequest(type: WeatherModel.self, url: url) { result in
            switch result {
            case .success(_):
                XCTFail("API call should not succeed")
            case .failure(let error):
                XCTAssertTrue(error == .DecodingError)
            }
        }
    }
    
    func testCorrectResponse() throws {
        sut = NetworkManager(apiHandler: APIHandlerMock(isSuccess: true, isCorrectResponse: true))
        sut.fetchRequest(type: WeatherModel.self, url: url) { result in
            switch result {
            case .success(let weather):
                XCTAssertTrue(type(of: weather) == WeatherModel.self)
            case .failure(_):
                XCTFail()
            }
        }
    }
}
