//
//  ServiceProtocols.swift
//  TechTest
//
//  Created by user on 18/6/18.
//  Copyright © 2018 SM. All rights reserved.
//

import Foundation

protocol LoadItemProtocol: APIProtocol {
  func loadItemListRequest(withCredentials payload: ItemListScene.ItemList.Request, completionHandler: @escaping (ItemCollection?, Error?) -> Void )
}

protocol APIProtocol {
  
}
