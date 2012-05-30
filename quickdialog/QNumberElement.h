//
//  QNumberElement.h
//  QuickDialog
//
//  Created by Paul Yoder on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QEntryElement.h"

@interface QNumberElement : QEntryElement {
  
}

@property(nonatomic, assign) float floatValue;
@property(nonatomic, assign) NSUInteger wholeDigits;
@property(nonatomic, assign) NSUInteger fractionDigits;
@property(nonatomic, copy) NSString * prependText;
@property(nonatomic, copy) NSString * appendText;

- (QNumberElement *)initWithTitle:(NSString *)string value:(float)value;
- (QNumberElement *)initWithValue:(float)value;

@end
