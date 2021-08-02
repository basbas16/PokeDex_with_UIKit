//
//  pokemonDetailViewController.swift
//  Pokemon_List_with_UIKit
//
//  Created by tharis on 28/7/2564 BE.
//

import UIKit
import Foundation

class pokemonDetailViewController: UIViewController{
    
//    @IBOutlet
    @IBOutlet var stack: UIStackView!
    
    
    @IBOutlet weak var pokeImg: UIImageView!
    @IBOutlet weak var pokeName: UILabel!
    @IBOutlet weak var weightData: UILabel!
    @IBOutlet weak var heightData: UILabel!
    @IBOutlet weak var typeData: UILabel!
    @IBOutlet weak var typeData2: UILabel?
    
    @IBOutlet weak var pokeId: UILabel!
    public var id: Int = 0{
        didSet{
            
            getDetail()
        }
    }
    var resourceURL:URL = URL(fileURLWithPath: "")
    
    
    var pokedetail = [PokemonDetail](){
        didSet{
            DispatchQueue.main.async { [self] in
                let data = self.pokedetail[0]
                self.pokeImg.downloaded(from: data.sprites.front_default)
                self.pokeId.text = String(data.id)
                self.pokeName.text = data.name
                self.heightData.text = String(data.height)
                self.weightData.text = String(data.weight)
                for index in 0..<data.types.count{
                    if index == 0{
                        self.typeData.text = data.types[index].type.name.uppercased()
                        self.typeData.backgroundColor = self.typeGetting(type: data.types[index].type.name)
                        self.typeData.textColor = .white
                        self.typeData.layer.cornerRadius = 5
                        self.typeData.textAlignment = .center
                    } else {
                        self.typeData2!.text = data.types[index].type.name.uppercased()
                        self.typeData2?.backgroundColor = self.typeGetting(type: data.types[index].type.name)
                        self.typeData2?.textColor = .white
                        self.typeData2?.layer.cornerRadius = 5
                        self.typeData2?.textAlignment = .center
                    }
                }
                
                self.pokeImg.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                self.pokeImg.sizeToFit()
                self.view.reloadInputViews()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        self.pokeId.text = ""
        self.pokeName.text = ""
        self.heightData.text = ""
        self.weightData.text = ""
        self.typeData.text = ""
        self.pokeImg.downloaded(from: "")
    }
    
}

extension pokemonDetailViewController{
    
    func typeGetting(type:String) -> UIColor{
        
        switch type {
        case "bug":
            return UIColor(red: 168/255, green: 184/255, blue: 33/255, alpha: 1)
        case "fight":
            return UIColor(red: 192/255, green: 48/255, blue: 40/255, alpha: 1)
        case "ghost":
            return UIColor(red: 113/255, green: 88/255, blue: 153/255, alpha: 1)
        case "electric":
            return UIColor(red: 248/255, green: 208/255, blue: 48/255, alpha: 1)
        case "flying":
            return UIColor(red: 164/255, green: 143/255, blue: 239/255, alpha: 1)
        case "steel":
            return UIColor(red: 184/255, green: 184/255, blue: 208/255, alpha: 1)
        case "psychic":
            return UIColor(red: 250/255, green: 86/255, blue: 136/255, alpha: 1)
        case "poison":
            return UIColor(red: 157/255, green: 68/255, blue: 154/255, alpha: 1)
        case "fire":
            return UIColor(red: 240/255, green: 127/255, blue: 47/255, alpha: 1)
        case "ice":
            return UIColor(red: 152/255, green: 216/255, blue: 216/255, alpha: 1)
        case "ground":
            return UIColor(red: 223/255, green: 193/255, blue: 104/255, alpha: 1)
        case "water":
            return UIColor(red: 105/255, green: 142/255, blue: 238/255, alpha: 1)
        case "dragon":
            return UIColor(red: 112/255, green: 55/255, blue: 253/255, alpha: 1)
        case "rock":
            return UIColor(red: 184/255, green: 159/255, blue: 56/255, alpha: 1)
        case "grass":
            return UIColor(red: 120/255, green: 199/255, blue: 80/255, alpha: 1)
        case "dark":
            return UIColor(red: 111/255, green: 88/255, blue: 72/255, alpha: 1)
        default:
            return UIColor(red: 168/255, green: 167/255, blue: 119/255, alpha: 1)
        }
    }
    
    func getDetail(){
        
        let resourceString = "https://pokeapi.co/api/v2/pokemon/\(String(id))/"
        guard let resourceURL = URL(string: resourceString) else {
            fatalError()
        }
        self.resourceURL = resourceURL
        callDetailPokemon{ [weak self] result in
            switch result{
            case .failure(let Error):
                print(Error)
            case .success(let pokemon):
                self?.pokedetail = pokemon
            }
        }
    }
    
    func callDetailPokemon(completion: @escaping(Result<[PokemonDetail],PokemonError>) -> Void ) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL){data, res, err in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            guard let data = data,let res = res as? HTTPURLResponse else {
                completion(.failure(.noData))
                return
            }
            
            do{
                switch res.statusCode{
                case 200:
                    print(data)
                    let decoder = JSONDecoder()
                    let pokemonRes = try decoder.decode(PokemonDetail.self, from: data )
                    let pokemon = pokemonRes
                    completion(.success([pokemon]))
                default:
                    print(data)
                    return
                }
                
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }
        dataTask.resume()
    }
    
}


//Ref:https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
