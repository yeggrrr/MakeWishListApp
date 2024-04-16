//
//  NetworkManager.swift
//  YeggrrrWishListApp
//
//  Created by YJ on 4/15/24.
//

import UIKit

class NetworkManager {
    static func fetchRemoteProduct(completion: @escaping (RemoteProduct?) -> Void) {
        let productID = Int.random(in: 1...100)
        // URLSession으로 RemoteProduct 가져오기
        guard let url = URL(string: "https://dummyjson.com/products/\(productID)") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, reponse, error) in
            guard error == nil else { return }
            guard let data else { return }
            do {
                // product를 디코드하여, currentProduct 변수에 담기
                let product = try JSONDecoder().decode(RemoteProduct.self, from: data)
                completion(product)
            } catch {
                print("Decode Error: \(error)")
            }
        }
            
        task.resume()
    }
    
    static func fetchProductImage(id: Int64, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: "https://cdn.dummyjson.com/product-images/\(id)/thumbnail.jpg") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, reponse, error) in
            guard error == nil else { return }
            guard let data else { return }
            let image = UIImage(data: data)
            completion(image)
        }
            
        task.resume()
    }
}
