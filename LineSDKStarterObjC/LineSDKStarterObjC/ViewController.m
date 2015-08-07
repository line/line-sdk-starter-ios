//
//  ViewController.m
//  LineSDKStarterObjC
//
//  Copyright (c) 2015 Line corp. All rights reserved.
//

#import "ViewController.h"
#import <LineAdapter/LineAdapter.h>
#import <LineAdapterUI/LineAdapterUI.h>

@interface ViewController ()

@end

@implementation ViewController {
    LineAdapter *adapter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    adapter = [LineAdapter adapterWithConfigFile];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authorizationDidChange:) name:LineAdapterAuthorizationDidChangeNotification object:nil];
}

- (IBAction)loginWithLine:(id)sender {
    if (adapter.isAuthorized) {
        [self alert:@"Already authorized" message:nil];
        return;
    }

    if (!adapter.canAuthorizeUsingLineApp) {
        [self alert:@"LINE is not installed" message:nil];
        return;
    }

    [adapter authorize];
}

- (IBAction)loginInApp:(id)sender {
    if (adapter.isAuthorized) {
        [self alert:@"Already authorized" message:nil];
        return;
    }
    LineAdapterWebViewController *viewController = [[LineAdapterWebViewController alloc] initWithAdapter:adapter withWebViewOrientation:kOrientationAll];
    viewController.navigationItem.leftBarButtonItem = [LineAdapterNavigationController barButtonItemWithTitle:@"Cancel" target:self action:@selector(cancel:)];
    LineAdapterNavigationController *navigationController = [[LineAdapterNavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];

}

- (IBAction)tryApi:(id)sender {
    if (!adapter.isAuthorized) {
        [self alert:@"Login first!" message:nil];
        return;
    }

    [adapter.getLineApiClient getMyProfileWithResultBlock:^(NSDictionary *aResult, NSError *aError) {
        if (aError) {
            [self alert:@"Error occured!" message: aError.localizedDescription];
            return;
        }

        NSString *displayName = aResult[@"displayName"];
        [self alert:[NSString stringWithFormat:@"Your name is %@", displayName] message:nil];
    }];
}

- (IBAction)logout:(id)sender {
    [adapter unauthorize];
    [self alert:@"Logged out" message:nil];
}

- (void)alert:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Handle Notification

- (void)authorizationDidChange:(NSNotification *)notification {
    LineAdapter *lineAdapter = notification.object;
    if (lineAdapter.isAuthorized) {
        [self alert:@"Login success!" message:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }

    NSError *error = notification.userInfo[@"error"];
    if (error) {
        [self alert:@"Login error!" message:error.localizedDescription];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
