//
//  DeliveryCell.swift
//  iOSApp
//
//  Created by Asim Parvez on 9/21/18.
//  Copyright © 2018 Asim Parvez. All rights reserved.
//

import UIKit
import SnapKit

class DeliveryCell: UITableViewCell {

    //MARK: - Items/Vars
    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    lazy var lblDescription: UILabel  = {
        let lblDescription = UILabel()
        lblDescription.numberOfLines = 0
        return lblDescription
    }()
    
    //MARK: - Initialize
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        drawUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func drawUI() {
        contentView.addSubview(imgView)
        contentView.addSubview(lblDescription)
        
        imgView.snp.makeConstraints{(make) -> Void in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(60)
        }
        
        lblDescription.snp.makeConstraints{(make) -> Void in
            make.leading.equalTo(imgView.snp.trailing).offset(8)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalTo(self).offset(8)
        }
    }
    

}

