//
//  ItemService.swift
//  TechTest
//
//  Created by user on 18/6/18.
//  Copyright © 2018 SM. All rights reserved.
//

import Foundation
import Alamofire

class ItemService: LoadItemProtocol
{
  func loadItemListRequest(withCredentials payload: ItemListScene.ItemList.Request, completionHandler: @escaping (ItemCollection?, Error?) -> Void )
  {
    Alamofire.request(NetworkRouter.getItems).responseData { response in
      //
      debugPrint(response)
      switch response.result {
      case .success( _):
        if let httpStatusCode = response.response?.statusCode {
          switch (httpStatusCode) {
          case 200..<300:
            do{
              //print(value)
              guard let datastring = NSString(data: response.data!, encoding: String.Encoding.isoLatin1.rawValue) else { return }
              guard let data = datastring.data(using: String.Encoding.utf8.rawValue) else { return }
              
              let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
              let jsonDic = object as! NSDictionary
              let itemArray = jsonDic.object(forKey: "rows") as! NSArray
              var items = [Item]()
              for dict in itemArray
              {
                let itemDict        = dict as! NSDictionary
                let itemTitle       = itemDict["title"] as? String
                let itemDescription = itemDict["description"] as? String
                let itemImageUrl    = itemDict["imageHref"] as? String
                
                let itemObject      = Item(title: itemTitle, description: itemDescription, imageHref: itemImageUrl)
                items.append(itemObject)
              }
              
              let itemCollection = ItemCollection(title: "", rows: items)
              
              completionHandler(itemCollection, nil)
              
            }catch(let error) {
              completionHandler(nil, error)
            }
          case 400..<500:
            completionHandler(nil, APIError.validationError(reason: "error description"))
          case 500..<600:
            completionHandler(nil, APIError.internalServerError)
          default:
            completionHandler(nil, APIError.serviceError)
          }
        }
      case .failure(let error):
        if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet {
          completionHandler(nil, APIError.noInternetConnectionError)
        }
        else {
          completionHandler(nil, APIError.networkError)
        }
      }
      //
    }
  }
}
