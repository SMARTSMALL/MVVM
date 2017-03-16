

//
//  MessageCell.m
//  MVVMDemo
//
//  Created by goldeneye on 2017/3/16.
//  Copyright © 2017年 goldeneye by smart-small. All rights reserved.
//

#import "MessageCell.h"
#import "MessageModel.h"
#import "SDAutoLayout.h"

@interface MessageCell()

@property(nonatomic,strong)UILabel * messageLabel;
@property(nonatomic,strong)UIView  * lineView;

@end

@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setUp];
    }
    return self;
}

- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _messageLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
    return _lineView;
}
- (void)setUp{
    
    [self.contentView addSubview:self.messageLabel];
    [self.contentView addSubview:self.lineView];
    
    self.messageLabel.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(self.contentView,20).rightSpaceToView(self.contentView,20).autoHeightRatio(0);
    
    self.lineView.sd_layout.leftSpaceToView(self.contentView,0).topSpaceToView(self.messageLabel,10).rightSpaceToView(self.contentView,0).heightIs(1);
    
    [self setupAutoHeightWithBottomView:self.lineView bottomMargin:0];
    
    
    
}

- (void)setModel:(MessageModel *)model
{
    
    _model = model;
    
    self.messageLabel.text = [NSString stringWithFormat:@"%@",model.content];
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
