//
//  ViewController.swift
//  Github_Search
//
//  Created by Vladyslav on 03.02.2021.
//

import UIKit

class ViewController: UIViewController {

    let vm = RepoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        vm.searchRepos(in: "rx")
    }


}

