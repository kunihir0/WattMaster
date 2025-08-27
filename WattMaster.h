#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DeveloperOptionsState : NSObject
@property (nonatomic) bool useStagingServer;
@property (nonatomic) bool mockInterstitialResponses;
@property (nonatomic) bool mockSponsoredContent;
@property (nonatomic) bool disableAdServer;
@property (nonatomic) bool displayAdInInterstitials;
@property (nonatomic) bool displayNativeAdInInterstitials;
@property (nonatomic) bool mockWattpadPremium;
@property (nonatomic) bool enableDebuggingInformationOverlay;
@property (nonatomic) bool disableAllAds;
@property (nonatomic) bool disableInterstitials;
@property (nonatomic) bool disableStoryDetailsAds;
@property (nonatomic) bool disableReadingListDetailsAds;
@property (nonatomic) bool disableDiscoverAds;
@property (nonatomic) bool disableLibraryAds;
@property (nonatomic) bool storyInfoViewDebugMode;
@property (nonatomic) bool enableDebugAdsOverlay;
@end


// We need this protocol definition because the class references it
@protocol _TtP7Wattpad32WPSettingsViewControllerDelegate_<NSObject>
- (void)settingsViewControllerDidRequestClose:(id)v1 completion:(void (^)(void))v2;
@end

// The full interface for the settings view controller
@interface _TtC7Wattpad24WPSettingsViewController : UIViewController
@property (nonatomic) NSObject<_TtP7Wattpad32WPSettingsViewControllerDelegate_> * delegate;
@property (nonatomic,retain) id dependencyContainer; // It's good practice to add all known properties
@property (nonatomic,retain) id sections;
@property (nonatomic,retain) UITableView * tableView;
@property (nonatomic,retain) id worksRepository;
@property (nonatomic,retain) NSTimer * appVersionSelectionTimer;
@property (nonatomic) unsigned long long appVersionSelectionCount;
@property (nonatomic) bool adOptionsEnabled;
@property (nonatomic) bool isEligibleForCancelOffer;
- (void)viewDidLoad;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
// You can add other methods here if you need them, but for now this is enough.
@end
@interface _TtC7Wattpad25UserProfileViewController : UIViewController
- (void)viewDidLoad;
@end