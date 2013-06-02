//
//  UserInfoViewController.h
//  2reachme
//
//  Created by Boris Polania on 6/1/13.
//  Copyright (c) 2013 Boris Polania. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserInfoViewController;
@protocol userInfoControllerDelegate <NSObject>
@required
- (void)dismiss:(UserInfoViewController *)userInfoViewController;
@end

@interface UserInfoViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, NSURLConnectionDelegate> {
    
        __weak id <userInfoControllerDelegate> delegate;
    
    NSString *theResponse;
    NSMutableData *receivedData;
    NSURLConnection *urlConnection;
}

@property (nonatomic, weak) id <userInfoControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) IBOutlet UITextField *phoneTextField;
@property (nonatomic, strong) IBOutlet UITextField *emailTextField;

- (IBAction)closeKeyboard:(id)sender;
- (IBAction)save;

@end
