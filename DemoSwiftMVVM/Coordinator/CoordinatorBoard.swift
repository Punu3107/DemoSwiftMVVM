import UIKit

protocol CoordinatorBoard: UIViewController {
    static func instansiateFromStoryBoard() -> Self?
}
    
extension CoordinatorBoard {
    static func instansiateFromStoryBoard() -> Self? {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let id = String(describing: self)
        guard let self = storyBoard.instantiateViewController(withIdentifier: id) as? Self else {
            return nil }
        return self
    }
}
