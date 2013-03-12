//
//  ViewController.m
//  RGStatusBarOverlayExample
//
//  Created by Rok Gregorič on 11. 03. 13.
//  Copyright (c) 2013 Rok Gregorič. All rights reserved.
//

#import "ViewController.h"
#import "RGStatusBarOverlay.h"


@implementation ViewController

- (IBAction)animateNone:(UIButton *)sender {
	sender.tag = (sender.tag + 1) % 2;
	if (sender.tag) {
		[RGStatusBarOverlay showMessage:@"No animation" withSpinner:NO animation:RGStatusBarOverlayAnimationNone];
	} else {
		[RGStatusBarOverlay hideMessageWithAnimation:RGStatusBarOverlayAnimationNone];
	}
}

- (IBAction)animateFade:(UIButton *)sender {
	sender.tag = (sender.tag + 1) % 2;
	if (sender.tag) {
		[RGStatusBarOverlay showMessage:@"Fade animation" withTag:1 spinner:NO animation:RGStatusBarOverlayAnimationFade];
	} else {
		[RGStatusBarOverlay hideMessageWithTag:1 animation:RGStatusBarOverlayAnimationFade];
	}
}

- (IBAction)animateSlide:(UIButton *)sender {
	sender.tag = (sender.tag + 1) % 2;
	if (sender.tag) {
		[RGStatusBarOverlay showMessage:@"Slide animation" withTag:2 spinner:YES animation:RGStatusBarOverlayAnimationSlide];
	} else {
		[RGStatusBarOverlay hideMessageWithTag:2 animation:RGStatusBarOverlayAnimationSlide];
	}
}

@end
