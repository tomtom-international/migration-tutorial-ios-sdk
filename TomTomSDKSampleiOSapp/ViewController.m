#import "ViewController.h"

static NSString *const API_KEY = @"YOUR_API_KEY";

@interface ViewController ()

@property TTMapView* mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    TTMapStyleDefaultConfiguration *style = [[TTMapStyleDefaultConfiguration alloc] init];
    TTMapConfiguration *config = [[[[[TTMapConfigurationBuilder alloc]
           withMapKey:API_KEY]
          withTrafficKey:API_KEY]
      withMapStyleConfiguration:style] build];
    self.mapView = [[TTMapView alloc] initWithFrame:self.view.frame mapConfiguration:config];

    CLLocationCoordinate2D amsterdamCoords = CLLocationCoordinate2DMake(52.377271, 4.909466);
    [self.mapView centerOnCoordinate:amsterdamCoords withZoom:11];
    self.view = self.mapView;

    //markers
    TTAnnotation *annotation = [TTAnnotation annotationWithCoordinate:amsterdamCoords];
    [self.mapView.annotationManager addAnnotation:annotation];

    //traffic
    self.mapView.trafficIncidentsOn = YES;
    self.mapView.trafficFlowOn = YES;

    //routing
    CLLocationCoordinate2D routeStart = CLLocationCoordinate2DMake(52.376368, 4.908113);
    CLLocationCoordinate2D routeStop = CLLocationCoordinate2DMake(52.372281, 4.846595);
    
    TTRouteQuery *routeQuery = [[TTRouteQueryBuilder createWithDest:routeStop andOrig:routeStart] build];
    TTRoute *route = [[TTRoute alloc] initWithKey:API_KEY];
    route.delegate = self;
    
    [self.mapView onMapReadyCompletion:^{
        [route planRouteWithQuery:routeQuery];
    }];
}

- (void)route:(TTRoute *)route completedWithResult:(TTRouteResult *)result {
    for(TTFullRoute *fullRoute in result.routes) {
        TTMapRoute *mapRoute = [TTMapRoute routeWithCoordinatesData:fullRoute
                                                     withRouteStyle:TTMapRouteStyle.defaultActiveStyle
                                                         imageStart:TTMapRoute.defaultImageDeparture
                                                           imageEnd:TTMapRoute.defaultImageDestination];
        [self.mapView.routeManager addRoute:mapRoute];
        [self.mapView.routeManager showAllRoutesOverview];
    }}

- (void)route:(TTRoute *)route completedWithResponseError:(TTResponseError *)responseError {
    
}

@end
