//
//  HomeViewController.swift
//  ios-example
//
//  Created by  anasit on 2019/4/17.
//  Copyright © 2019  anasit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var mTableView: UITableView!
    
    var dataRows:JSON = JSON.null
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView(){
        mTableView.refreshControl = UIRefreshControl()
        mTableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        mTableView.refreshControl?.beginRefreshing()
        handleRefresh();
        mTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        mTableView.dataSource = self
        mTableView.delegate = self
    }
    
    @objc func handleRefresh(){
        AF.request("https://www.cool1024.com/china.json").responseJSON{ response in
            if let data = response.data {
                do{
                    self.dataRows = try JSON(data:data)
                    DispatchQueue.main.async {
                        self.mTableView.reloadData()
                        self.mTableView.refreshControl?.endRefreshing()
                    }
                }catch{
                    print(error)
                }
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
        return cell
    }
}
