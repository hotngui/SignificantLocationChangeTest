//
//  Created by Joey Jarosz on 7/11/13.
//  Copyright (c) 2013 hot-n-GUI, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface ViewController : UIViewController

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

- (void)addPin:(CLLocation *)location;

@end
