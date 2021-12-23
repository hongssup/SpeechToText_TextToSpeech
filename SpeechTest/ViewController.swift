//
//  ViewController.swift
//  SpeechTest
//
//  Created by SeoYeon Hong on 2021/12/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let sections = ["STT (Speech to Text)", "TTS (Text to Speech)"]
    var samples = ["Apple Speech", "Naver CLOVA", "Google Cloud"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Samples"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return samples.count
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.systemGray6
        //let header = view as! UITableViewHeaderFooterView
        //header.textLabel?.textColor = .black
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = samples[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}
