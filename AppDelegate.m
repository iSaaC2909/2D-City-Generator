#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSRect frame = NSMakeRect(100, 100, 800, 600);
    
    self.window = [[NSWindow alloc] initWithContentRect:frame
                                              styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable
                                                backing:NSBackingStoreBuffered
                                                  defer:NO];
    
    self.cityView = [[CityView alloc] initWithFrame:frame];
    
    // Create controls
    NSView *contentView = self.window.contentView;
    NSRect cityFrame = NSMakeRect(0, 50, NSWidth(frame), NSHeight(frame) - 50);
    self.cityView.frame = cityFrame;
    self.cityView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    
    [contentView addSubview:self.cityView];
    
    // Create control panel
    NSView *controlView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, NSWidth(frame), 50)];
    controlView.autoresizingMask = NSViewWidthSizable;
    
    NSButton *generateButton = [[NSButton alloc] initWithFrame:NSMakeRect(20, 10, 120, 30)];
    [generateButton setTitle:@"Generate City"];
    [generateButton setTarget:self.cityView];
    [generateButton setAction:@selector(generateNewCity)];
    
    NSButton *seedButton = [[NSButton alloc] initWithFrame:NSMakeRect(150, 10, 120, 30)];
    [seedButton setTitle:@"Generate with Seed"];
    [seedButton setTarget:self];
    [seedButton setAction:@selector(generateWithSeed)];
    
    [controlView addSubview:generateButton];
    [controlView addSubview:seedButton];
    [contentView addSubview:controlView];
    
    [self.window setTitle:@"Procedural City Generator"];
    [self.window makeKeyAndOrderFront:nil];
}

- (void)generateWithSeed {
    NSInteger seed = arc4random_uniform(10000);
    [self.cityView generateWithSeed:seed];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end