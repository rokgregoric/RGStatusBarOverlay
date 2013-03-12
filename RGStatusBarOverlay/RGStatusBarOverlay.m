//
//  RGStatusBarOverlay.m
//
//  Created by Rok Gregorič on 11. 03. 13.
//  Copyright (c) 2013 Rok Gregorič. All rights reserved.
//

#import "RGStatusBarOverlay.h"

#define TEXT_FONT [UIFont boldSystemFontOfSize:13]
#define MAX_WIDTH 320.0f
#define ANIMATION_DURATION 0.3f
#define ANIMATION_OPTIONS UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction


@implementation RGStatusBarOverlay

static NSMutableArray *overlays;

+ (void)showMessage:(NSString *)text withSpinner:(BOOL)spinner animation:(RGStatusBarOverlayAnimation)statusBarOverlayAnimation {
	[RGStatusBarOverlay showMessage:text withTag:0 spinner:spinner animation:statusBarOverlayAnimation];
}

+ (void)showMessage:(NSString *)text withTag:(NSInteger)tag spinner:(BOOL)spinner animation:(RGStatusBarOverlayAnimation)statusBarOverlayAnimation {
	CGSize size = [text sizeWithFont:TEXT_FONT forWidth:MAX_WIDTH lineBreakMode:NSLineBreakByTruncatingMiddle];
	CGRect frame = CGRectZero;
	float text_x = 0.0f;

	frame.size = UIApplication.sharedApplication.statusBarFrame.size;

	size.height = frame.size.height;

	// on iPad hide only the middle section
	if (frame.size.width > MAX_WIDTH) {
		frame.origin.x = (frame.size.width - MAX_WIDTH) / 2;
		frame.size.width = MAX_WIDTH;
	}

	RGStatusBarOverlay *me = [[RGStatusBarOverlay alloc] initWithFrame:frame];
	me.backgroundColor = UIColor.blackColor;
	me.windowLevel = UIWindowLevelStatusBar + 1.0f;
	me.hidden = NO;
	me.tag = tag;

	if (!overlays) {
		overlays = [[NSMutableArray alloc] init];
	}
	[overlays addObject:me];

	UIView *contentView = [[UIView alloc] initWithFrame:me.bounds];
	contentView.backgroundColor = [UIColor blackColor];

	// if message wider then frame, make it shorter
	if (size.width > MAX_WIDTH) {
		size.width = MAX_WIDTH;
	}

	text_x = (frame.size.width - size.width) / 2;

	if (spinner) {
		UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		// if message with activity wider then frame, make the message shorter
		if (size.width > MAX_WIDTH - activity.frame.size.width) {
			size.width = MAX_WIDTH - activity.frame.size.width;
		}
		text_x += activity.frame.size.width / 2;
		activity.frame = CGRectMake(text_x - activity.frame.size.width, 0.0f, activity.frame.size.width, activity.frame.size.height);
		activity.transform = CGAffineTransformMakeScale(0.7, 0.7);
		[activity startAnimating];
		[contentView addSubview:activity];
	}

	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(text_x, 0.0f, size.width, size.height)];
	label.backgroundColor = [UIColor blackColor];
	label.textColor = [UIColor whiteColor];
	label.font = TEXT_FONT;
	label.text = text;
	[contentView addSubview:label];

	[me addSubview:contentView];
	if (statusBarOverlayAnimation == RGStatusBarOverlayAnimationSlide) {
		me.center = CGPointMake(me.center.x, - me.frame.size.height / 2);
	} else {
		me.alpha = 0.0f;
	}

	// show animation
	float duration = statusBarOverlayAnimation == RGStatusBarOverlayAnimationNone ? 0 : ANIMATION_DURATION;
	[UIView animateWithDuration:duration delay:0.0f options:ANIMATION_OPTIONS animations:^{
		if (statusBarOverlayAnimation == RGStatusBarOverlayAnimationSlide) {
			me.center = CGPointMake(me.center.x, me.frame.size.height / 2);
		} else {
			me.alpha = 1.0f;
		}
	} completion:^(BOOL finished) {}];
}


+ (void)hideMessageWithAnimation:(RGStatusBarOverlayAnimation)statusBarOverlayAnimation {
	[RGStatusBarOverlay hideMessageWithTag:0 animation:statusBarOverlayAnimation];
}

+ (void)hideMessageWithTag:(NSInteger)tag animation:(RGStatusBarOverlayAnimation)statusBarOverlayAnimation {
	RGStatusBarOverlay *me;
	for (RGStatusBarOverlay *overlay in overlays) {
		if (overlay.tag == tag) {
			me = overlay;
			[overlays removeObject:me];
			break;
		}
	}

	if (!me) return;

	// hide animation
	float duration = statusBarOverlayAnimation == RGStatusBarOverlayAnimationNone ? 0 : ANIMATION_DURATION;
	[UIView animateWithDuration:duration delay:0.0f options:ANIMATION_OPTIONS animations:^{
		if (statusBarOverlayAnimation == RGStatusBarOverlayAnimationSlide) {
			me.center = CGPointMake(me.center.x, - me.frame.size.height / 2);
		} else {
			me.alpha = 0.0f;
		}
	} completion:^(BOOL finished) {
		[me removeFromSuperview];
	}];
}

@end
