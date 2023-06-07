//
//  WalktroughViewController.swift
//  wav
//
//  Created by Ilyes Djari on 07/06/2023.
//

import UIKit

class WalktroughViewController: UIViewController {

    // Outlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var dots: UIPageControl!

    // Properties
    var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func swipeAction(_ sender: Any) {
        page += 1
        updatePage(animated: true)
    }

    private func updatePage(animated: Bool) {
        guard page >= 1 && page <= 5 else {
            // Perform segue to NavigationHomeViewController when page is 6
            self.performSegue(withIdentifier: "home", sender: self)
            return
        }

        let imageName = "Walktrough\(page)"

        if animated {
            let nextImage = UIImage(named: imageName)
            UIView.transition(with: self.image,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: { self.image.image = nextImage },
                              completion: nil)
        } else {
            image.image = UIImage(named: imageName)
        }

        dots.currentPage = page - 1
    }
}
