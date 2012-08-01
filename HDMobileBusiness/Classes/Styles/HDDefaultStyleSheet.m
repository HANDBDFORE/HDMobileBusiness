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

#pragma button style
- (TTStyle*)blackForwardButton:(UIControlState)state {
    TTShape* shape = [TTRoundedRightArrowShape shapeWithRadius:4.5];
    UIColor* tintColor = RGBCOLOR(0, 0, 0);
    return [TTSTYLESHEET toolbarButtonForState:state shape:shape tintColor:tintColor font:nil];
}

-(TTStyle *)tableStatusLabelError
{    
    return [TTShapeStyle styleWithShape:
            [TTSpeechBubbleShape shapeWithRadius:5 pointLocation:314 pointAngle:270 pointSize:CGSizeMake(12,6)] next:
            [TTLinearGradientFillStyle styleWithColor1:RGBCOLOR(204, 90, 80)
                                                color2:RGBCOLOR(132, 60, 60) next:
             [TTFourBorderStyle styleWithTop:RGBCOLOR(102, 40, 36) right:RGBCOLOR(132, 0, 0) bottom:RGBCOLOR(102, 0, 0) left:RGBCOLOR(132, 40, 36) width:1 next:
              [TTTextStyle styleWithFont:nil color:RGBCOLOR(255, 255, 255) textAlignment:UITextAlignmentCenter next:nil                                                                                                                                                                          ]]]];
}

-(TTStyle *)tableStatusLabelDifferent
{
    return [TTShapeStyle styleWithShape:
            [TTSpeechBubbleShape shapeWithRadius:5 pointLocation:314 pointAngle:270 pointSize:CGSizeMake(12,6)] next:
            [TTLinearGradientFillStyle styleWithColor1:RGBCOLOR(90, 204, 80)
                                                color2:RGBCOLOR(60, 132, 60) next:
             [TTFourBorderStyle styleWithTop:RGBCOLOR(40, 102, 36) right:RGBCOLOR(0, 132, 0) bottom:RGBCOLOR(0, 102, 0) left:RGBCOLOR(40, 132, 36) width:1 next:
              [TTTextStyle styleWithFont:nil color:RGBCOLOR(255, 255, 255) textAlignment:UITextAlignmentLeft next:nil                                                                                                                                                                          ]]]];
}

- (TTStyle*)blueToolbarButton:(UIControlState)state {
    TTShape* shape = [TTRoundedRectangleShape shapeWithRadius:4.5];
    UIColor* tintColor = RGBCOLOR(30, 110, 255);
    return [TTSTYLESHEET toolbarButtonForState:state shape:shape tintColor:tintColor font:nil];
}

- (TTStyle*)embossedButton:(UIControlState)state {
    if (state == UIControlStateNormal) {
        return
        [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:8] next:
         [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, 0, 1, 0) next:
          [TTShadowStyle styleWithColor:RGBACOLOR(255,255,255,0) blur:1 offset:CGSizeMake(0, 1) next:
           [TTLinearGradientFillStyle styleWithColor1:RGBCOLOR(255, 255, 255)
                                               color2:RGBCOLOR(216, 221, 231) next:
            [TTSolidBorderStyle styleWithColor:RGBCOLOR(161, 167, 178) width:1 next:
             [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(10, 12, 9, 12) next:
              [TTTextStyle styleWithFont:nil color:TTSTYLEVAR(linkTextColor)
                             shadowColor:[UIColor colorWithWhite:255 alpha:0.4]
                            shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
    } else if (state == UIControlStateHighlighted) {
        return
        [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:8] next:
         [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, 0, 1, 0) next:
          [TTShadowStyle styleWithColor:RGBACOLOR(255,255,255,0.9) blur:1 offset:CGSizeMake(0, 1) next:
           [TTLinearGradientFillStyle styleWithColor1:RGBCOLOR(225, 225, 225)
                                               color2:RGBCOLOR(196, 201, 221) next:
            [TTSolidBorderStyle styleWithColor:RGBCOLOR(161, 167, 178) width:1 next:
             [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(10, 12, 9, 12) next:
              [TTTextStyle styleWithFont:nil color:[UIColor whiteColor]
                             shadowColor:[UIColor colorWithWhite:255 alpha:0.4]
                            shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
    } else {
        return nil;
    }
}

- (TTStyle*)dropButton:(UIControlState)state {
    if (state == UIControlStateNormal) {
        return
        [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:8] next:
         [TTShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.7) blur:3 offset:CGSizeMake(2, 2) next:
          [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0.25, 0.25, 0.25, 0.25) next:
           [TTSolidFillStyle styleWithColor:[UIColor whiteColor] next:
            [TTInsetStyle styleWithInset:UIEdgeInsetsMake(-0.25, -0.25, -0.25, -0.25) next:
             [TTSolidBorderStyle styleWithColor:RGBCOLOR(161, 167, 178) width:1 next:
              [TTInsetStyle styleWithInset:UIEdgeInsetsMake(2, 0, 0, 0) next:
               [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(11, 10, 9, 10) next:
                [TTTextStyle styleWithFont:nil color:TTSTYLEVAR(linkTextColor)
                               shadowColor:[UIColor colorWithWhite:255 alpha:0.4]
                              shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]]]];
    } else if (state == UIControlStateHighlighted) {
        return
        [TTInsetStyle styleWithInset:UIEdgeInsetsMake(3, 3, 0, 0) next:
         [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:8] next:
          [TTSolidFillStyle styleWithColor:[UIColor whiteColor] next:
           [TTSolidBorderStyle styleWithColor:RGBCOLOR(161, 167, 178) width:1 next:
            [TTInsetStyle styleWithInset:UIEdgeInsetsMake(2, 0, 0, 0) next:
             [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(11, 10, 9, 10) next:
              [TTTextStyle styleWithFont:nil color:TTSTYLEVAR(linkTextColor)
                             shadowColor:[UIColor colorWithWhite:255 alpha:0.4]
                            shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
    } else {
        return nil;
    }
}

//-(UIColor *)navigationBarTintColor
//{
//    return RGBACOLOR(51, 51, 51,0.6);
//}

//-(UIColor *)toolbarTintColor
//{
//    return RGBACOLOR(51, 51, 51,0.6);
//}

-(UIColor *)postViewBackground
{
//    return RGBACOLOR(51, 51, 51,0.9);
    return RGBCOLOR(146, 176, 216);
}

//-(UIColor *)searchBarTintColor
//{
//    return RGBACOLOR(102, 102, 102, 0.6);
//}
@end
