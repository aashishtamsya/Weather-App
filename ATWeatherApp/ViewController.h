//
//  ViewController.h
//  ATWeatherApp
//
//  Created by Felix ITs 01 on 04/08/16.
//  Copyright © 2016 Aashish Tamsya. All rights reserved.
//

#warning Enter API KEY before deploying
#define kWeatherAPIKey @"791a11b716d4fcc5c4819ce2b62ba771"

//http://api.openweathermap.org/data/2.5/weather?lat=18.633463&lon=73.807032&APPID=791a11b716d4fcc5c4819ce2b62ba771&units=metric

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>



@interface ViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
//    NSString *globalLatitudeString;
//    NSString *globalLongitudeString;
    
    int unit;
    
    
}
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelCountry;
@property (weak, nonatomic) IBOutlet UILabel *labelTemperature;
@property (weak, nonatomic) IBOutlet UILabel *labelMinimumTemperature;
@property (weak, nonatomic) IBOutlet UILabel *labelMaximumTemperature;

@property (weak, nonatomic) IBOutlet UILabel *labelPressure;
@property (weak, nonatomic) IBOutlet UILabel *labelHumidity;


- (IBAction)weatherInC:(id)sender;

- (IBAction)weatherInF:(id)sender;



@end

