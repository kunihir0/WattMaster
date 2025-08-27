#import "WattMaster.h"
#import <HBLog.h>
#import "WattMasterSettingsViewController.h"

#define PREFS_ID @"com.kunihir0.wattmaster"

// --- Helper functions ---
static UIWindow* getFrontmostWindow() {
    UIWindow *frontmostWindow = nil;
    if (@available(iOS 13.0, *)) {
        NSSet<UIScene *> *scenes = [UIApplication sharedApplication].connectedScenes;
        for (UIScene *scene in scenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                if (@available(iOS 15.0, *)) {
                    frontmostWindow = windowScene.keyWindow;
                } else {
                    for (UIWindow *window in windowScene.windows) {
                        if (window.isKeyWindow) {
                            frontmostWindow = window;
                            break;
                        }
                    }
                }
                if (frontmostWindow) break;
            }
        }
    }
    
    if (!frontmostWindow) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        frontmostWindow = [UIApplication sharedApplication].keyWindow;
        #pragma clang diagnostic pop
    }
    return frontmostWindow;
}

static UIViewController* getTopMostViewController() {
    UIViewController *topController = getFrontmostWindow().rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}


// --- Hook for developer options ---
%hook DeveloperOptionsState
- (id)init {
    HBLogDebug(@"[WattMaster] - Reading all developer settings...");
    self = %orig;
    if (self) {
        NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:PREFS_ID];
        
        // Ads Section
        self.disableAllAds = [prefs boolForKey:@"disableAllAds"];
        self.disableAdServer = [prefs boolForKey:@"disableAdServer"];
        self.disableInterstitials = [prefs boolForKey:@"disableInterstitials"];
        self.disableStoryDetailsAds = [prefs boolForKey:@"disableStoryDetailsAds"];
        self.disableLibraryAds = [prefs boolForKey:@"disableLibraryAds"];
        self.disableDiscoverAds = [prefs boolForKey:@"disableDiscoverAds"];
        self.disableReadingListDetailsAds = [prefs boolForKey:@"disableReadingListDetailsAds"];
        
        // Mocks & Testing Section
        self.mockWattpadPremium = [prefs boolForKey:@"mockWattpadPremium"];
        self.useStagingServer = [prefs boolForKey:@"useStagingServer"];
        self.mockInterstitialResponses = [prefs boolForKey:@"mockInterstitialResponses"];
        self.mockSponsoredContent = [prefs boolForKey:@"mockSponsoredContent"];
        self.displayAdInInterstitials = [prefs boolForKey:@"displayAdInInterstitials"];
        self.displayNativeAdInInterstitials = [prefs boolForKey:@"displayNativeAdInInterstitials"];
        
        // UI & Debugging Section
        self.enableDebuggingInformationOverlay = [prefs boolForKey:@"enableDebuggingInformationOverlay"];
        self.enableDebugAdsOverlay = [prefs boolForKey:@"enableDebugAdsOverlay"];
        self.storyInfoViewDebugMode = [prefs boolForKey:@"storyInfoViewDebugMode"];
    }
    return self;
}
%end


// --- A dedicated class to handle the gesture ---
@interface WattMasterGestureHandler : NSObject
+ (void)handleLongPress:(UILongPressGestureRecognizer *)sender;
@end

@implementation WattMasterGestureHandler
+ (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        HBLogDebug(@"[WattMaster] Long press gesture recognized!");

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"WattMaster" message:@"Tweak is active." preferredStyle:UIAlertControllerStyleActionSheet];

        UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            WattMasterSettingsViewController *settingsVC = [[WattMasterSettingsViewController alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsVC];
            [getTopMostViewController() presentViewController:navController animated:YES completion:nil];
        }];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

        [alert addAction:settingsAction];
        [alert addAction:cancelAction];

        [getTopMostViewController() presentViewController:alert animated:YES completion:nil];
    }
}
@end


// --- Toast Notification ---
void showToast() {
    UIWindow *frontmostWindow = getFrontmostWindow();
    if (!frontmostWindow) return;

    UIView *toastView = [[UIView alloc] initWithFrame:CGRectMake(0, -120, frontmostWindow.frame.size.width, 120)];
    toastView.backgroundColor = [UIColor systemGreenColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:toastView.bounds];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    label.text = @"WattMaster Loaded\n(2-finger press & hold for settings)";
    [toastView addSubview:label];

    [frontmostWindow addSubview:toastView];

    [UIView animateWithDuration:0.5 animations:^{
        toastView.transform = CGAffineTransformMakeTranslation(0, 120);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:3.0 options:0 animations:^{
            toastView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [toastView removeFromSuperview];
        }];
    }];
}


// --- Hook UIWindow to add the gesture and show the toast ---
%hook UIWindow

- (id)initWithFrame:(CGRect)frame {
    id instance = %orig;

    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:[WattMasterGestureHandler class] action:@selector(handleLongPress:)];
    longPressGesture.numberOfTouchesRequired = 2;
    longPressGesture.minimumPressDuration = 0.5;
    [instance addGestureRecognizer:longPressGesture];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            showToast();
        });
    });

    return instance;
}

%end