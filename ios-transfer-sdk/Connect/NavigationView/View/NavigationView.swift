//
//  NavigationView.swift
//  Connect
//
//  Created by Anupam Kumar on 30/07/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit

class NavigationView: UIView {

    //MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!{
        didSet {
            let backButtonImage = UIImage(named: "arrow_left")?.renderAlwaysWithTemplateMode()
            backButton.setImage(backButtonImage, for: .normal)
            backButton.tintColor = .black
        }
    }
    
    @IBOutlet weak var closeButton: UIButton!{
        didSet {
            let closeButtonImage = UIImage(named: "close")?.renderAlwaysWithTemplateMode() 
            closeButton.setImage(closeButtonImage, for: .normal)
            closeButton.tintColor = .black
        }
    }
    
    //MARK: - Callbacks
    var backButtonCallback:(()->Void)?
    var closeButtonCallback:(()->Void)?
    
    
    //MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: - Class Methods
    private func viewInit() {
        
        guard let navigationView = Bundle.main.loadNibNamed("NavigationView", owner: self, options: [:])?.first as? UIView else {
            return
        }
        navigationView.frame = self.bounds
       
        addSubview(navigationView)
    }
    
    //MARK: - Actions
    @IBAction func backButtonAction(_ sender: Any) {
        if let backButtonCallback = self.backButtonCallback {
            backButtonCallback()
        }
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        if let closeButtonCallback = self.closeButtonCallback {
            closeButtonCallback()
        }
    }

}
