//
//  AnnouncementViewController.swift
//  NJUNews
//
//  Created by CuiZihan on 2020/12/23.
//

import UIKit
import SwiftSoup

class AnnouncementViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var announcements = [TeachingNews]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        loadWorkFlow()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         super.prepare(for: segue, sender: sender)
         switch segue.identifier ?? "" {
             case "ShowDetail3":
                 guard let AnnsDetailViewController = segue.destination as? WebViewController else {
                     fatalError("Unexpected destination: \(segue.destination)")
                 }
                 
                 guard let selectedAnnsCell = sender as? AnnouncementTableViewCell else {
                     fatalError("Unexpected sender: \(String(describing: sender))")
                 }
                 
                 guard let indexPath = tableView.indexPath(for: selectedAnnsCell) else {
                     fatalError("The selected cell is not being displayed by the table")
                 }
                 
                 let selectedAnns = announcements[indexPath.row]
                 AnnsDetailViewController.news = selectedAnns
                 
             default:
                 fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
         }
     }

}
extension AnnouncementViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementTableViewCell") as! AnnouncementTableViewCell
        cell.ContentLabel.text = announcements[indexPath.row].content
        cell.DateLabel.text = announcements[indexPath.row].date
        return cell
    }
    private func loadWorkFlow(){
        
        let url = URL(string: "https://jw.nju.edu.cn/ggtz/list.htm")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            data, response, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("server error")
                return
            }
            
            if let mimeType = httpResponse.mimeType, mimeType == "text/html",
                        let data = data,
                        let html = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        do{
                            let doc : Document = try SwiftSoup.parse(html)
                            let links : Elements = try doc.getElementsByClass("news")
                            for link in links{
                                let title = try link.select("a").attr("title")
                                let href = try link.select("a").attr("href")
                                let date = try link.select("span.news_meta").text()
                                //print(title,href,date)
                                guard let announcementItem = TeachingNews(content: title, date: date, href: href) else{
                                    fatalError("Unable to instantiate newsItem")
                                }
                                self.announcements.append(announcementItem)
                            }
                            self.tableView.reloadData()
                        }catch Exception.Error(_, let message) {
                            print(message)
                        } catch {
                            print("error")
                        }
                }
            }
        })
        task.resume()
    }
}
