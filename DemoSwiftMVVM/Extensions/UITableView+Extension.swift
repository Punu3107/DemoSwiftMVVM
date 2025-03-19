import Foundation
import UIKit

extension UITableView {
    func dequeCell(withIdentifier identifier: String, style: UITableViewCell.CellStyle = .default) -> UITableViewCell {
        dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell(style: style, reuseIdentifier: identifier)
    }
}
