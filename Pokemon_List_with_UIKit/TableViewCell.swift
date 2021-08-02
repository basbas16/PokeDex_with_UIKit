 //
//  TableViewCell.swift
//  Pokemon_List_with_UIKit
//
//  Created by tharis on 28/7/2564 BE.
//

import UIKit

class TableViewCell: UITableViewCell {

    static let indentifier = "PokemonTableViewCell"
    
    
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokeIDCell: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
