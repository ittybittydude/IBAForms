#import "IBAComplexFormField.h"
#import "IBATextFormFieldCell.h"

typedef void (^IBATextFormFieldBlock)(void);

@interface IBATextFormFieldWithAction : IBAComplexFormField {
    IBATextFormFieldCell *textFormFieldCell_;
    IBATextFormFieldBlock executionBlock_;
}

- (id)initWithKeyPaths:(NSArray*)keyPaths title:(NSString*)title valueTransformers:(NSArray *)valueTransformers executionBlock:(IBATextFormFieldBlock)block;
- (id)initWithKeyPaths:(NSArray*)keyPaths title:(NSString*)title executionBlock:(IBATextFormFieldBlock)block;

@property (nonatomic, retain) IBATextFormFieldCell *textFormFieldCell;

@end
