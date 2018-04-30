#import "ViewController.h"

@interface ViewController ()

@property TTMapView* mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView = [[TTMapView alloc] initWithFrame:self.view.frame];
    CLLocationCoordinate2D amsterdamCoords = CLLocationCoordinate2DMake(52.377271, 4.909466);
    [self.mapView centerOnCoordinate:amsterdamCoords withZoom:11];
    self.view = self.mapView;

    //markers
    TTAnnotation *annotation = [TTAnnotation annotationWithCoordinate:amsterdamCoords];
    [self.mapView.annotationManager addAnnotation:annotation];

    //traffic
    self.mapView.trafficIncidentsStyle = TTTrafficIncidentsStyleRaster;
    self.mapView.trafficIncidentsOn = YES;
    self.mapView.trafficFlowOn = YES;

    //routing
    CLLocationCoordinate2D routeStart = CLLocationCoordinate2DMake(52.376368, 4.908113);
    CLLocationCoordinate2D routeStop = CLLocationCoordinate2DMake(52.372281, 4.846595);
    
    TTRouteQuery *routeQuery = [[[TTRouteQueryBuilder alloc] initWithDest:routeStop withOrig:routeStart] build];
    TTRoute *route = [[TTRoute alloc] init];
    [route planRouteWithQuery:routeQuery withAsyncDelegate:self];
}

- (void)route:(TTRoute *)route completedWithResult:(TTRouteResult *)result {
    for(TTFullRoute *fullRoute in result.routes) {
        TTMapRoute *mapRoute = [TTMapRoute routeWithRouteData:fullRoute];
        [self.mapView.routeManager addRoute:mapRoute];
        mapRoute.active = YES;
    }}

- (void)route:(TTRoute *)route completedWithResponseError:(TTResponseError *)responseError {
    
}

@end
