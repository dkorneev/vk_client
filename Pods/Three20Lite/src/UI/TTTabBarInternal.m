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

#import "TTTabBarInternal.h"

// Core
#import "TTCorePreprocessorMacros.h"

// UI
#import "TTTab.h"
#import "UIViewAdditions.h"

        CGFloat   kTabMargin      = 10.0f;
const   NSInteger kMaxBadgeNumber = 99.0f;
static  CGFloat   kPadding        = 10.0f;


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
TT_FIX_CATEGORY_BUG(TTTabBarInternal)

@implementation TTTabBar (TTInternal)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)layoutTabs {
  CGFloat x = kTabMargin;

  if (self.contentMode == UIViewContentModeScaleToFill) {
    CGFloat maxTextWidth = self.width - (kTabMargin*2 + kPadding*2*_tabViews.count);
    CGFloat totalTextWidth = 0.0f;
    CGFloat totalTabWidth = kTabMargin*2;
    CGFloat maxTabWidth = 0.0f;
    for (int i = 0; i < _tabViews.count; ++i) {
      TTTab* tab = [_tabViews objectAtIndex:i];
      [tab sizeToFit];
      totalTextWidth += tab.width - kPadding*2;
      totalTabWidth += tab.width;
      if (tab.width > maxTabWidth) {
        maxTabWidth = tab.width;
      }
    }

    if (totalTextWidth > maxTextWidth) {
      CGFloat shrinkFactor = maxTextWidth/totalTextWidth;
      for (int i = 0; i < _tabViews.count; ++i) {
        TTTab* tab = [_tabViews objectAtIndex:i];
        CGFloat textWidth = tab.width - kPadding*2;
        tab.frame = CGRectMake(x, 0, ceil(textWidth * shrinkFactor) + kPadding*2 , self.height);
        x += tab.width;
      }

    } else {
      CGFloat averageTabWidth = ceil((self.width - kTabMargin*2)/_tabViews.count);
      if (maxTabWidth > averageTabWidth && self.width - totalTabWidth < kTabMargin) {
        for (int i = 0; i < _tabViews.count; ++i) {
          TTTab* tab = [_tabViews objectAtIndex:i];
          tab.frame = CGRectMake(x, 0, tab.width, self.height);
          x += tab.width;
        }

      } else {
        for (int i = 0; i < _tabViews.count; ++i) {
          TTTab* tab = [_tabViews objectAtIndex:i];
          tab.frame = CGRectMake(x, 0, averageTabWidth, self.height);
          x += tab.width;
        }
      }
    }

  } else {
    for (int i = 0; i < _tabViews.count; ++i) {
      TTTab* tab = [_tabViews objectAtIndex:i];
      [tab sizeToFit];
      tab.frame = CGRectMake(x, 0, tab.width, self.height);
      x += tab.width;
    }
  }

  return CGSizeMake(x, self.height);
}


@end
