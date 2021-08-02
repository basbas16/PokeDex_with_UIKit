//
//  ViewController.swift
//  Pokemon_List_with_UIKit
//
//  Created by tharis on 28/7/2564 BE.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var pokemonTabelView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokeList = [PokemonEntry](){
        didSet{
            DispatchQueue.main.async {
                self.pokemonTabelView.reloadData()
            }
        }
    }
    var pokeFilter = [PokemonEntry]()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let pokemonreq = pokemonRequest()
        pokemonreq.getPokemon{ [weak self] result in
            switch result{
            case .failure(let Error):
                print(Error)
            case .success(let pokemon):
                self?.pokeList = pokemon
                self?.pokeFilter = pokemon
            }
        }
        
//        pokemonTabelView.register(PokemonTableViewCell.nib(), forCellReuseIdentifier: PokemonTableViewCell.indentifier)
        pokemonTabelView.delegate = self
        pokemonTabelView.dataSource = self
        searchBar.delegate = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokeFilter.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath as IndexPath) as! PokemonTableViewCell

        let pokemon = self.pokeFilter[indexPath.row]
        cell.pokeIDCell.text = String(pokemon.entry_number)
        cell.pokemonNameLabel.text = pokemon.pokemon_species.name
        cell.configure(with: pokemon.pokemon_species.name, id: String(pokemon.entry_number))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "sagueDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? pokemonDetailViewController {
            
            let data =  pokeFilter[pokemonTabelView.indexPathForSelectedRow!.row]
            target.id = data.entry_number
        }
    }
}

extension ViewController{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.pokeFilter = []
        
        
        
        
        if searchText.isEmpty{
            self.pokeFilter = self.pokeList
        } else {
            for poke in pokeList{
                let name = poke.pokemon_species.name.lowercased()
                let id = String(poke.entry_number)
                if name.contains(searchText.lowercased()) || id.contains(searchText){
                    self.pokeFilter.append(poke)
                }
            }
        }
        pokemonTabelView.reloadData()
    }
    
}
