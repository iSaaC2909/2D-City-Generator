#import "CityGenerator.h"

@implementation Building
- (instancetype)init {
    self = [super init];
    if (self) {
        _type = BuildingTypeEmpty;
        _floors = 1;
    }
    return self;
}

- (NSString *)description {
    NSArray *typeNames = @[@"Empty", @"Residential", @"Commercial", @"Industrial", @"Park", @"Road"];
    return [NSString stringWithFormat:@"Building: %@ Floors: %ld Frame: %@", 
            typeNames[self.type], (long)self.floors, NSStringFromRect(self.frame)];
}
@end

@implementation Road
- (NSString *)description {
    return [NSString stringWithFormat:@"Road from %@ to %@ width: %.1f", 
            NSStringFromPoint(self.start), NSStringFromPoint(self.end), self.width];
}
@end

@implementation CityGenerator

- (instancetype)initWithWidth:(NSInteger)width height:(NSInteger)height cellSize:(CGFloat)cellSize {
    self = [super init];
    if (self) {
        _gridWidth = width;
        _gridHeight = height;
        _cellSize = cellSize;
        _buildings = [NSMutableArray array];
        _roads = [NSMutableArray array];
        _parks = [NSMutableArray array];
    }
    return self;
}

- (void)generateCity {
    [self clearCity];
    [self generateRoadNetwork];
    [self generateDistricts];
    [self placeBuildings];
    [self generateParks];
}

- (void)generateWithSeed:(NSInteger)seed {
    srand((unsigned int)seed);
    [self generateCity];
}

- (void)clearCity {
    [self.buildings removeAllObjects];
    [self.roads removeAllObjects];
    [self.parks removeAllObjects];
}

- (void)generateRoadNetwork {
    // Generate main avenues
    NSInteger horizontalAvenues = 3 + arc4random_uniform(3);
    NSInteger verticalAvenues = 3 + arc4random_uniform(3);
    
    // Horizontal avenues
    for (NSInteger i = 1; i <= horizontalAvenues; i++) {
        CGFloat y = (CGFloat)i / (horizontalAvenues + 1) * self.gridHeight;
        Road *road = [[Road alloc] init];
        road.start = NSMakePoint(0, y);
        road.end = NSMakePoint(self.gridWidth, y);
        road.width = 3.0;
        [self.roads addObject:road];
    }
    
    // Vertical avenues
    for (NSInteger i = 1; i <= verticalAvenues; i++) {
        CGFloat x = (CGFloat)i / (verticalAvenues + 1) * self.gridWidth;
        Road *road = [[Road alloc] init];
        road.start = NSMakePoint(x, 0);
        road.end = NSMakePoint(x, self.gridHeight);
        road.width = 3.0;
        [self.roads addObject:road];
    }
    
    // Generate smaller streets
    for (NSInteger i = 0; i < self.gridWidth; i += 2 + arc4random_uniform(3)) {
        for (NSInteger j = 0; j < self.gridHeight; j += 2 + arc4random_uniform(3)) {
            if (arc4random_uniform(100) < 60) { // 60% chance to create a street
                if (arc4random_uniform(2) == 0) {
                    // Horizontal street
                    Road *road = [[Road alloc] init];
                    road.start = NSMakePoint(i, j);
                    road.end = NSMakePoint(i + 1 + arc4random_uniform(5), j);
                    road.width = 1.0;
                    [self.roads addObject:road];
                } else {
                    // Vertical street
                    Road *road = [[Road alloc] init];
                    road.start = NSMakePoint(i, j);
                    road.end = NSMakePoint(i, j + 1 + arc4random_uniform(5));
                    road.width = 1.0;
                    [self.roads addObject:road];
                }
            }
        }
    }
}

- (void)generateDistricts {
    // This would define different areas of the city
    // For simplicity, we'll implement basic zoning
}

- (void)placeBuildings {
    for (NSInteger x = 0; x < self.gridWidth; x++) {
        for (NSInteger y = 0; y < self.gridHeight; y++) {
            // Check if this cell is near a road
            BOOL nearRoad = [self isPointNearRoad:NSMakePoint(x, y)];
            
            if (nearRoad && arc4random_uniform(100) < 70) { // 70% build probability near roads
                Building *building = [[Building alloc] init];
                building.frame = NSMakeRect(x, y, 1, 1);
                
                // Determine building type based on position and randomness
                NSInteger roll = arc4random_uniform(100);
                if (roll < 50) {
                    building.type = BuildingTypeResidential;
                    building.floors = 1 + arc4random_uniform(5);
                    building.color = [NSColor colorWithCalibratedRed:0.7 green:0.7 blue:0.9 alpha:1.0];
                } else if (roll < 80) {
                    building.type = BuildingTypeCommercial;
                    building.floors = 2 + arc4random_uniform(8);
                    building.color = [NSColor colorWithCalibratedRed:0.9 green:0.8 blue:0.7 alpha:1.0];
                } else {
                    building.type = BuildingTypeIndustrial;
                    building.floors = 1 + arc4random_uniform(3);
                    building.color = [NSColor colorWithCalibratedRed:0.8 green:0.8 blue:0.8 alpha:1.0];
                }
                
                [self.buildings addObject:building];
            }
        }
    }
}

- (void)generateParks {
    NSInteger parkCount = 2 + arc4random_uniform(4);
    
    for (NSInteger i = 0; i < parkCount; i++) {
        NSInteger parkWidth = 3 + arc4random_uniform(4);
        NSInteger parkHeight = 3 + arc4random_uniform(4);
        NSInteger parkX = arc4random_uniform(self.gridWidth - parkWidth);
        NSInteger parkY = arc4random_uniform(self.gridHeight - parkHeight);
        
        Building *park = [[Building alloc] init];
        park.type = BuildingTypePark;
        park.frame = NSMakeRect(parkX, parkY, parkWidth, parkHeight);
        park.color = [NSColor colorWithCalibratedRed:0.4 green:0.8 blue:0.4 alpha:1.0];
        park.floors = 0;
        
        [self.parks addObject:park];
        [self.buildings addObject:park];
    }
}

- (BOOL)isPointNearRoad:(NSPoint)point {
    for (Road *road in self.roads) {
        CGFloat distance;
        if (road.start.x == road.end.x) { // Vertical road
            distance = fabs(point.x - road.start.x);
        } else { // Horizontal road
            distance = fabs(point.y - road.start.y);
        }
        
        if (distance <= 1.5) { // Within 1.5 cells of a road
            return YES;
        }
    }
    return NO;
}

@end