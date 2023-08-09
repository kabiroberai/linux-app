#import <UIKit/UIKit.h>

@interface KOViewController : UIViewController
@end
@implementation KOViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [UILabel new];
    label.text = @"Hello from Objective-C!";
    [self.view addSubview:label];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
    ]];
}
@end

@interface KOAppDelegate : UIResponder <UIApplicationDelegate>
@end
@implementation KOAppDelegate
@synthesize window;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [KOViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}
@end

int main(int argc, char *argv[]) {
    return UIApplicationMain(argc, argv, nil, @"KOAppDelegate");
}
