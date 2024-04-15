//
//  ViewController.swift
//  YeggrrrWishListApp
//
//  Created by YJ on 4/9/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    // currentProduct가 set되면, imageView, titleLabel, descriptionLable, priceLabel 각각 적절한 값 지정
    private var currentProduct: RemoteProduct? = nil {
        didSet {
            // currentProduct가 nil이 아닌 경우를 가져와야하므로, guard let으로 바인딩해주기
            guard let currentProduct = self.currentProduct else { return }
            // UI와 관련된 작업들은 모두 main에서 해줘야함 / 비동기
            DispatchQueue.main.async {
                self.productImageView.image = nil
                self.titleLabel.text = currentProduct.title
                self.descriptionLabel.text = currentProduct.description
                self.priceLabel.text = "\(currentProduct.price)$"
            }
            // image를 데이터화 시키고, image를 UIImage로 바꾼 다음 실제로 보여줘야하므로 global로 감싸주기
            DispatchQueue.global().async { [weak self] in
                // URL로 넘어온것을 데이터화 시켜주기 -> 데이터로 UIImage로 변환
                if let data = try? Data(contentsOf: currentProduct.thumbnail), let image = UIImage(data: data) {
                    DispatchQueue.main.async {self?.productImageView.image = image}
                }
            }
        }
    }

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var saveWishListButton: UIButton!
    @IBOutlet weak var presentAnotherProductButton: UIButton!
    @IBOutlet weak var presentWishListButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchRemoteProduct() // 새로운 상품 불러오기
        buttonLayout()
    }
    
    func buttonLayout() {
        saveWishListButton.layer.cornerRadius = 15
        presentAnotherProductButton.layer.cornerRadius = 15
        presentWishListButton.layer.cornerRadius = 15
        titleLabel.font = .systemFont(ofSize: 27, weight: .bold)
        descriptionLabel.textColor = .darkGray
        priceLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
    }
    
    // 다른 상품 보기 버튼 클릭
    @IBAction func tappedAnotherProductButton(_ sender: UIButton) {
        self.fetchRemoteProduct()
    }
    // 위시 리스트 담기 버튼 클릭
    @IBAction func tappedSaveWishListButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "<위시 리스트>", message: "해당 상품을 추가하시겠습니까?", preferredStyle: .alert)
        
        let addButton = UIAlertAction(title: "추가", style: .default) { [weak self] _ in
            self?.saveWishListProduct()
            self?.dismiss(animated: true)
        }
        
        let cancelButton = UIAlertAction(title: "취소", style: .default, handler: nil)
        
        alert.addAction(addButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true)
    }
    // 위시 리스트 보기 버튼 클릭
    
    @IBAction func tappedPresentWishListButton(_ sender: UIButton) {
        // WishListViewController 가져오기
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "WishListViewController") as? WishListViewController else { return }
        
        self.present(nextVC, animated: true)
        
    }
    
    // URLSession을 통해 RemoteProduct를 가져와 currentProduct 변수에 저장하는 함수
    private func fetchRemoteProduct() {
        let productID = Int.random(in: 1...100)
        
        // URLSession으로 RemoteProduct 가져오기
        if let url = URL(string: "https://dummyjson.com/products/\(productID)") {
            let task = URLSession.shared.dataTask(with: url) { (data, reponse, error) in
                if let error = error {
                    print("Error: \(error)") // error Label를 보여줘도 되고, Alert를 띄워줘도 됨. - 자유롭게!!
                } else if let data = data {
                    do {
                        // product를 디코드하여, currentProduct 변수에 담기
                        let product = try JSONDecoder().decode(RemoteProduct.self, from: data)
                        self.currentProduct = product
                    } catch {
                        print("Decode Error: \(error)")
                    }
                }
            }
            // 네트워크 요청 시작
            task.resume()
        }
    }
    
    // currentProduct를 가져와 CoreData에 저장
    private func saveWishListProduct() {
        guard let context = self.persistentContainer?.viewContext else { return }
        
        guard let currentProduct = self.currentProduct else { return }
        
        let wishListProduct = Product(context: context)
        
        wishListProduct.primaryKey = UUID()
        wishListProduct.id = Int64(currentProduct.id)
        wishListProduct.title = currentProduct.title
        wishListProduct.price = currentProduct.price
        
        try? context.save()
    }
    
    // coreData에 리스트 삭제 업데이트
    
    private func deleteWishListProduct() {
        // guard let context = self.persistentContainer?.viewContext else { return }
        // 
        // guard let currentProduct = self.currentProduct else { return }
        
        
        
        
    }
}
