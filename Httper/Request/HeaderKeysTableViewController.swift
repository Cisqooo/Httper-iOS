//
//  HeaderKeysTableViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 29/01/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import UIKit

let headerKeys = ["Accept", "Accept-Charset", "Accept-Encoding", "Accept-Language", "Accept-Datetime", "Authorization", "Cache-Control", "Connection", "Cookie", "Connection", "Content-Length", "Content-MD5", "Content-Type", "Date", "Expect", "Forwarded", "From", "Host", "If-Match", "If-Modified-Since", "If-None-Match", "If-Range", "If-Unmodified-Since", "Max-Forwards", "Origin", "Pragma", "Proxy-Authorization", "Range", "Referer", "User-Agent", "Upgrade", "Via", "Warning"]

class HeaderKeysTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headerKeys.count
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "keyIdentifier", for: indexPath as IndexPath)
        let keyNameLabel: UILabel = cell.viewWithTag(1) as! UILabel
        let keyDescriptionLabel = cell.viewWithTag(2) as! UILabel
        keyNameLabel.text = headerKeys[indexPath.row]
        keyDescriptionLabel.text = NSLocalizedString(keyNameLabel.text!, comment: "")
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let length = self.navigationController?.viewControllers.count
        let controller = self.navigationController?.viewControllers[length! - 2]
        controller?.setValue(headerKeys[indexPath.row], forKey: "choosedheaderKey")
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
