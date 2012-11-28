//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "HDDefaultStyleSheet.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation HDDefaultStyleSheet

- (id)init
{
    self = [super init];
    if (self) {
         [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    }
    return self;
}

-(TTStyle *)tableStatusLabelError
{    
    return
    [TTShapeStyle styleWithShape:
     [TTSpeechBubbleShape shapeWithRadius:5 pointLocation:314 pointAngle:270 pointSize:CGSizeMake(12,6)] next:
     [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(-5, 15, 0, 15) next:
      [TTLinearGradientFillStyle styleWithColor1:RGBCOLOR(204, 90, 80)
                                                color2:RGBCOLOR(132, 60, 60) next:
       [TTFourBorderStyle styleWithTop:RGBCOLOR(102, 40, 36) right:RGBCOLOR(132, 0, 0) bottom:RGBCOLOR(102, 0, 0) left:RGBCOLOR(132, 40, 36) width:1 next:
        [TTTextStyle styleWithFont:nil color:RGBCOLOR(255, 255, 255) textAlignment:UITextAlignmentLeft next:nil                                                                                                                                                                          ]]]]];
}

-(TTStyle *)tableStatusLabelDifferent
{
    return
    [TTShapeStyle styleWithShape:
     [TTSpeechBubbleShape shapeWithRadius:5 pointLocation:314 pointAngle:270 pointSize:CGSizeMake(12,6)] next:
     [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(-5, 15, 0, 15) next:
     [TTLinearGradientFillStyle styleWithColor1:RGBCOLOR(90, 204, 80)
                                                color2:RGBCOLOR(60, 132, 60) next:
      [TTFourBorderStyle styleWithTop:RGBCOLOR(40, 102, 36) right:RGBCOLOR(0, 132, 0) bottom:RGBCOLOR(0, 102, 0) left:RGBCOLOR(40, 132, 36) width:1 next:
       [TTTextStyle styleWithFont:nil color:RGBCOLOR(255, 255, 255) textAlignment:UITextAlignmentLeft next:nil
        ]]]]];
}

- (TTStyle*)confirmCellButton:(UIControlState)state {
    if (state == UIControlStateNormal) {
        return
        [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:5] next:
         [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, 0, 1, 0) next:
          [TTShadowStyle styleWithColor:RGBACOLOR(255,255,255,0) blur:1 offset:CGSizeMake(0, 1) next:
           [TTLinearGradientFillStyle styleWithColor1:RGBCOLOR(51, 51, 51)
                                               color2:RGBCOLOR(0, 0, 0) next:
            [TTSolidBorderStyle styleWithColor:RGBCOLOR(51, 51, 51) width:1 next:
             [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(10, 12, 9, 12) next:
              [TTTextStyle styleWithFont:nil color:RGBCOLOR(204, 204, 204)
                             shadowColor:[UIColor colorWithWhite:0 alpha:0.4]
                            shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
    } else if (state == UIControlStateHighlighted) {
        return
        [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:5] next:
         [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, 0, 1, 0) next:
          [TTShadowStyle styleWithColor:RGBACOLOR(255,255,255,0.9) blur:1 offset:CGSizeMake(0, 1) next:
           [TTLinearGradientFillStyle styleWithColor1:RGBCOLOR(225, 225, 225)
                                               color2:RGBCOLOR(196, 201, 221) next:
            [TTSolidBorderStyle styleWithColor:RGBCOLOR(204, 204, 204) width:1 next:
             [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(10, 12, 9, 12) next:
              [TTTextStyle styleWithFont:nil color:[UIColor blackColor]
                             shadowColor:[UIColor colorWithWhite:255 alpha:0.4]
                            shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
    } else {
        return nil;
    }
}


-(TTStyle *)timeStampLabel
{
    return
     [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(-5, 15, 0, 15) next:
        [TTTextStyle styleWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12] color:RGBCOLOR(255, 255, 255) textAlignment:UITextAlignmentCenter next:nil
         ]];
}

-(TTStyle *) functionListCellImageStyle
{
    return [TTImageStyle styleWithImageURL:nil
                              defaultImage:TTIMAGE(@"bundle://world.png")
                               contentMode:UIViewContentModeScaleToFill
                                      size:CGSizeMake(45, 45)
                                      next:nil];
}

#pragma -mark color
-(UIColor *)navigationBarTintColor
{
//    return RGBACOLOR(102, 102, 102, 0.6);
    return RGBCOLOR(51, 51, 51);
}

-(UIColor *)toolbarTintColor
{
    return RGBCOLOR(17, 17, 17);
}

-(UIColor *)postViewBackground
{
//    return RGBACOLOR(51, 51, 51,0.9);
    return RGBCOLOR(146, 176, 216);
}

-(UIColor *)searchBarTintColor
{
    return RGBACOLOR(102, 102, 102, 0.6);
}

-(UIColor *)tablePlainBackgroundColor
{
    return RGBCOLOR(245, 245, 245);
}

-(UIColor *)tableHeaderTintColor
{
//    return RGBCOLOR(51, 51, 51);
    return RGBACOLOR(0, 0, 0, 0.35);
}

-(UIColor *)tableHeaderTextColor
{
//    return RGBCOLOR(204, 204, 204);
    return RGBCOLOR(255, 255, 255);
}

-(UIColor *)splitBorderColor
{
    return RGBCOLOR(204, 204, 204);
}
@end
