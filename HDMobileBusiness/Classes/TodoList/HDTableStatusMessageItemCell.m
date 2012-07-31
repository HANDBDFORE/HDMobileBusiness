//
//  HDTableStatusMessageItemCell.m
//  hrms
//
//  Created by Rocky Lee on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDTableStatusMessageItemCell.h"

static const NSInteger  kMessageTextLineCount       = 2;
static const CGFloat    kDefaultMessageImageWidth   = 34.0f;
static const CGFloat    kDefaultMessageImageHeight  = 34.0f;

@implementation HDTableStatusMessageItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	self = [super initWithStyle:style reuseIdentifier:identifier];
    if (self) {
       
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    TT_RELEASE_SAFELY(_activityLabel);
    TT_RELEASE_SAFELY(_stateLabel);    
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell class public


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    //Compute height based on font sizes
//    object
    HDTableStatusMessageItem* item = object;
    
    CGFloat height = 90;
    if (item.message) {
        height += TTSTYLEVAR(font).lineHeight *2;
    }
    
    return height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse {
    [super prepareForReuse];
    _stateLabel.text = nil;
    _stateLabel.backgroundColor = self.backgroundColor;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat left = 0.0f;
    if (_imageView2) {
        _imageView2.frame = CGRectMake(kTableCellSmallMargin, kTableCellSmallMargin,
                                       kDefaultMessageImageWidth, kDefaultMessageImageHeight);
        left += kTableCellSmallMargin + kDefaultMessageImageHeight + kTableCellSmallMargin;
        
    } else {
        left = kTableCellMargin;
    }
    
    CGFloat width = self.contentView.width - left;
    CGFloat top = kTableCellSmallMargin;
    
    if (_stateLabel.text.length) {
        _stateLabel.frame = CGRectMake(left, top, width-18,_stateLabel.font.lineHeight*2);
        top += _stateLabel.height;
    }else {
        _stateLabel.frame = CGRectZero;
    }
    
    if (_titleLabel.text.length) {
        _titleLabel.frame = CGRectMake(left, top, width, _titleLabel.font.lineHeight);
        top += _titleLabel.height;
        
    } else {
        _titleLabel.frame = CGRectZero;
    }
    
    if (self.captionLabel.text.length) {
        self.captionLabel.frame = CGRectMake(left, top, width, self.captionLabel.font.lineHeight);
        top += self.captionLabel.height;
        
    } else {
        self.captionLabel.frame = CGRectZero;
    }
    
    if (self.detailTextLabel.text.length) {
        CGFloat textHeight = self.detailTextLabel.font.lineHeight * kMessageTextLineCount;
        self.detailTextLabel.frame = CGRectMake(left, top, width, textHeight);
        
    } else {
        self.detailTextLabel.frame = CGRectZero;
    }
    
    if (_timestampLabel.text.length) {
        _timestampLabel.alpha = !self.showingDeleteConfirmation;
        [_timestampLabel sizeToFit];
        _timestampLabel.left = self.contentView.width - (_timestampLabel.width + kTableCellSmallMargin);
        _timestampLabel.top = _titleLabel.top;
        _titleLabel.width -= _timestampLabel.width + kTableCellSmallMargin*2;
        
    } else {
        _timestampLabel.frame = CGRectZero;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (self.superview) {
        _stateLabel.backgroundColor = self.backgroundColor;
        
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
    if (_item != object) {
        [super setObject:object];
        
        HDTableStatusMessageItem * item = object;
        if (item.message.length) {
            self.stateLabel.text = item.message;
        }
        if (item.state) {
            if ([item.state isEqualToString:kTableStatusMessageNormoal]) {
                self.activityLabel.hidden = YES;
            }
            if ([item.state isEqualToString: kTableStatusMessageError]) {
                self.stateLabel.style = TTSTYLE(tableStatusLabelError);
                self.activityLabel.hidden = YES;
            }
            if ([item.state isEqualToString: kTableStatusMessageDifferent]) {
                self.stateLabel.style = TTSTYLE(tableStatusLabelDifferent);
                self.activityLabel.hidden = YES;
            }
            if ([item.state isEqualToString: kTableStatusMessageWaiting]) {
                self.activityLabel.hidden = NO;
            }
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (TTLabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[TTLabel alloc] init];
        _stateLabel.style = TTSTYLE(@"tableStatusLabel");
        _stateLabel.contentMode = UIViewContentModeLeft;
        [self.contentView addSubview:_stateLabel];
    }
    return _stateLabel;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
-(TTActivityLabel *) activityLabel{
    if (!_activityLabel) {
        _activityLabel = [[TTActivityLabel alloc]initWithStyle:TTActivityLabelStyleWhiteBox];
        _activityLabel.text =@"提交中...";
        _activityLabel.hidden =YES;
        [_activityLabel sizeToFit];
        _activityLabel.frame = CGRectMake(0,0, self.width, self.height);
        _activityLabel.backgroundColor = RGBACOLOR(225, 225, 225, 0.6);
        [self addSubview:_activityLabel];
    }
    return _activityLabel;
}

@end
