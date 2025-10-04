#import "CityView.h"

@implementation CityView

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        _cityGenerator = [[CityGenerator alloc] initWithWidth:50 height:50 cellSize:10.0];
        [_cityGenerator generateCity];
    }
    return self;
}

- (void)generateNewCity {
    [self.cityGenerator generateCity];
    [self setNeedsDisplay:YES];
}

- (void)generateWithSeed:(NSInteger)seed {
    [self.cityGenerator generateWithSeed:seed];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Draw background
    [[NSColor colorWithCalibratedRed:0.1 green:0.1 blue:0.2 alpha:1.0] setFill];
    NSRectFill(dirtyRect);
    
    CGFloat scale = MIN(NSWidth(self.bounds) / self.cityGenerator.gridWidth, 
                       NSHeight(self.bounds) / self.cityGenerator.gridHeight);
    
    // Draw roads
    [[NSColor grayColor] setStroke];
    for (Road *road in self.cityGenerator.roads) {
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path setLineWidth:road.width * scale * 0.8];
        [path moveToPoint:NSMakePoint(road.start.x * scale, road.start.y * scale)];
        [path lineToPoint:NSMakePoint(road.end.x * scale, road.end.y * scale)];
        [path stroke];
    }
    
    // Draw parks first (as background)
    for (Building *park in self.cityGenerator.parks) {
        [park.color setFill];
        NSRect parkRect = NSMakeRect(park.frame.origin.x * scale, 
                                   park.frame.origin.y * scale,
                                   park.frame.size.width * scale, 
                                   park.frame.size.height * scale);
        NSBezierPath *parkPath = [NSBezierPath bezierPathWithRect:parkRect];
        [parkPath fill];
        
        // Park border
        [[NSColor colorWithCalibratedRed:0.3 green:0.6 blue:0.3 alpha:1.0] setStroke];
        [parkPath stroke];
    }
    
    // Draw buildings
    for (Building *building in self.cityGenerator.buildings) {
        if (building.type == BuildingTypePark) continue; // Already drawn
        
        [building.color setFill];
        NSRect buildingRect = NSMakeRect(building.frame.origin.x * scale, 
                                       building.frame.origin.y * scale,
                                       building.frame.size.width * scale, 
                                       building.frame.size.height * scale);
        
        NSBezierPath *buildingPath = [NSBezierPath bezierPathWithRect:buildingRect];
        [buildingPath fill];
        
        // Draw building details (windows, etc.)
        [[NSColor blackColor] setStroke];
        [buildingPath setLineWidth:1.0];
        [buildingPath stroke];
        
        // Draw windows for multi-story buildings
        if (building.floors > 1) {
            [[NSColor yellowColor] setFill];
            CGFloat windowSize = scale * 0.2;
            CGFloat spacing = scale * 0.3;
            
            for (NSInteger floor = 0; floor < building.floors && floor < 5; floor++) {
                for (CGFloat x = buildingRect.origin.x + spacing; x < buildingRect.origin.x + buildingRect.size.width - windowSize; x += spacing) {
                    NSRect windowRect = NSMakeRect(x, buildingRect.origin.y + spacing + (floor * spacing), windowSize, windowSize);
                    NSRectFill(windowRect);
                }
            }
        }
    }
}

- (void)mouseDown:(NSEvent *)event {
    [self generateNewCity];
}

@end