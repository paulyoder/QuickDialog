//
//  QNumberTableViewCell.h
//  QuickDialog
//
//  Created by Paul Yoder on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QEntryTableViewCell.h"

@interface QNumberTableViewCell : QEntryTableViewCell <UITextFieldDelegate>  {
  
}

- (void)prepareForElement:(QEntryElement *)element inTableView:(QuickDialogTableView *)view;

@end
