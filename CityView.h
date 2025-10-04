#import <Cocoa/Cocoa.h>
#import "CityGenerator.h"

@interface CityView : NSView

@property (nonatomic, strong) CityGenerator *cityGenerator;

- (void)generateNewCity;
- (void)generateWithSeed:(NSInteger)seed;

@end