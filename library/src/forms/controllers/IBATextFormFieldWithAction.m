#import "IBATextFormFieldWithAction.h"
#import "IBAInputCommon.h"

@interface IBATextFormFieldWithAction()
@property (nonatomic, copy) IBATextFormFieldBlock executionBlock;
@end

@implementation IBATextFormFieldWithAction

@synthesize textFormFieldCell = textFormFieldCell_;
@synthesize executionBlock = executionBlock_;

- (NSArray*)inputRequestorValue {
	return [self formFieldValues];
}

- (void)setInputRequestorValue:(NSArray*)aValue {
	[self setFormFieldValues:aValue];
}

- (id)defaultInputRequestorValue {
	return nil;
}

- (UIResponder *)responder {
	return self.cell;
}

- (id)initWithKeyPaths:(NSArray*)keyPaths title:(NSString*)title valueTransformers:(NSArray *)valueTransformers executionBlock:(IBATextFormFieldBlock)block {
    self = [super initWithKeyPaths:keyPaths title:title valueTransformers:valueTransformers];
    if(self) {
        [self setExecutionBlock:block];
    }
    return self;
}

- (id)initWithKeyPaths:(NSArray*)keyPaths title:(NSString*)title executionBlock:(IBATextFormFieldBlock)block {
    return [self initWithKeyPaths:keyPaths title:title valueTransformers:nil executionBlock:block];
}

- (void)dealloc {
	IBA_RELEASE_SAFELY(textFormFieldCell_);
	IBA_RELEASE_SAFELY(executionBlock_);
    [super dealloc];
}


#pragma mark -
#pragma mark Cell management

- (IBAFormFieldCell *)cell {
	return [self textFormFieldCell];
}

- (IBATextFormFieldCell *)textFormFieldCell {
	if (textFormFieldCell_ == nil) {
		textFormFieldCell_ = [[IBATextFormFieldCell alloc] initWithFormFieldStyle:self.formFieldStyle reuseIdentifier:@"Cell"];
		textFormFieldCell_.textField.enabled = NO;
	}
	
	return textFormFieldCell_;
}

- (void)updateCellContents {
	self.textFormFieldCell.label.text = self.title;
	self.textFormFieldCell.textField.text = [self formFieldStringValue];
}

- (NSString *)dataType {
	return IBAInputDataTypeText;
}

- (void)select {
	if (self.executionBlock != NULL) {
		self.cell.selected = NO;
		self.executionBlock();
	}
}

@end
