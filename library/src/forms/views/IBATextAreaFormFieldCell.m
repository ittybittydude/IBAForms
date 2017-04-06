#import "IBATextAreaFormFieldCell.h"
#import "IBAFormConstants.h"

@implementation IBATextAreaFormFieldCell

@synthesize textView = textView_;

- (void)dealloc {
	IBA_RELEASE_SAFELY(textView_);
    [super dealloc];
}


- (id)initWithFormFieldStyle:(IBAFormFieldStyle *)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithFormFieldStyle:style reuseIdentifier:reuseIdentifier])) {
		// Create the text field for data entry
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
            NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithSize:CGSizeMake(2, CGFLOAT_MAX)] autorelease];
            NSTextStorage *textStorage = [[[NSTextStorage alloc] initWithString:@""] autorelease];
            NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init] autorelease];
            [textStorage addLayoutManager:layoutManager];
            [textStorage addAttribute:NSFontAttributeName value:style.valueFont range:NSMakeRange(0, [textStorage length])];
            [layoutManager addTextContainer:textContainer];
            
            self.textView = [[[UITextView alloc] initWithFrame:style.valueFrame textContainer:textContainer] autorelease];
            [self.textView setTextContainerInset:UIEdgeInsetsMake(2.0f, 5.0f, 0.0f, 0.0f)];
        } else {
            self.textView = [[[UITextView alloc] initWithFrame:style.valueFrame] autorelease];
        }
		self.textView.autoresizingMask = style.valueAutoresizingMask;
		[self.cellView addSubview:self.textView];
	}
	
    return self;
}

- (void)activate {
	[super activate];
	
	self.textView.backgroundColor = [UIColor clearColor];
}


- (void)applyFormFieldStyle {
	[super applyFormFieldStyle];
	
	self.textView.font = self.formFieldStyle.valueFont;
	self.textView.textColor = self.formFieldStyle.valueTextColor;
	self.textView.backgroundColor = self.formFieldStyle.valueBackgroundColor;
	self.textView.textAlignment = self.formFieldStyle.valueTextAlignment;
}


@end
