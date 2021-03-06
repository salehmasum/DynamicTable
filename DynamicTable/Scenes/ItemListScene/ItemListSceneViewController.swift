//
//  ItemListSceneViewController.swift
//  TechTest
//
//  Created by user on 18/6/18.
//  Copyright (c) 2018 SM. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ItemListSceneDisplayLogic: class
{
  func displayItems(viewModel: ItemListScene.ItemList.ViewModel)
  func presentError(error: Error)
}

class ItemListSceneViewController: UIViewController, ItemListSceneDisplayLogic, UITableViewDataSource, UITableViewDelegate
{
  var interactor: ItemListSceneBusinessLogic?
  var router: (NSObjectProtocol & ItemListSceneRoutingLogic & ItemListSceneDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = ItemListSceneInteractor()
    let presenter = ItemListScenePresenter()
    let router = ItemListSceneRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate   = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 140
    tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    setupRefreshControl()
    requestToLoadItemList()
  }
  
  // MARK: Properties
  let refreshControl = UIRefreshControl()
  @IBOutlet weak var tableView: UITableView!
  var viewModel: ItemListScene.ItemList.ViewModel?
  
  func setupRefreshControl()
  {
    // Add Refresh Control to Table View
    if #available(iOS 10.0, *) {
      tableView.refreshControl = refreshControl
    } else {
      tableView.addSubview(refreshControl)
    }
    // Configure Refresh Control
    refreshControl.addTarget(self, action: #selector(loadItemData(_:)), for: .valueChanged)
  }
  
  @objc private func loadItemData(_ sender: Any) {
    // Fetch Weather Data
    requestToLoadItemList()
  }
  
  func requestToLoadItemList()
  {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    interactor?.loadItemList(request: ItemListScene.ItemList.Request())
  }
  
  func displayItems(viewModel: ItemListScene.ItemList.ViewModel)
  {
    self.refreshControl.endRefreshing()
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
    self.viewModel = viewModel
    displayTitle(viewModel: viewModel)
    self.tableView.reloadData()
  }
  
  func displayTitle(viewModel: ItemListScene.ItemList.ViewModel)
  {
    if let title = viewModel.title
    {
      self.title = title
    }
  }
  
  func presentError(error: Error)
  {
    self.refreshControl.endRefreshing()
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
    print(error)
    showAlertWithMessge(message: error.localizedDescription)
  }
  
  //MARK: collectionview data source
  func numberOfSections(in tableView: UITableView) -> Int
  {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let viewModel = viewModel else { return 0 }
    return viewModel.itemArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemCell
    let currentItem = viewModel!.itemArray[indexPath.row]
    cell.itemModel = currentItem
    return cell
  }

    
}

extension ItemListSceneViewController {
  
  func showAlertWithMessge(message: String)
  {
    let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(OKAction)
    present(alertController, animated: true)
  }
  
}
