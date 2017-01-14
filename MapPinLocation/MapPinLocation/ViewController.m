//
//  ViewController.m
//  MapPinLocation
//
//  Created by Shubhi Sharma on 03/01/17.
//  Copyright © 2017 Shubhi Sharma. All rights reserved.
//

#import "ViewController.h"
#import <GooglePlaces/GooglePlaces.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet GMSMapView *gmapView;
@property (retain, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *coordinateLabel;

@end

@implementation ViewController
{
    UISearchController *_searchController;
    GMSAutocompleteResultsViewController *_acViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Pin Location";
    
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    [_locationManager requestWhenInUseAuthorization];
    
    _gmapView.delegate = self;
    
    _acViewController = [[GMSAutocompleteResultsViewController alloc]init];
    _acViewController.delegate = self;
    _acViewController.tableCellBackgroundColor = [UIColor whiteColor];
    _searchController = [[UISearchController alloc]initWithSearchResultsController:_acViewController];
    _searchController.searchResultsUpdater = _acViewController;
    [_searchController.searchBar sizeToFit];
    _searchController.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _searchController.searchBar.searchBarStyle = UISearchBarStyleDefault;
   
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 65.0, self.view.frame.size.width, 50)];
    [subView addSubview:_searchController.searchBar];
    [_searchController.searchBar sizeToFit];
    [self.view addSubview:subView];

}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse){
        //update location
        [_locationManager startUpdatingLocation];
        
        //to update map
        [_gmapView setMyLocationEnabled:true];
        [_gmapView.settings setMyLocationButton:true];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    GMSCameraPosition *newposition=[[GMSCameraPosition alloc]initWithTarget:locations.firstObject.coordinate zoom:15 bearing:0 viewingAngle:0];
    
    _gmapView.camera = newposition;
    [_locationManager stopUpdatingLocation];
}

-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position{
    [self reverseGeocodingLocation:position.target];
}

//Reverse geocoding

-(void)reverseGeocodingLocation:(CLLocationCoordinate2D)locationCoordinate{

    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:locationCoordinate completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        NSLog(@"reverse geocoding results:");
        GMSAddress *addressObj = [response firstResult];
       // for(GMSAddress* addressObj in [response results])
        //{
            
            NSLog(@"coordinate.latitude=%f", addressObj.coordinate.latitude);
            NSLog(@"coordinate.longitude=%f", addressObj.coordinate.longitude);
            NSLog(@"thoroughfare=%@", addressObj.thoroughfare);
            NSLog(@"locality=%@", addressObj.locality);
            NSLog(@"subLocality=%@", addressObj.subLocality);
            NSLog(@"administrativeArea=%@", addressObj.administrativeArea);
            NSLog(@"zipCode=%@", addressObj.postalCode);
            NSLog(@"country=%@", addressObj.country);
            NSLog(@"lines=%@", addressObj.lines);
            
            _coordinateLabel.text = [NSString stringWithFormat:@"%@, %@, %@, %@", addressObj.thoroughfare, addressObj.subLocality, addressObj.locality, addressObj.postalCode];
       // }
    }];
    
}

-(void)resultsController:(GMSAutocompleteResultsViewController *)resultsController didFailAutocompleteWithError:(NSError *)error{
    
    //self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

//called when the result is chosen
-(void)resultsController:(GMSAutocompleteResultsViewController *)resultsController didAutocompleteWithPlace:(GMSPlace *)place{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //relocate the place on map
    [_gmapView animateToLocation:place.coordinate];
}

-(void)didRequestAutocompletePredictionsForResultsController:(GMSAutocompleteResultsViewController *)resultsController{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
-(void)didUpdateAutocompletePredictionsForResultsController:(GMSAutocompleteResultsViewController *)resultsController{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
@end
