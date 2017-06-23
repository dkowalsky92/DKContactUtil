//
//  ContactUtil.m
//  KDR
//
//  Created by Dominik Kowalski on 25/04/2017.
//  Copyright © 2017 Moveapp. All rights reserved.
//

#import "ContactUtil.h"

@interface ContactUtil ()

-(BOOL)canMakeCall;

@end

@implementation ContactUtil

-(instancetype)initWithViewController:(UIViewController *)controller {
    self = [super init];
    if (self) {
        _controller = controller;
    }
    return self;
}

-(void)sendMail:(NSString *)mail subject:(NSString *)subject body:(NSString*)body {

    if(![MFMailComposeViewController canSendMail]) {
        [self settingsAlertWithMessage:@"Skonfiguruj konto, aby wysłać e-mail"];
        return;
    }
    
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    
    controller.mailComposeDelegate = self;
    [controller setToRecipients:@[mail]];
    [controller setSubject:subject];
    [controller setMessageBody:body isHTML:NO];
    [_controller presentViewController:controller animated:true completion:^{

    }];
}

-(void)openMapWithQuery:(nullable NSString*) houseNumber street:(NSString*)street city:(NSString*)city {

    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?q=%@+%@,+%@,+Polska&zoom=traffic", street, houseNumber, city]]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?address=%@+%@,+%@,+Polska", street, houseNumber, city]]];
    }
}

-(void)openMapWithPoint:(NSString*)longitude latitude:(NSString*)latitude {
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?center=%@,%@&zoom=15", latitude, longitude]]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?ll=%@,%@", latitude, longitude]]];
    }
}

-(void)callNumber:(NSString *)number errorMessage:(NSString*)message {
    if (![self canMakeCall]) {
        [self settingsAlertWithMessage:message];
        return;
    }
    NSString *phoneNumber = number;
    NSString *phoneURLString = [[NSString stringWithFormat:@"telprompt://%@", phoneNumber]stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    
    [[UIApplication sharedApplication] openURL:phoneURL];
}

-(BOOL)canMakeCall {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
        
        CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = [netInfo subscriberCellularProvider];
        NSString *mnc = [carrier mobileNetworkCode];
        if (([mnc length] == 0) || ([mnc isEqualToString:@"65535"])) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return  NO;
    }
}

-(void)openWebViewURL:(NSString *)url {
    NSURL* finalUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@", url]];

    if (url) {
        if ([SFSafariViewController class] != nil) {
            SFSafariViewController *sfvc = [[SFSafariViewController alloc] initWithURL:finalUrl];
            sfvc.delegate = self;
            [_controller presentViewController:sfvc animated:YES completion:nil];
        } else {
            if (![[UIApplication sharedApplication] openURL:finalUrl]) {
                
            }
        }
    }

}

-(void)settingsAlertWithMessage:(NSString*)message {

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil];
    
    // Nieudokumentowany crash przy otwieraniu settingsow na iOS ver. > 10.0
    // http://stackoverflow.com/questions/39792745/ios-10-open-settings-crash
    
    //    UIAlertAction* settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ustawienia", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
    //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    //    }];
    
    [alert addAction:okAction];
    
    [_controller presentViewController:alert animated:true completion:nil];
}

#pragma mark - <SFSafariViewControllerDelegate>

-(void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully {
    
}

-(void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    
}


#pragma mark - <MFMAilComposeViewControllerDelegate>

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    __block NSString* alertMessage;
    
    [controller dismissViewControllerAnimated:YES completion:^{
        switch(result) {
            case MFMailComposeResultCancelled:
                alertMessage = NSLocalizedString(@"Wysyłanie anulowane", nil);
                break;
            case MFMailComposeResultSaved:
                alertMessage = NSLocalizedString(@"Zapisano w wersjach roboczych", nil);
                break;
            case MFMailComposeResultSent:
                alertMessage = NSLocalizedString(@"Uwagi wysłane", nil);
                break;
            case MFMailComposeResultFailed:
                alertMessage = NSLocalizedString(@"Wysyłanie nie powiodło się", nil);
                break;
        }
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        
        [_controller presentViewController:alert animated:true completion:nil];
    }];
}

@end
