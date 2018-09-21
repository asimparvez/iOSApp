//
//  ViewController.swift
//  iOSApp
//
//  Created by Asim Parvez on 9/16/18.
//  Copyright © 2018 Asim Parvez. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class MainViewController: BaseViewController {

    //MARK: - Items/Vars
    var deliveriesList : DeliveriesList?
    var currentPage = 0
    var nextPageAvailable = true
    var awaitingResponse = false
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DeliveryCell.classForCoder(), forCellReuseIdentifier: "DeliveryCell")
        return tableView
    }()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUI()
        loadDeliveriesFromCache()
        if NetworkReachabilityManager()!.isReachable {
            getPagedDeliveries()
        }else {
            showErrorAlert(message: "No Internet Connection", title: "Error")
        }
    }
    
    //MARK: - GetPage/Refresh
    func getPagedDeliveries()  {
        if nextPageAvailable && !awaitingResponse && NetworkReachabilityManager()!.isReachable
        {
            awaitingResponse = true
            self.getDeliveries()
        }
    }
    
    @objc func handleRefresh() {

        if !NetworkReachabilityManager()!.isReachable {
            refreshControl.endRefreshing()
            showErrorAlert(message: "No Internet Connection", title: "Error")
        }else {
            currentPage = 0
            nextPageAvailable = true
            getPagedDeliveries()
            tableView.reloadData()
        }

    }


    //MARK: - SetUI
    private func setUI() {
        title = "Things to Deliver"
        view.addSubview(tableView)
        tableView.snp.makeConstraints{(make) -> Void in
            make.edges.equalTo(self.view)
        }
        tableView.addSubview(self.refreshControl)
    }
    
    //MARK: - Load Cache
    func loadDeliveriesFromCache()  {
        
        if let manobjArr = CoreDataManager.shared.fetchAllRecords(entity: "Delivery") {
            deliveriesList = DeliveriesList.init(deliveries: manobjArr as! [Delivery])
            tableView.reloadData()
        }
    }


   
    //MARK: - API Calls
    func getDeliveries()  {
        
        let compelteUrl = String(format:"https://mock-api-mobile.dev.lalamove.com/deliveries?offset=%d&limit=%d",currentPage*20,20)
        
        showActivityIndicator()
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
        Alamofire.request(compelteUrl, method: .get, parameters: nil,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                
                
                self.hideActivityIndicator()
                self.awaitingResponse = false
                if response.result.error != nil {
                    self.showErrorAlert(message: response.result.error!.localizedDescription, title: "Error!")
                    return
                }
                guard let json = response.result.value as Any? else {
                    self.showErrorAlert(message: "An Error Occurred", title: "Error!")

                    return
                }
                
                let data = ["data":json]
                if let deliveriesList = Mapper<DeliveriesList>().map(JSONObject:data) {
                    if self.currentPage == 0 {
                    CoreDataManager.shared.deleteAllRecordsFor(entity: "Delivery")
                        self.deliveriesList = deliveriesList
                    }else {
                        self.deliveriesList?.array?.append(contentsOf: deliveriesList.array!)
                    }
                    
                    //Check if more items are available
                    self.currentPage = self.currentPage + 1
                    if deliveriesList.array!.count < 20 {
                        self.nextPageAvailable = false
                    }
                }
                
                CoreDataManager.shared.saveCurrentContext()
                self.tableView.reloadData()
                print(json)
        }
        
        
    }

}

extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveriesList?.array?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryCell", for: indexPath) as! DeliveryCell
        let delivery = deliveriesList!.array![indexPath.row]
        let imgURL = URL.init(string: delivery.imageUrl)
        cell.imgView.sd_setImage(with: imgURL, completed: nil)
        
        cell.lblDescription.text = delivery.descriptionStr
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == deliveriesList!.array!.count {
            getPagedDeliveries()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let delivery = deliveriesList!.array![indexPath.row]
        let vc = DeliveryDetailsVC()
        vc.delivery = delivery
        navigationController?.pushViewController(vc, animated: false)
    }
    
}
