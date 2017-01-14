//
//  SearchResultTableViewController.h
//  MapPinLocation
//
//  Created by Shubhi Sharma on 09/01/17.
//  Copyright © 2017 Shubhi Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlaces/GooglePlaces.h>

@interface SearchResultTableViewController : UITableViewController<GMSAutocompleteTableDataSourceDelegate, UISearchControllerDelegate>

@end
