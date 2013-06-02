//
//  LinkViewController.h
//  2reachme
//
//  Created by Boris Polania on 6/1/13.
//  Copyright (c) 2013 Boris Polania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "configViewController.h"

@interface LinkViewController : UIViewController <NSURLConnectionDelegate, configControllerDelegate> {
    
    
    NSString *theResponse;
    NSMutableData *receivedData;
    NSURLConnection *urlConnection;
}


@property (nonatomic, strong) IBOutlet UILabel *linkLabel;

- (IBAction)changeLink:(id)sender;
- (IBAction)config:(id)sender;

@end
