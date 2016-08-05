//
//  ViewController.m
//  ATWeatherApp
//
//  Created by Felix ITs 01 on 04/08/16.
//  Copyright © 2016 Aashish Tamsya. All rights reserved.
//
#define kFahrenheitUnit @"imperial"
#define kCelsiusUnit @"metric"




#import "ViewController.h"

typedef enum : NSUInteger {
    Fahrenheit = 0,
    Celsius = 1
} UnitType;


@interface ViewController ()

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
//    globalLatitudeString = [[NSString alloc]init];
//    globalLongitudeString = [[NSString alloc]init];
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getUserLocation {
    
    [locationManager startUpdatingLocation];
    
}

-(void)downloadWeatherDataWithLatitude:(NSString *) latitudeString
                             longitude:(NSString *) longitudeString
                                  Unit:(UnitType) unitForSearch {
    
    NSString *urlString;
    
    switch (unitForSearch) {
        case Fahrenheit:
            
            urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&APPID=%@&units=%@",latitudeString,longitudeString,kWeatherAPIKey,kFahrenheitUnit];
            
            break;
            
        case Celsius :  urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&APPID=%@&units=%@",latitudeString,longitudeString,kWeatherAPIKey,kFahrenheitUnit];
            break;
        default:
            break;
    }
    
   
    
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error : %@",error.localizedDescription);
        }
        else {
            
            if (response) {
                
                NSHTTPURLResponse *httpRepsonse = (NSHTTPURLResponse *)response;
                
                if (httpRepsonse.statusCode == 200) {
                    
                    if (data) {
                        
                        
                        NSError *error;
                        //real parsing shuru hoga
                        NSDictionary *jsonReponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                        
                        if (error) {
                            NSLog(@"JSON Parsing Error : %@",error.localizedDescription);
                        }
                        else {
                            
                            [self performSelectorOnMainThread:@selector(updateUI:) withObject:jsonReponse waitUntilDone:NO];
                            
                        }
                        
                        
                    }
                    else {
                        NSLog(@"Data nil.");
                    }
                    
                }
                else {
                    NSLog(@"HTTP Status Code : %ld",(long)httpRepsonse.statusCode);
                }
                
            }
            else {
                NSLog(@"Reponse Nil.");
            }
            
        }
        
        
    }];
    
    [dataTask resume];
    
}

-(void)updateUI:(NSDictionary *)dictionary {
    
    
    NSString *cod = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"cod"]];
    if ([cod isEqualToString:@"404"]) {
        NSLog(@"%@",[dictionary valueForKey:@"message"]);
    }
    else if ([cod isEqualToString:@"200"]){
        
        NSString *name = [dictionary valueForKeyPath:@"name"];
        NSString *country = [dictionary valueForKeyPath:@"sys.country"];

        NSString *temperature = [NSString stringWithFormat:@"%@",[dictionary valueForKeyPath:@"main.temp"]];

        NSString *minimumTemperature = [NSString stringWithFormat:@"%@",[dictionary valueForKeyPath:@"main.temp_min"]];

        NSString *maximumTemperature = [NSString stringWithFormat:@"%@",[dictionary valueForKeyPath:@"main.temp_max"]];

        NSString *pressure = [NSString stringWithFormat:@"%@",[dictionary valueForKeyPath:@"main.pressure"]];
        NSString *humidity = [NSString stringWithFormat:@"%@",[dictionary valueForKeyPath:@"main.humidity"]];

        self.labelName.text = name;
        self.labelCountry.text = country;
        self.labelTemperature.text = temperature;
        self.labelMinimumTemperature.text = minimumTemperature;
        self.labelMaximumTemperature.text = maximumTemperature;
        self.labelPressure.text = pressure;
        self.labelHumidity.text = humidity;
        
    }
    else {
        NSLog(@"%@",dictionary);
    }
}

- (IBAction)weatherInC:(id)sender {
    
    unit = Celsius;
    
    [self getUserLocation];

}

- (IBAction)weatherInF:(id)sender {
    
    unit = Fahrenheit;
    
    [self getUserLocation];
}

#pragma mark CLLocationManager Delegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *currentLocation = [locations lastObject];
    
//    CLLocationCoordinate2D currentCoordinate = currentLocation.coordinate;
//
//    CLLocationDegrees latitude = currentCoordinate.latitude;
//    CLLocationDegrees longitude = currentCoordinate.longitude;

//    CLLocationDegrees latitude = currentLocation.coordinate.latitude;
    
//    CLLocationDegrees longitude = currentLocation.coordinate.longitude;
    
    NSString *latitudeString = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    NSString *longitudeString = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    
    [locationManager stopUpdatingLocation];

    [self downloadWeatherDataWithLatitude:latitudeString longitude:longitudeString Unit:unit];
    

    
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if( error) {
        NSLog(@"ERROR : %@",error.localizedDescription);
    }
}

@end
