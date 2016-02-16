//
//  DetailViewController.m
//  FSInteractiveMap
//
//  Created by Arthur GUIBERT on 28/12/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import "DetailViewController.h"
#import "FSInteractiveMapView.h"

@interface DetailViewController ()

@property (nonatomic, weak) CAShapeLayer* oldClickedLayer;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item


- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem)
    {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [self configureView];
    [self initMap];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem)
    {
        self.title = self.detailItem;
        self.detailDescriptionLabel.text = @"";
    }
}


- (void)initMap
{
    if([self.detailItem isEqualToString:@"Example 1"])
    {
        [self initExample1];
    }
    else if([self.detailItem isEqualToString:@"Example 2"])
    {
        [self initExample2];
    }
    else if([self.detailItem isEqualToString:@"Example 3"])
    {
        [self initExample3];
    }

}


- (void)viewDidAppear:(BOOL)animated
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Examples
//生成随机色
-(UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 255.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 256 / 255.0 );// 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 256 / 255.0 ); //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (NSArray *)returnArray
{
    NSMutableArray *MutableArr = [NSMutableArray array];
    for (int i = 0; i < 6; i ++)
    {
        UIColor *random = [self randomColor];
        [MutableArr addObject:random];
    }
    
    return MutableArr;
}


- (void)initExample1
{
    NSDictionary* data = @{
                           @"asia" : @1,
                           @"australia" : @2,
                           @"north_america" : @3,
                           @"south_america" : @4,
                           @"africa" : @5,
                           @"europe" : @6
                           };
    
    FSInteractiveMapView* map = [[FSInteractiveMapView alloc] initWithFrame:CGRectMake(16, 96, self.view.frame.size.width - 32, self.view.frame.size.height/2)];
    
    //[map loadMap:@"world-continents-low" withData:data colorAxis:@[[self randomColor], [self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor]]];
    
    [map loadMap:@"world-continents-low" withData:data colorAxis:[self returnArray]];
    
    //点击事件
    [map setClickHandler:^(NSString* identifier, CAShapeLayer* layer)
     {
        self.detailDescriptionLabel.text = [NSString stringWithFormat:@"您点击了: %@", identifier];
    }];
    
    [self.view addSubview:map];
}


- (void)initExample2
{
    NSDictionary* data = @{
                           @"fr" : @12,
                           @"it" : @2,
                           @"de" : @9,
                           @"pl" : @24,
                           @"uk" : @17
                           };
    
    FSInteractiveMapView* map = [[FSInteractiveMapView alloc] initWithFrame:CGRectMake(-1, 64, self.view.frame.size.width + 2, 500)];
    [map loadMap:@"europe" withData:data colorAxis:@[[UIColor blueColor], [UIColor greenColor], [UIColor yellowColor], [UIColor redColor]]];
    
    [self.view addSubview:map];
}


- (void)initExample3
{
    FSInteractiveMapView* map = [[FSInteractiveMapView alloc] initWithFrame:CGRectMake(16, 96, self.view.frame.size.width - 32, 500)];
    [map loadMap:@"usa-low" withColors:nil];
    
    [map setClickHandler:^(NSString* identifier, CAShapeLayer* layer)
    {
        if(_oldClickedLayer)
        {
            _oldClickedLayer.zPosition = 0;
            _oldClickedLayer.shadowOpacity = 0;
        }
        
        _oldClickedLayer = layer;
        
        // We set a simple effect on the layer clicked to highlight it
        layer.zPosition = 10;
        layer.shadowOpacity = 0.5;
        layer.shadowColor = [UIColor blackColor].CGColor;
        layer.shadowRadius = 5;
        layer.shadowOffset = CGSizeMake(0, 0);
    }];
    
    [self.view addSubview:map];
}

@end
