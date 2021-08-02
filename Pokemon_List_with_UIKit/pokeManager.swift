//
//  pokeManager.swift
//  Pokemon_List_with_UIKit
//
//  Created by tharis on 28/7/2564 BE.
//

import Foundation

enum PokemonError: Error{
    case noData
    case canNotProcess
}

struct pokeDetail: Decodable {
    var name : String
    
}


struct Pokemon: Codable {
//    let id: Int?
//    let isMainSeries: Bool?
//    let name: String?
//    let names: [Name]?
    let pokemon_entries: [PokemonEntry]?
//    let region: Region?
//    let versionGroups: [Region]?

    enum CodingKeys: String, CodingKey {
//        case id
//        case isMainSeries
//        case name, names
        case pokemon_entries
//        case region
//        case versionGroups
    }
}

// MARK: - Region
struct Region: Codable {
    let name: String
    let url: String
}

// MARK: - Name
struct Name: Codable {
    let language: Region
    let name: String
}

// MARK: - PokemonEntry
struct PokemonEntry: Codable {
    let entry_number: Int
    let pokemon_species: Region

    enum CodingKeys: String, CodingKey {
        case entry_number
        case pokemon_species
    }
}

struct pokemonRequest {
    
    let resourceURL: URL
    
    init() {
        let resourceString = "https://pokeapi.co/api/v2/pokedex/2"
        guard let resourceURL = URL(string: resourceString) else {
            fatalError()
        }
        self.resourceURL = resourceURL
    }
    
    func getPokemon(completion: @escaping(Result<[PokemonEntry],PokemonError>) -> Void ) {
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
                    let decoder = JSONDecoder()
                    let pokemonRes = try decoder.decode(Pokemon.self, from: data )
                    let pokemon = pokemonRes
                    completion(.success(pokemon.pokemon_entries!))
                default:
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



struct pokemonDetailRequest {
    
    let resourceURL: URL
    
    init(id:Int) {
        let resourceString = "https://pokeapi.co/api/v2/pokemon/\(String(id))/"
        guard let resourceURL = URL(string: resourceString) else {
            fatalError()
        }
        self.resourceURL = resourceURL
    }
    
    func getPokemon(completion: @escaping(Result<[PokemonDetail],PokemonError>) -> Void ) {
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
                    let decoder = JSONDecoder()
                    let pokemonRes = try decoder.decode(PokemonDetail.self, from: data )
                    let pokemon = pokemonRes
                    completion(.success([pokemon]))
                default:
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

// MARK: - PokemonDetail
struct PokemonDetail: Codable {
    let height, id: Int
    let name: String
    let sprites: Sprites
    let types: [TypeElement]
    let weight: Int
}

// MARK: - Sprites
struct Sprites: Codable {
    let back_default, front_default: String

    enum CodingKeys: String, CodingKey {
        case back_default
        case front_default
    }
}

// MARK: - TypeElement
struct TypeElement: Codable {
    let slot: Int
    let type: TypeType
}

// MARK: - TypeType
struct TypeType: Codable {
    let name: String
}
