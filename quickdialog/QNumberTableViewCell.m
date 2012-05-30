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
    [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
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
  [self updateTextFieldFromElement:YES];
}

- (void)updateTextFieldFromElement:(BOOL)addPrependAppendText {
  NSString * value = @"";
  QNumberElement *el = (QNumberElement *)_entryElement;
  [_numberFormatter setMaximumFractionDigits:[self numberElement].fractionDigits];
  NSString * formattedNumber = [_numberFormatter stringFromNumber:[NSNumber numberWithFloat:el.floatValue]];
  
  if (addPrependAppendText && el.prependText != nil)
    value = [value stringByAppendingString:el.prependText];
  
  value = [value stringByAppendingString:formattedNumber];
  
  if (addPrependAppendText && el.appendText != nil)
    value = [value stringByAppendingString:el.appendText];
  
  _textField.text = value;
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
  [_numberFormatter setMaximumFractionDigits:[self numberElement].fractionDigits];
  [self numberElement].floatValue = [[_numberFormatter numberFromString:result] floatValue];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacement {
  NSString *newValue = [_textField.text stringByReplacingCharactersInRange:range withString:replacement];
  if ([self invalidInput:newValue])
    return NO;
  
  [self updateElementFromTextField:newValue];
  [self updateTextFieldFromElement:NO];
  [self addTrailingDecimal:newValue];
  
  if(_entryElement && _entryElement.delegate && [_entryElement.delegate respondsToSelector:@selector(QEntryShouldChangeCharactersInRangeForElement:andCell:)]){
    [_entryElement.delegate QEntryShouldChangeCharactersInRangeForElement:_entryElement andCell:self];
  }
  
  return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  //Remove prepend and append text when begin editing
  QNumberElement *el = (QNumberElement *)_entryElement;
  if (el.prependText != nil) {
    textField.text = [textField.text substringFromIndex:el.prependText.length];
  }
  if (el.appendText != nil) {
    NSUInteger lastIndexOf = [textField.text rangeOfString:el.appendText options:NSBackwardsSearch].location;
    textField.text = [textField.text substringToIndex:lastIndexOf];
  }
  
  [super textFieldDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  // add the prepend and append text after done editing
  [self updateTextFieldFromElement:YES];
  
  [super textFieldDidEndEditing:textField];
}

- (BOOL)invalidInput:(NSString *)value {
  return ([self multipleDecimals:value] || [self tooManyFractionDigits:value] || [self tooManyWholeDigits:value]);
}

- (BOOL)tooManyFractionDigits:(NSString *)value {
  NSUInteger decimalIndexOf = [value rangeOfString:@"."].location;
  if (decimalIndexOf == NSNotFound)
    return NO;

  NSUInteger decimalPlaces = (value.length - decimalIndexOf - 1);
  QNumberElement *el = (QNumberElement *)_entryElement;
  
  return (decimalPlaces > el.fractionDigits);
}

- (BOOL)tooManyWholeDigits:(NSString *)value {
  QNumberElement *el = (QNumberElement *)_entryElement;
  if (el.wholeDigits == 0)
    return NO;
  
  NSUInteger decimalIndexOf = [value rangeOfString:@"."].location;
  if (decimalIndexOf == NSNotFound)
    decimalIndexOf = value.length;
  
  return (decimalIndexOf > el.wholeDigits);
}

- (BOOL)multipleDecimals:(NSString *)value {
  BOOL oneDecimal = NO;
  for (NSUInteger i = 0; i< [value length]; i++){
    unichar c = [value characterAtIndex:i];
    NSString *charStr = [NSString stringWithCharacters:&c length:1];
    if ([charStr isEqualToString:@"."]) {
      if (oneDecimal)
        return YES;
      
      oneDecimal = YES;
    }
  }
  return NO;
}

- (void)addTrailingDecimal:(NSString *)value {
  if (value.length == 0)
    return;
  
  QNumberElement *el = (QNumberElement *)_entryElement;
  if (el.fractionDigits == 0)
    return;
  
  NSString *lastChar = [value substringFromIndex:(value.length - 1)];
  if ([lastChar isEqualToString:@"."])
    _textField.text = [_textField.text stringByAppendingFormat:@"."];
}

@end
