
//
//  TableViewCell.swift
//  Pokemon_List_with_UIKit
//
//  Created by tharis on 28/7/2564 BE.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {

    static let indentifier = "PokemonTableViewCell"
   
    static func nib() -> UINib {
       
        return UINib(nibName: "PokemonTableViewCell", bundle: nil)
        
    }
    private var title: String = ""
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokeIDCell: UILabel!
    
    func configure(with title:String,id:String) {
        self.title = id
   }
   
    override func awakeFromNib() {
       super.awakeFromNib()
    }

}
