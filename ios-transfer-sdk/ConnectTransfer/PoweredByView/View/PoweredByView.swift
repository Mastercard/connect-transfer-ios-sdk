//
//  PoweredByView.swift
//  Connect
//
//  Created by Anupam Kumar on 29/07/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit

class PoweredByView: UIView {
    
    //MARK: - Outlets
    @IBOutlet weak var poweredByLabel: UILabel!
    @IBOutlet weak var mastercardLogo: UIImageView!
    
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
        setUpPoweredByView()
    }

    //MARK: - Class Methods
    private func viewInit() {
        
        guard let poweredByView = Bundle.getFrameworkBundle().loadNibNamed("PoweredByView", owner: self, options: [:])?.first as? UIView else {
            return
        }
        poweredByView.frame = self.bounds
       
        addSubview(poweredByView)
    }
    
    private func setUpPoweredByView() {
        self.poweredByLabel.text = TransferViewControllerUtil.getPoweredByText()
        self.poweredByLabel.font = UIFont.systemFont(ofSize: 14)
        self.poweredByLabel.textColor = TransferViewControllerUtil.getDefaultOnLightTextColor()

        self.mastercardLogo.image = UIImage(named: "mastercard_logo")
    }
}
