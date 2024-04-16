//
//  NetworkManager.swift
//  YeggrrrWishListApp
//
//  Created by YJ on 4/15/24.
//

import UIKit

class NetworkManager {
    // completion: 함수가 실행되는데, 순서대로 실행되지 않는 경우가 있다.
    // ex) 데이터 통신을 하는 경우 (= 인터넷에서 뭔가 정보를 다운받는 경우) -> 밟생할 수 있는 문제: 인터넷 개느리면?
    // ->. 화면이 업데이트 되고 난 후에 데이터가 준비됨. -> 정상적으로 안보임. -> 그래서 이럴때 completion을 사용.
    
    // 역할?
    // @escaping: 함수바깥으로 탈출시켜줌.
    // 아무리 오래 걸리는 코드여도 해당 코드의 실행이 완료가 되면(= 다운로드가 다 되면), 그때 그 결과물을 함수 밖으로 탈출시켜줌!!!
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
