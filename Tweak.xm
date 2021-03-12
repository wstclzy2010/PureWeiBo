@interface WBPageCard 
@property(retain, nonatomic) NSDictionary *promotion;
@end

@interface WBPageSingleTextCard : WBPageCard
@end

@interface WBAdFlashAdView : UIView
- (void)skipButtonPress:(id)arg1;
@end

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




%hook WBAdInfo
- (id)initWithDBDictionary:(id)arg1
{
	return nil;
}
- (id)initWithJsonDictionary:(id)arg1
{
	return nil;
}
%end



%hook WBCardListBaseItem
//发现页面热点广告
- (NSMutableArray *)pageCards
{
	//NSMutableArray *temArr = [NSMutableArray array];
	NSMutableArray *adArr = [NSMutableArray array];
	NSMutableArray *origArr = %orig;

	if(origArr.count > 0 )
		[origArr enumerateObjectsUsingBlock:^(id model, NSUInteger idx, BOOL * _stop)
		{
			if([model isKindOfClass:%c(WBPageStatusCard)])
				if([[[model status] statusTypeName] isEqualToString:@"广告"])
					[adArr addObject: model];
		}];

	if(adArr.count > 0)
		[origArr removeObjectsInArray:adArr];

	//origArr = [temArr mutableCopy];

	return origArr;
}
%end


%hook WBPageMultiCardCard
- (NSArray *)subcards
{
	NSMutableArray *temArr = [NSMutableArray array];
	NSMutableArray *adArr = [NSMutableArray array];
	NSArray *origArr = %orig;

	if(origArr.count > 0)
		for (id model in origArr)
			[temArr addObject:model];

	if(temArr.count == 2)
	//“我”页面广告
		[temArr enumerateObjectsUsingBlock:^(id model, NSUInteger idx, BOOL * _stop)
		{
			if([model isMemberOfClass:%c(WBPageDiscoverTitleCard)])
				if([[model title] isEqualToString:@"微公益"]
					||[[model title] isEqualToString:@"天天领红包"])
					[temArr removeAllObjects];
		}];
	
	//WBPageDoubleTextLinkCard是顶部热搜数据card
	[temArr enumerateObjectsUsingBlock:^(id model, NSUInteger idx, BOOL * _stop)
	{
		//发现页面顶部广告
		if([model isMemberOfClass:%c(WBPageGridButtonCard)]
			||[model isMemberOfClass:%c(WBPageSquarePhotoCard)]
			||[model isMemberOfClass:%c(WBPageGradientAnimateCard)])//滚动广告card
			[adArr addObject: model];

		if([model isMemberOfClass:%c(WBPageSingleTextCard)])
			if([model promotion])
				[adArr addObject: model];	
	}];

	

	if(adArr.count > 0)
		[temArr removeObjectsInArray:adArr];

	origArr = [temArr mutableCopy];

	return origArr;
}
%end





%hook WBFeedGroup
//feed流广告
- (id)status
{
	NSMutableArray *temArr = [NSMutableArray array];
	NSMutableArray *adArr = [NSMutableArray array];
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

	origArr = [temArr mutableCopy];

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

%hook WBTrendCommentCell
+ (double)rowHeightOfDataObject:(id)arg1 tableView:(id)arg2
{
	return 0;
}
%end



%hook WBCommentViewModel
//评论内广告评论
- (NSMutableArray *)arrayCellModels
{
	NSMutableArray *origArr = %orig;
	NSMutableArray *adArr = [NSMutableArray new];
	if(origArr.count > 0)
		for(id model in origArr)
		{
			if([model isMemberOfClass:%c(WBTrendCommentCellData)])
			{
				NSInteger index = [origArr indexOfObject:model];
				id adlike = [origArr objectAtIndex:index+1];
				[adArr addObject:model];
				[adArr addObject:adlike];
				//[origArr removeObjectAtIndex:index+1];
			}
				
		}
	
	if(adArr.count > 0)
		[origArr removeObjectsInArray:adArr];
	
	return origArr;
}
%end

