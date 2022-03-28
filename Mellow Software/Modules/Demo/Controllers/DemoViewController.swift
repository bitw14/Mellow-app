//
//  DemoViewController.swift
//  Mellow Software
//
//  Created by Abdul Waheed on 28/03/2022.
//

import UIKit

class DemoViewController: UIViewController {

    //MARK: - IBOutlets, Variables & Constants
    
    //MARK: - View Controller Lifeceycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        loadData()
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //    }
    //
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //    }
    //
    //    override func viewDidDisappear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //    }
    //
    //    override func viewWillDisappear(_ animated: Bool) {
    //        animated
    //    }
    //
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //    }
    
    //MARK: - View Controller Helping Functions
    
    func setupViewController(){
        
    }
    
    //MARK: - Selectors
    
    // MARK: - IBActions
    
    //MARK: - Private Functions
    
    func loadData(){
        
        let files = AudioFiles.allCases.map({$0.processableFormat})
    
        let startDate = Date()
    
        AudioManager.performCleanupOfOldFiles()
        
        for file in files {
            let manager = AudioManager(fileName: file.name, volume: file.volume)
            manager.prepareToRender()
        }
       
        print("Total Time Elapsed: \(Date().timeIntervalSince(startDate)) seconds")
    }

}
