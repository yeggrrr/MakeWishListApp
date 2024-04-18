//
//  WishListViewController.swift
//  YeggrrrWishListApp
//
//  Created by YJ on 4/9/24.
//

import UIKit
import CoreData

class WishListViewController: UITableViewController {
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }

    private var productList: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        let fetchedData = CoreDataManager.fetch()
        productList = fetchedData
    }
    
    override func  tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WishListCell", for: indexPath) as? WishListCell else { return UITableViewCell() }
        let product = self.productList[indexPath.row]
        NetworkManager.fetchProductImage(id: product.id) { image in
            DispatchQueue.main.async {
                cell.productImageView.image = image
            }
        }
        
        cell.titleLabel.text = "[No. \(product.id)]\n\(product.title ?? "-")"
        cell.subTitleLabel.text = "$ \(product.price)"
        cell.titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        cell.titleLabel.numberOfLines = 3
        cell.subTitleLabel.textColor = .red
        cell.productImageView.contentMode = .scaleAspectFill
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 원하는 상품 셀에서 삭제
            let productPrimaryKey = productList[indexPath.row].primaryKey
            CoreDataManager.delete(primaryKey: productPrimaryKey)
            // 데이터에서 삭제
            productList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}



