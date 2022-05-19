//
//  CustomTableViewCell.swift
//  DragDropTableView
//
//  Created by MAC-OBS-26 on 16/05/22.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
   
    //MARK: - Properties
    
    public weak var label1: UILabel!
    
    //MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Public and Private Functions
    
    public func setupViews() {
        let label1Item = UILabel()
        label1Item.translatesAutoresizingMaskIntoConstraints = false
        label1Item.textColor = .white
        self.label1 = label1Item
        contentView.addSubview(label1Item)
        
        setupConstraints()
    }
    
    //MARK: - SetUpConstraints
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            label1.topAnchor.constraint(equalTo: contentView.topAnchor),
            label1.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            label1.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            label1.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
