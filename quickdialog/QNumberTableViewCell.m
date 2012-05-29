//
//  QNumberTableViewCell.m
//  QuickDialog
//
//  Created by Paul Yoder on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QNumberTableViewCell.h"
#import "QEntryElement.h"
#import "QNumberElement.h"

@implementation QNumberTableViewCell {
  NSNumberFormatter *_numberFormatter;
}

- (QNumberTableViewCell *)init {
  self = [self initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"QuickformNumberElement"];
  if (self!=nil){
    [self createSubviews];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
    _numberFormatter = [[NSNumberFormatter alloc] init];
    [_numberFormatter setPositiveFormat:@"#,###.###"];
  };
  return self;
}

- (void)createSubviews {
  _textField = [[UITextField alloc] init];
  [_textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
  _textField.borderStyle = UITextBorderStyleNone;
  _textField.keyboardType = UIKeyboardTypeDecimalPad;
  _textField.delegate = self;
  _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
  _textField.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
  [self.contentView addSubview:_textField];
  
  [self setNeedsLayout];
}

- (QNumberElement *)numberElement {
  return ((QNumberElement *)_entryElement);
}

- (void)updateTextFieldFromElement {
  QNumberElement *el = (QNumberElement *)_entryElement;
  _textField.text = [_numberFormatter stringFromNumber:[NSNumber numberWithFloat:el.floatValue]];
}

- (void)prepareForElement:(QEntryElement *)element inTableView:(QuickDialogTableView *)view {
  [super prepareForElement:element inTableView:view];
  _entryElement = element;
  [self updateTextFieldFromElement];
}

- (void)updateElementFromTextField:(NSString *)value {
  NSMutableString *result = [[NSMutableString alloc] init];
  for (NSUInteger i = 0; i< [value length]; i++){
    unichar c = [value characterAtIndex:i];
    NSString *charStr = [NSString stringWithCharacters:&c length:1];
    if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c] || [charStr isEqualToString:@"."]) {
      [result appendString:charStr];
    }
  }
  [self numberElement].floatValue= [[_numberFormatter numberFromString:result] floatValue];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacement {
  NSString *newValue = [_textField.text stringByReplacingCharactersInRange:range withString:replacement];
  newValue = [self removeMultipleDecimals:newValue];
  
  [self updateElementFromTextField:newValue];
  [self updateTextFieldFromElement];
  [self addTrailingDecimal:newValue];
  
  if(_entryElement && _entryElement.delegate && [_entryElement.delegate respondsToSelector:@selector(QEntryShouldChangeCharactersInRangeForElement:andCell:)]){
    [_entryElement.delegate QEntryShouldChangeCharactersInRangeForElement:_entryElement andCell:self];
  }
  
  return NO;
}

- (NSString *)removeMultipleDecimals:(NSString *)value {
  BOOL foundDecimal = NO;
  NSMutableString *result = [[NSMutableString alloc] init];
  for (NSUInteger i = 0; i< [value length]; i++){
    unichar c = [value characterAtIndex:i];
    NSString *charStr = [NSString stringWithCharacters:&c length:1];
    if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c]) {
      [result appendString:charStr];
    }
    if ([charStr isEqualToString:@"."]) {
      if (foundDecimal)
        break;
      
      foundDecimal = YES;
      [result appendString:charStr];
    }
  }
  return result;
}

- (void)addTrailingDecimal:(NSString *)value {
  if (value.length == 0)
    return;
  
  NSString *lastChar = [value substringFromIndex:(value.length - 1)];
  if ([lastChar isEqualToString:@"."])
    _textField.text = [_textField.text stringByAppendingFormat:@"."];
}

@end
