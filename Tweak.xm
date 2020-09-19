@interface WBUniversalStatus
@property(retain, nonatomic) NSString *statusTypeName;
@end

@class WBStatus;
@interface WBStatus : WBUniversalStatus
@end

@interface WBPageStatusCard
{
    WBStatus *status;
}
@property(readonly, nonatomic) WBStatus *status;
@end


%hook WBFeedGroup
//feed流广告
- (id)status
{
	NSMutableArray *temArr = [NSMutableArray new];
	NSMutableArray *adArr = [NSMutableArray new];
	NSArray *origArr = %orig;

	if(origArr.count > 0)
		for (id model in origArr)
			[temArr addObject:model];
	
	[temArr enumerateObjectsUsingBlock:^(id model, NSUInteger idx, BOOL * _stop)
	{
		if([model isKindOfClass:%c(WBStatus)])
			if([[model statusTypeName] isEqualToString:@"广告"])
				[adArr addObject: model];
	}];

	if(adArr.count > 0)
		[temArr removeObjectsInArray:adArr];

	return temArr;
}
%end

%hook WBContentBaseViewModel
//评论内广告评论
- (NSMutableArray *)arrayCellModels
{
	NSMutableArray *origArr = %orig;
	NSMutableArray *adArr = [NSMutableArray new];
	if(origArr.count > 0)
		[origArr enumerateObjectsUsingBlock:^(id model, NSUInteger idx, BOOL * _stop)
		{
			if([model isKindOfClass:%c(WBTrendCommentCellData)])
				[adArr addObject:model];
		}];
	
	if(adArr.count > 0)
		[origArr removeObjectsInArray:adArr];
	
	return origArr;
}
%end

%hook WBContentHeaderTrendCell
//评论页顶部广告
- (void)setupCellData:(id)arg1{}
+ (double)cellHeightWithCellData:(id)arg1
{	
	return 0;
}
%end

%hook WBAdInfo
//启动广告
- (id)initWithDBDictionary:(id)arg1
{
	return nil;
}
- (id)initWithJsonDictionary:(id)arg1
{
	return nil;
}
%end

%hook WBPageCardTableViewCell
//发现页滚动横幅、方格按钮
+ (double)rowHeightOfDataObject:(id)arg1 tableView:(id)arg2 bubbleType:(id)arg3 constraintWidth:(double)arg4 listPage:(_Bool)arg5
{
	if([[arg2 nextResponder] isKindOfClass:%c(WBHotWeiboSquareHitTestView)])
	{
		if([arg1 isKindOfClass:%c(WBPageGridButtonCard)]
			|| [arg1 isKindOfClass:%c(WBPageGradientAnimateCard)])
			return 0;

		// if([arg1 isKindOfClass:%c(WBPageStatusCard)])
		// 	if([[MSHookIvar<WBStatus *>(arg1, "status") statusTypeName] isEqualToString:@"广告"])
		// 		return 0;
	}
	
	return %orig;
}
%end

