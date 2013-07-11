//
//  Created by Joey Jarosz on 7/11/13.
//  Copyright (c) 2013 hot-n-GUI, Inc. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "ViewController.h"


@interface ViewController () <MKMapViewDelegate>
    @property (nonatomic, weak) IBOutlet UILabel *label;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)addPin:(CLLocation *)location
{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = location.coordinate;
    
    [self.mapView addAnnotation:annotation];
    
    //
    MKCoordinateRegion region;
    region.center = location.coordinate;
    region.span = MKCoordinateSpanMake(0.1, 0.1);
    
    [self.mapView setRegion:region animated:YES];
}

#pragma mark -
#pragma mark Actions

- (IBAction)clearPinsTouched:(id)sender
{
    [self.mapView removeAnnotations:self.mapView.annotations];
}

#pragma mark -
#pragma mark MKMapViewDelegate Protocol

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    MKAnnotationView *view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    return view;
}

@end
