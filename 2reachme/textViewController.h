//
//  textViewController.h
//  2reachme
//
//  Created by Boris Polania on 6/2/13.
//  Copyright (c) 2013 Boris Polania. All rights reserved.
//

#import <UIKit/UIKit.h>

@class textViewController;
@protocol textViewControllerDelegate <NSObject>
@required
- (void)dismiss:(textViewController *)textViewController;
@end

@interface textViewController : UIViewController {
    
    NSString *fromEmail;
    NSString *fromPhone;
    
    __weak id <textViewControllerDelegate> delegate;
}

@property (nonatomic, weak) id <textViewControllerDelegate> delegate;

@property (nonatomic) NSInteger messageType;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) IBOutlet UITextView *textView;

- (IBAction) dismissTextView:(id)sender;

@end
