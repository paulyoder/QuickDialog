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
@synthesize wholeDigits = _wholeDigits;
@synthesize fractionDigits = _fractionDigits;
@synthesize prependText = _prependText;
@synthesize appendText = _appendText;

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

- (NSString *)textValue {
  NSString *rawValue = super.textValue;
  NSMutableString *scrubbedValue = [[NSMutableString alloc] init];
  for (NSUInteger i = 0; i< [rawValue length]; i++){
    unichar c = [rawValue characterAtIndex:i];
    NSString *charStr = [NSString stringWithCharacters:&c length:1];
    if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c] || [charStr isEqualToString:@"."]) {
      [scrubbedValue appendString:charStr];
    }
  }
  return scrubbedValue;
}

@end
