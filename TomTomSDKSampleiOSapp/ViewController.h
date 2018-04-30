#import <UIKit/UIKit.h>
#import <TomTomOnlineSDKMaps/TomTomOnlineSDKMaps.h>
#import <TomTomOnlineSDKRouting/TomTomOnlineSDKRouting.h>

@interface ViewController : UIViewController <TTRouteResponseDelegate>

- (void)route:(TTRoute *)route completedWithResult:(TTRouteResult *)result;
- (void)route:(TTRoute *)route completedWithResponseError:(TTResponseError *)responseError;

@end

