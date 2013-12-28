#import "IBATextAreaFormField.h"
#import "IBAInputCommon.h"
#import "IBAInputManager.h"
#import "IBATextAreaFormFieldCell.h"

@implementation IBATextAreaFormField

@synthesize textFormFieldCell = textFormFieldCell_;



- (id)initWithKeyPath:(NSString*)keyPath title:(NSString*)title {
	self = [super initWithKeyPath:keyPath title:title];
    if(self) {
        self.placeholderText = @"";
    }
    return self;
}

- (void)dealloc {
	IBA_RELEASE_SAFELY(textFormFieldCell_);
    [super dealloc];
}


#pragma mark -
#pragma mark Cell management

- (IBAFormFieldCell *)cell {
	return [self textFormFieldCell];
}


- (IBATextAreaFormFieldCell *)textFormFieldCell {
	if (textFormFieldCell_ == nil) {
		textFormFieldCell_ = [[IBATextAreaFormFieldCell alloc] initWithFormFieldStyle:self.formFieldStyle reuseIdentifier:@"Cell"];
		textFormFieldCell_.textView.delegate = self;
		textFormFieldCell_.textView.editable = NO;
        textFormFieldCell_.textView.userInteractionEnabled = NO;
        if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f) textFormFieldCell_.textView.scrollEnabled = NO;
        textFormFieldCell_.textView.text = self.placeholderText;
	}
	
	return textFormFieldCell_;
}

- (void)updateCellContents {
	self.textFormFieldCell.label.text = self.title;
    NSString *text = [self formFieldStringValue];
    if(text == nil || [text isEqualToString:@""]) {
        text = self.placeholderText;
    }
	self.textFormFieldCell.textView.text = text;
}


#pragma mark -
#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextField *)textField {
    if([self.textFormFieldCell.textView.text isEqualToString:self.placeholderText])
        self.textFormFieldCell.textView.text = @"";
    return YES;
}

// Fix ios 7 bug
- (void)textViewDidChange:(UITextView *)textView {
    CGRect line = [textView caretRectForPosition:
                   textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height
    - ( textView.contentOffset.y + textView.bounds.size.height
       - textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 ) {
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
        }];
    }
}

#pragma mark -
#pragma mark IBAInputRequestor

- (NSString *)dataType {
	return IBAInputDataTypeText;
}

- (void)activate {
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f) textFormFieldCell_.textView.scrollEnabled = YES;
	self.textFormFieldCell.textView.editable = YES;
    textFormFieldCell_.textView.userInteractionEnabled = YES;
	[super activate];
}

- (BOOL)deactivate {
	BOOL deactivated = [self setFormFieldValue:self.textFormFieldCell.textView.text];
	if (deactivated) {
        [self.textFormFieldCell.textView scrollRangeToVisible:NSMakeRange(0, 0)];
		self.textFormFieldCell.textView.editable = NO;
        textFormFieldCell_.textView.userInteractionEnabled = NO;
        if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f) textFormFieldCell_.textView.scrollEnabled = NO;
		deactivated = [super deactivate];
	}
	
	return deactivated;
}

- (UIResponder *)responder {
	return self.textFormFieldCell.textView;
}

@end
