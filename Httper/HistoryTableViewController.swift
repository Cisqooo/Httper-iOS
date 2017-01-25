//
//  HistoryTableViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 14/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit
import Alamofire

class HistoryTableViewController: UITableViewController {
    
    private let dao = DaoManager.sharedInstance
    private var dateFormatter = DateFormatter()
    private var requests :[Request]!

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale.current
        requests = dao.requestDao.findAll()
        // Pull new updated request from server.
        pullUpdatedRequest()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestIdentifier", for: indexPath)
        let urlLabel = cell.viewWithTag(1) as! UILabel
        let methodLabel = cell.viewWithTag(2) as! UILabel
        let updateLabel = cell.viewWithTag(3) as! UILabel
        let reuqest = requests[indexPath.row]
        urlLabel.text = reuqest.url
        methodLabel.text = reuqest.method
        updateLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(reuqest.update)))
        return cell
    }
    
    /**
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default,
                                                title: NSLocalizedString("delete_name", comment: ""),
                                                handler: { (action, indexPath) in
            self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
        })
        deleteButton.backgroundColor = RGB(PrettyColor.key.rawValue)
        return [deleteButton]
    }
    */

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let length = self.navigationController?.viewControllers.count
        let controller = self.navigationController?.viewControllers[length! - 2]
        controller?.setValue(requests[indexPath.row], forKey: "request")
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let request = requests[indexPath.row]
            dao.requestDao.delete(request)
            requests.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Delete this request in server
            let params: Parameters = [
                "rid": request.rid!
            ]
            Alamofire.request(createUrl("api/request/push"),
                              method: HTTPMethod.delete,
                              parameters: params,
                              encoding: URLEncoding.default,
                              headers: tokenHeader())
            .responseJSON(completionHandler: { (responseObject) in
                let response = InternetResponse(responseObject)
                if response.statusOK() {
                    // Update local request revision by the revision from server.
                    let revision = response.getResult()["revision"] as! Int
                    updateRequestRevision(revision)
                }
            })
        } 
    }
    
    // MARK: - Service
    func pullUpdatedRequest() {
        let localRevision = requestRevision()
        let params: Parameters = [
            "revision": localRevision
        ]
        Alamofire.request(createUrl("api/request/pull"),
                          method: HTTPMethod.get,
                          parameters: params,
                          encoding: URLEncoding.default,
                          headers: tokenHeader())
        .responseJSON { (responseObject) in
            let response = InternetResponse(responseObject)
            if response.statusOK() {
                let result = response.getResult()
                let revision = result?["revision"] as! Int
                if revision > localRevision {
                    let requests = result?["requests"] as! [[String: Any]]
                    // Save updated requests to persistent store
                    for request in requests {
                        self.dao.requestDao.syncUpdated(request)
                    }
                    
                    // Update local request revision
                    updateRequestRevision(revision)
                    
                    // Refresh table view
                    self.requests = self.dao.requestDao.findAll()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}
