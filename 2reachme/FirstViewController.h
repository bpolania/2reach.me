//
//  FirstViewController.h
//  2reachme
//
//  Created by Boris Polania on 6/1/13.
//  Copyright (c) 2013 Boris Polania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoViewController.h"

@interface FirstViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, userInfoControllerDelegate>
@property (nonatomic, strong) IBOutlet UITextField *userTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;

- (IBAction)closeKeyboard:(id)sender;
- (IBAction)login;

@end
