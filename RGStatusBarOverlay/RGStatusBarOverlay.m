//
//  RGStatusBarOverlay.m
//
//  Created by Rok Gregorič on 11. 03. 13.
//  Copyright (c) 2013 Rok Gregorič. All rights reserved.
//

#import "RGStatusBarOverlay.h"

#define BACKGROUND_COLOR [UIColor blackColor]
#define TEXT_COLOR [UIColor whiteColor]
#define TEXT_FONT [UIFont boldSystemFontOfSize:([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? 12 : 13)]
#define MAX_WIDTH UIScreen.mainScreen.bounds.size.width
#define ANIMATION_DURATION 0.3f
#define ANIMATION_OPTIONS UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction

@implementation RGStatusBarOverlay

static NSMutableArray *overlays;
static UIColor *backgroundColor;
static UIColor *textColor;

+ (void)setBackgroundColor:(UIColor *)color {
    backgroundColor = color;
}
+ (UIColor *)backgroundColor {
    return backgroundColor ?: BACKGROUND_COLOR;
}

+ (void)setTextColor:(UIColor *)color {
    textColor = color;
}
+ (UIColor *)textColor {
    return textColor ?: TEXT_COLOR;
}

+ (void)showMessage:(NSString *)text withSpinner:(BOOL)spinner animation:(RGStatusBarOverlayAnimation)statusBarOverlayAnimation {
	[RGStatusBarOverlay showMessage:text withTag:0 spinner:spinner animation:statusBarOverlayAnimation];
}

+ (void)showMessage:(NSString *)text withTag:(NSInteger)tag spinner:(BOOL)spinner animation:(RGStatusBarOverlayAnimation)statusBarOverlayAnimation {
	CGFloat width = [text boundingRectWithSize:CGSizeMake(MAX_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TEXT_FONT} context:nil].size.width;
	CGRect frame = CGRectZero;
	float text_x = 0.0f;

	frame.size = UIApplication.sharedApplication.statusBarFrame.size;

	CGSize size = CGSizeMake(ceil(width), frame.size.height);

	RGStatusBarOverlay *me = [[RGStatusBarOverlay alloc] initWithFrame:frame];
	me.backgroundColor = self.backgroundColor;
	me.windowLevel = UIWindowLevelStatusBar + 1.0f;
	me.hidden = NO;
	me.tag = tag;

	if (!overlays) {
		overlays = [[NSMutableArray alloc] init];
	}
	[overlays addObject:me];

	UIView *contentView = [[UIView alloc] initWithFrame:me.bounds];
	contentView.backgroundColor = self.backgroundColor;

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
	label.backgroundColor = self.backgroundColor;
	label.textColor = self.textColor;
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
