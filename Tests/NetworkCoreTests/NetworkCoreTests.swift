import XCTest
@testable import NetworkCore

final class NetworkCoreTests: XCTestCase {
    
    var sut: NetworkTasks<TestCodable>!
    var urlSessionStub: URLSessionStub!
    
    override func setUp() {
        super.setUp()
        urlSessionStub = URLSessionStub()
        sut = NetworkTasks(client: urlSessionStub)
    }
    
    override func tearDown() {
        urlSessionStub = nil
        sut = nil
        super.tearDown()
    }
    
    func testExecute() {
        urlSessionStub.dataResponse = dummyJson().dummy()
        sut.execute(connection: ConnectionFake()) { result in
            switch result {
            case .success(let test):
                XCTAssertEqual(test?.name, "Joao")
            case .failure(_):
                XCTFail("Error in request")
            }
        }
    }
    
    func testExecuteError() {
        urlSessionStub.shouldReturnError = true
        sut.execute(connection: ConnectionFake()) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.comparable,"error3")
            default:
                break
            }
        }
    }
    
    func testExecuteErrorData() {
        urlSessionStub.dataResponse = nil
        sut.execute(connection: ConnectionFake()) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.comparable,"error3")
            default:
                break
            }
        }
    }
    
    func testExecuteErrorDecode() {
        urlSessionStub.dataResponse = Data()
        sut.execute(connection: ConnectionFake()) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.comparable,"error2")
            default:
                break
            }
        }
    }
    
    func testExecuteWithParams() {
        urlSessionStub.dataResponse = dummyJson().dummy()
        sut.executeWithParams(connection: ConnectionFake()) { result in
            switch result {
            case .success(let test):
                XCTAssertEqual(test?.name, "Joao")
            case .failure(_):
                XCTFail("Error in request")
            }
        }
    }

    func testExecuteWithParamsError() {
        urlSessionStub.shouldReturnError = true
        sut.executeWithParams(connection: ConnectionFake()) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.comparable,"error3")
            default:
                break
            }
        }
    }

    func testExecuteWithParamsErrorData() {
        urlSessionStub.dataResponse = nil
        sut.executeWithParams(connection: ConnectionFake()) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.comparable,"error1")
            default:
                break
            }
        }
    }

    func testExecuteWithErrorStatus() {
        urlSessionStub.statusCode = 404
        sut.executeWithParams(connection: ConnectionFake()) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.comparable,"error4")
            default:
                break
            }
        }
    }
    
    func testExecuteWithParamsErrorDecode() {
        urlSessionStub.dataResponse = Data()
        sut.executeWithParams(connection: ConnectionFake()) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.comparable,"error2")
            default:
                break
            }
        }
    }
    
    func testGetRequest() {
        let result = sut.getRequest(connection: ConnectionFake())
        XCTAssertEqual(result?.allHTTPHeaderFields, ["Content-Type": "application/json"])
        XCTAssertEqual(result?.url, URL(string: "https://tests.testables/list"))
    }
    
    func testDecode() {
        sut.decode(dummyJson().dummy()) { result in
            XCTAssertEqual(result?.name, "Joao")
            XCTAssertEqual(result?.id, 0)
        }
        sut.decode(Data()) { result in
            XCTAssertNil(result)
        }
    }
    
}
