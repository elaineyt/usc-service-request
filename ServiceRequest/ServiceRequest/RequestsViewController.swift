//
//  RequestsViewController.swift
//  ServiceRequest
//
//  Created by Michelle Ran on 10/31/19.
//

import Foundation
import UIKit

class RequestsViewController: UITableViewController {
    var requests: [Request] = [
        Request(id: "id1", poster: "test", title: "Lorem ipsum dolor lorem ipsum dolor lorem ipsum dolor lorem ipsum dolor", desc: "Desc 1", tags: ["tag 1", "tag 2", "tag 3"], price: 100),
        Request(id: "id2", poster: "test", title: "Request 2", desc: "Lorem ipsum dolor lorem ipsum dolor lorem ipsum dolor lorem ipsum dolor", tags: ["tag 2", "tag 3", "tag 4"], price: 75)
    ]
    //var requests: [Request] = []
    
    var shouldFilter: Bool = false
    var filtered: [Request] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*Cloud.getRequests { requests in
            self.requests = requests
            self.tableView.reloadData()
        }*/
    }

    func update(with: Request) {
        requests.append(with)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: requests.count-1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldFilter {
            return filtered.count
        }
        return requests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RequestCell = tableView.dequeueReusableCell(withIdentifier: "RequestCell", for: indexPath) as! RequestCell
        // get request object
        let request: Request
        if shouldFilter { request = filtered[indexPath.row] }
        else { request = requests[indexPath.row] }
        // populate cell
        cell.titleLabel.text = request.title
        cell.tagsLabel.text = request.getTagsString()
        cell.descLabel.text = request.desc
        cell.dateRangeLabel.text = request.getDateRangeString()
        cell.priceLabel.text = "$\(request.price)"
        cell.interestedHandler = { sender in
            self.handleInterested(sender: sender, request: request)
        }
        return cell
    }
    
    func handleInterested(sender: UIButton, request: Request) {
        Cloud.getUser(id: request.poster) { user in
            let alert = UIAlertController(title: "Let \(user.name) know you're interested", message: "Add a message, if you'd like.", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Write your message here"
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Send", style: .default) { _ in
                sender.isEnabled = false
                let textField = alert.textFields![0]
                Cloud.makeOffer(id: request.id, message: textField.text) { _ in
                    // ...
                }
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func applyFilters(tags: String?, minPrice: Int, maxPrice: Int, startDate: Date?, endDate: Date?) {
        var tagsArray: [String] = []
        if let tagsString = tags {
            tagsArray = Util.parseTags(tags: tagsString)
        }
        filtered = requests.filter { request in
            for tag in tagsArray {
                if !request.tags.contains(tag) {
                    return false
                }
            }
            if let start = startDate, let reqStart = request.startDate {
                // is request.startDate earlier than startDate?
                if start.compare(reqStart) == .orderedDescending {
                    return false
                }
            }
            if let end = endDate, let reqEnd = request.endDate {
                // is request.endDate later than endDate?
                if end.compare(reqEnd) == .orderedAscending {
                    return false
                }
            }
            return request.price >= minPrice && request.price <= maxPrice
        }
        shouldFilter = true
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let post = segue.destination as? PostViewController {
            post.requestsViewController = self
        } else if let filter = segue.destination as? FilterViewController {
            filter.requestsViewController = self
        }
    }
}