//
//  ViewController.h
//  MapPinLocation
//
//  Created by Shubhi Sharma on 03/01/17.
//  Copyright © 2017 Shubhi Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate, GMSMapViewDelegate,GMSAutocompleteResultsViewControllerDelegate>

@end

