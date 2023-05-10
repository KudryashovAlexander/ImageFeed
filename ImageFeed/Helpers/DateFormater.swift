import Foundation
private let dateTimeDefaultFormatter: DateFormatter = {
    
    
}()

extension Date {
    var dateTimeString: String { dateTimeDefaultFormatter.string(from: self) }
}
