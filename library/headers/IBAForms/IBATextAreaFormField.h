#import "IBAInputRequestorFormField.h"

@class IBATextAreaFormFieldCell;

@interface IBATextAreaFormField : IBAInputRequestorFormField <UITextViewDelegate> {
	IBATextAreaFormFieldCell *textFormFieldCell_;
    NSString *defaultText_;
    Class textFieldClass_;
}

@property (nonatomic, strong) IBATextAreaFormFieldCell *textFormFieldCell;
@property (nonatomic, strong) NSString *placeholderText;

@end
