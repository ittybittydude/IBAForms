#import "IBAFormFieldCell.h"

@interface IBATextAreaFormFieldCell : IBAFormFieldCell {
	UITextView *textView_;
}

- (id)initWithFormFieldStyle:(IBAFormFieldStyle *)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, strong) UITextView *textView;

@end
