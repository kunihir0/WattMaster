#import "WattMasterSettingsViewController.h"

#define PREFS_ID @"com.kunihir0.wattmaster"

@interface WattMasterSettingsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSUserDefaults *prefs;
@end

@implementation WattMasterSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.prefs = [[NSUserDefaults alloc] initWithSuiteName:PREFS_ID];

    self.sections = @[
        @{
            @"title": @"Ads",
            @"cells": @[
                @{@"title": @"Disable All Ads", @"key": @"disableAllAds"},
                @{@"title": @"Disable Ad Server", @"key": @"disableAdServer"},
                @{@"title": @"Disable Interstitials", @"key": @"disableInterstitials"},
                @{@"title": @"Disable Story Details Ads", @"key": @"disableStoryDetailsAds"},
                @{@"title": @"Disable Library Ads", @"key": @"disableLibraryAds"},
                @{@"title": @"Disable Discover Ads", @"key": @"disableDiscoverAds"},
                @{@"title": @"Disable Reading List Ads", @"key": @"disableReadingListDetailsAds"}
            ]
        },
        @{
            @"title": @"Mocks & Testing",
            @"cells": @[
                @{@"title": @"Mock Wattpad Premium", @"key": @"mockWattpadPremium"},
                @{@"title": @"Use Staging Server", @"key": @"useStagingServer"},
                @{@"title": @"Mock Interstitial Responses", @"key": @"mockInterstitialResponses"},
                @{@"title": @"Mock Sponsored Content", @"key": @"mockSponsoredContent"},
                @{@"title": @"Display Ad in Interstitials", @"key": @"displayAdInInterstitials"},
                @{@"title": @"Display Native Ad in Interstitials", @"key": @"displayNativeAdInInterstitials"}
            ]
        },
        @{
            @"title": @"UI & Debugging",
            @"cells": @[
                @{@"title": @"Enable Debug Overlay", @"key": @"enableDebuggingInformationOverlay"},
                @{@"title": @"Enable Ads Debug Overlay", @"key": @"enableDebugAdsOverlay"},
                @{@"title": @"Story Info Debug Mode", @"key": @"storyInfoViewDebugMode"}
            ]
        }
    ];
    
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"WattMaster Settings";
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissViewController)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sections[section][@"cells"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sections[section][@"title"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingCell"];
    }
    
    NSDictionary *setting = self.sections[indexPath.section][@"cells"][indexPath.row];
    cell.textLabel.text = setting[@"title"];
    
    UISwitch *toggle = [[UISwitch alloc] init];
    [toggle setOn:[self.prefs boolForKey:setting[@"key"]]];
    [toggle addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
    
    cell.accessoryView = toggle;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)switchToggled:(UISwitch *)sender {
    CGPoint switchPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:switchPosition];
    
    if (indexPath) {
        NSDictionary *setting = self.sections[indexPath.section][@"cells"][indexPath.row];
        NSString *key = setting[@"key"];
        
        [self.prefs setBool:sender.isOn forKey:key];
        [self.prefs synchronize];
    }
}

@end