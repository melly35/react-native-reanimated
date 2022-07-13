#import <Foundation/Foundation.h>
#import <RNReanimated/REACoreAnimationLayer.h>
#import <RNReanimated/REACoreAnimationWrapper.h>

@implementation REACoreAnimationWrapper {
  REACoreAnimationLayer *_layer;
}

- (instancetype)initWithAnimation:(nonnull CABasicAnimation *)animation
{
  self = [super init];

  _value = [animation.fromValue floatValue];
  _running = YES;

  animation.keyPath = @"value";
  animation.delegate = self;
  // animation.removedOnCompletion = YES;

  _layer = [REACoreAnimationLayer layer];
  _layer.frame = CGRectMake(0, -1, 1, 1);
  _layer.value = [animation.toValue floatValue]; // fixes zero progress issue for some number of final frames
  _layer.delegate = self;

  [_layer addAnimation:animation forKey:@"value"];

  UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
  [keyWindow.layer addSublayer:_layer];

  return self;
}

- (void)dealloc
{
  [_layer removeAnimationForKey:@"value"];
  [_layer removeFromSuperlayer];
}

- (void)valueDidChange:(CGFloat)value
{
  _value = value;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
  _running = NO;
}

@end