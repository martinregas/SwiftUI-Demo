//
//  NetworkManager.swift
//  Swift-UI-App
//
//  Created by Martin Regas on 14/08/2022.
//

import Foundation

class NetworkManager {
    func request(character:String, completion: @escaping([CharQuote]) -> ()) {
        var characterParam = ""
        
        if !character.isEmpty {
            characterParam = "&character=\(character)"
        }
        
        guard let url = URL(string: "https://thesimpsonsquoteapi.glitch.me/quotes?count=10\(characterParam)") else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            let str = String(decoding: data, as: UTF8.self)
            print(str)
            do {
                let response = try JSONDecoder().decode([CharQuote].self, from: data)
           
                DispatchQueue.main.async {
                    completion(response)
                }
            } catch(let error) {
                DispatchQueue.main.async {
                    print(error)
                }
            }
            
        }.resume()
    }
}
