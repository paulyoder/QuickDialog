//
//  QNumberElement.m
//  QuickDialog
//
//  Created by Paul Yoder on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QEntryTableViewCell.h"
#import "QNumberTableViewCell.h"
#import "QNumberElement.h"

@implementation QNumberElement {
  
@protected
  NSUInteger _fractionDigits;
}

@synthesize floatValue = _floatValue;
@synthesize fractionDigits = _fractionDigits;


- (QNumberElement *)initWithTitle:(NSString *)title value:(float)value {
  self = [super initWithTitle:title Value:nil] ;
  _floatValue = value;
  return self;
}


- (QNumberElement *)initWithValue:(float)value {
  self = [super init];
  _floatValue = value;
  return self;
}

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller {
  
  QNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuickformNumberElement"];
  if (cell==nil){
    cell = [[QNumberTableViewCell alloc] init];
  }
  [cell prepareForElement:self inTableView:tableView];
  return cell;
  
}

- (void)fetchValueIntoObject:(id)obj {
	if (_key==nil)
		return;
  [obj setValue:[NSNumber numberWithFloat:_floatValue] forKey:_key];
}

@end
