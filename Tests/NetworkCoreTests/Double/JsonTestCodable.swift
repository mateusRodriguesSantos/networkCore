import Foundation

class dummyJson {
    var stringData = """
{
    "name" : "Joao",
    "id": 0
}
""".data(using: .utf8)
    func dummy() -> Data {
        return stringData ?? Data()
    }
}
