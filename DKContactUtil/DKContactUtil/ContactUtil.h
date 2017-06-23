//
//  ContactUtil.h
//  KDR
//
//  Created by Dominik Kowalski on 25/04/2017.
//  Copyright © 2017 Moveapp. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <SafariServices/SafariServices.h>
#import <MapKit/MapKit.h>

@interface ContactUtil : NSObject <MFMailComposeViewControllerDelegate, SFSafariViewControllerDelegate>
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic) UIViewController* controller;

-(instancetype)initWithViewController:(UIViewController*)controller;
-(void)sendMail:(NSString *)mail subject:(NSString *)subject body:(NSString*)body;
-(void)callNumber:(NSString*)number errorMessage:(NSString*)message;
-(void)openWebViewURL:(NSString*)url;
-(void)openMapWithQuery:(nullable NSString*) houseNumber street:(NSString*)street city:(NSString*)city;
-(void)openMapWithPoint:(NSString*)longitude latitude:(NSString*)latitude;

-(void)settingsAlertWithMessage:(NSString*)message;
NS_ASSUME_NONNULL_END
@end
