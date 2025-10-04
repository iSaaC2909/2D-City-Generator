#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSInteger, BuildingType) {
    BuildingTypeEmpty = 0,
    BuildingTypeResidential,
    BuildingTypeCommercial,
    BuildingTypeIndustrial,
    BuildingTypePark,
    BuildingTypeRoad
};

@interface Building : NSObject
@property (nonatomic) BuildingType type;
@property (nonatomic) NSRect frame;
@property (nonatomic, strong) NSColor *color;
@property (nonatomic) NSInteger floors;
@end

@interface Road : NSObject
@property (nonatomic) NSPoint start;
@property (nonatomic) NSPoint end;
@property (nonatomic) CGFloat width;
@end

@interface CityGenerator : NSObject

@property (nonatomic) NSInteger gridWidth;
@property (nonatomic) NSInteger gridHeight;
@property (nonatomic) CGFloat cellSize;
@property (nonatomic, strong) NSMutableArray *buildings;
@property (nonatomic, strong) NSMutableArray *roads;
@property (nonatomic, strong) NSMutableArray *parks;

- (instancetype)initWithWidth:(NSInteger)width height:(NSInteger)height cellSize:(CGFloat)cellSize;
- (void)generateCity;
- (void)generateWithSeed:(NSInteger)seed;
- (void)clearCity;

@end