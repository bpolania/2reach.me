//
//  configViewController.h
//  2reachme
//
//  Created by Boris Polania on 6/2/13.
//  Copyright (c) 2013 Boris Polania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "configViewController.h"

@class configViewController;
@protocol configControllerDelegate <NSObject>
@required
- (void)dismiss:(configViewController *)configViewController;
@end

@interface configViewController : UIViewController <UITextFieldDelegate> {
    
    __weak id <configControllerDelegate> delegate;
}

@property (nonatomic, weak) id <configControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) IBOutlet UITextField *phoneTextField;
@property (nonatomic, strong) IBOutlet UITextField *emailTextField;

- (IBAction)closeKeyboard:(id)sender;
- (IBAction)save:(id)sender;

@end
