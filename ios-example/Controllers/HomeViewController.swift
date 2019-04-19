//
//  HomeViewController.swift
//  ios-example
//
//  Created by  anasit on 2019/4/17.
//  Copyright © 2019  anasit. All rights reserved.
//

import UIKit
import SwiftyRequest
import SwiftyJSON

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var mTableView: UITableView!
    
    var dataRows: SwiftyJSON.JSON = SwiftyJSON.JSON.null
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView(){
        let searchCtrl = UISearchController()
        searchCtrl.dimsBackgroundDuringPresentation = false
        searchCtrl.obscuresBackgroundDuringPresentation = false
        searchCtrl.hidesNavigationBarDuringPresentation = false
        searchCtrl.searchBar.placeholder = "搜索城市"
        searchCtrl.searchBar.sizeToFit()
        mTableView.tableHeaderView = searchCtrl.searchBar
        mTableView.refreshControl = UIRefreshControl()
        mTableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        mTableView.refreshControl?.beginRefreshing()
        handleRefresh();
        mTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        mTableView.dataSource = self
        mTableView.delegate = self
    }
    
    @objc func handleRefresh(){
        let request = RestRequest(method: .get, url: "https://www.cool1024.com/china.json")
        request.responseData{ res in
            switch res.result {
            case .success(let result):
                print(result)
                do{
                    self.dataRows = try SwiftyJSON.JSON(data: result)
                }catch{
                    print(error)
                }
            case .failure(let error):
                print("请求失败",error)
            }
            
            DispatchQueue.main.async {
                self.mTableView.reloadData()
                self.mTableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return dataRows.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataRows[section]["children"].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return dataRows[section]["text"].string;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print(indexPath.section,indexPath.row)
        let detailCtrl = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as!DetailViewController
        let section = dataRows[indexPath.section]
        let row = section["children"][indexPath.row]
        detailCtrl.paramsStr = """
            \(section["text"].string!)-\(row["text"].string!)
        """
        navigationController?.pushViewController(detailCtrl, animated: true)
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        let row = dataRows[indexPath.section]["children"][indexPath.row]
        cell.textLabel?.text = row["text"].string
        cell.imageView?.image = UIImage(named:  "IconHome")
        return cell
    }
}
