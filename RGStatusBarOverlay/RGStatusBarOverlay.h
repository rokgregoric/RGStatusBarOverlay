//
//  RGStatusBarOverlay.h
//
//  Created by Rok Gregorič on 11. 03. 13.
//  Copyright (c) 2013 Rok Gregorič. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RGStatusBarOverlayAnimation) {
	RGStatusBarOverlayAnimationNone = 0,
	RGStatusBarOverlayAnimationFade,
	RGStatusBarOverlayAnimationSlide,
};

@interface RGStatusBarOverlay : UIWindow

+ (void)showMessage:(NSString *)text withSpinner:(BOOL)spinner animation:(RGStatusBarOverlayAnimation)statusBarOverlayAnimation;
+ (void)showMessage:(NSString *)text withTag:(NSInteger)tag spinner:(BOOL)spinner animation:(RGStatusBarOverlayAnimation)statusBarOverlayAnimation;

+ (void)hideMessageWithAnimation:(RGStatusBarOverlayAnimation)statusBarOverlayAnimation;
+ (void)hideMessageWithTag:(NSInteger)tag animation:(RGStatusBarOverlayAnimation)statusBarOverlayAnimation;

@end
