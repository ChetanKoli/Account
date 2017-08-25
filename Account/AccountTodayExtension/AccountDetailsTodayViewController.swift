//
//  AccountDetailsTodayViewController.swift
//  Account
//
//  Created by Chetan Koli on 8/24/17.
//  Copyright © 2017 tcs. All rights reserved.
//

import UIKit
import NotificationCenter

class AccountDetailsTodayViewController: UIViewController, NCWidgetProviding {

    @IBOutlet fileprivate var accountDisplaySegment: UISegmentedControl!
    @IBOutlet fileprivate weak var statusMessageLabel: UILabel!
    @IBOutlet fileprivate var tableView: UITableView!
    @IBOutlet weak var accountDetailStackView: UIStackView!
    
    fileprivate var accountDetailsViewModel = AccountDetailsViewModel()
    fileprivate var updateResult = NCUpdateResult.noData
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if #available(iOSApplicationExtension 10.0, *) {
            //setup displya mode  (show more(.expanded) or show less(.compact))
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }
        
        tableView.dataSource = self
        
        //Table view Self sizing functionality
        tableView.estimatedRowHeight = 55
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Assuming - Application has shared data to Extension
        //Server side data can be pass to Extension from Application using NSUserDefault with AppGroup
        
        //JSON loading and reading
        accountDetailsViewModel.generateJSONData()
        accountDetailsViewModel.delegate = self

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBActions
    
    @IBAction func displayAccountDetails(_ sender: Any) {
        
        if let segment = sender as? UISegmentedControl
        {
            switch segment.selectedSegmentIndex {
            case 0:
                accountDetailsViewModel.accountRequest(.All)
            case 1:
                accountDetailsViewModel.accountRequest(.OnlyVisible)
            default:
                return
            }
        }
        
        tableView.reloadData()
        
        //Every time calculte height when tableview is reload
        calculateDynamicPreferredContentSize()
    }

    //MARK: - Extension methods
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        updateWidget()
        completionHandler(self.updateResult)
    }
    
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        switch activeDisplayMode {
        case .expanded:
            calculateDynamicPreferredContentSize()
        case .compact:
            self.preferredContentSize = maxSize
        }
    }

}

extension AccountDetailsTodayViewController: UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accountDetailsViewModel.numberOfAccounts()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        return configureAccountCell(atIndexPath: indexPath)
    }

}

extension AccountDetailsTodayViewController: AccountDetailsViewModelProtocol {
    
    //MARK: - AccountDetailsViewModelProtocol methods
    func didAccountDetailsModelUpdated(_ success: Bool) {
        
        DispatchQueue.main.async {
            
            //Update widget as per response
            self.updateResult = success ? .newData : .failed
            self.updateWidget()
            
        }
    }
}

extension AccountDetailsTodayViewController {
    
    //MARK: - Class specific methods
    
    fileprivate func configureAccountCell(atIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifier.AccountDetailTodayExtensionCell, for: indexPath) as? AccountDetailsTodayExtensionTableViewCell else { return UITableViewCell() }
        
        cell.accountNameLabel.text = accountDetailsViewModel.accountName(forIndexPath: indexPath)
        cell.accountBalanceLabel.text = accountDetailsViewModel.accountBalanace(forIndexPath: indexPath)
        cell.ibanNumberLabel.text = accountDetailsViewModel.iban(forIndexPath: indexPath)
        
        return cell
    }
    //Method for handling widget UI as per data status
    fileprivate func updateWidget() {
        
        var isDataObtained = false
        
        switch self.updateResult {
        case .newData:
            isDataObtained = true
            self.displayAccountDetails(self.accountDisplaySegment!)
            
        case .failed:
            self.statusMessageLabel.text = Message.NoDataMessage
        case .noData:
            self.statusMessageLabel.text = Message.LoadingMessage
            
        }
        //Show/Hide Content/Message
        self.accountDetailStackView.isHidden = !isDataObtained
        self.statusMessageLabel.isHidden = isDataObtained
        
    }

    fileprivate func calculateDynamicPreferredContentSize() {
        
        let dynamicHeight = accountDisplaySegment.frame.size.height + self.tableView.contentSize.height
        self.preferredContentSize = CGSize(width: 0.0, height: dynamicHeight)
    }
}

