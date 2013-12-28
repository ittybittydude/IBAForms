#import "IBAComplexFormField.h"

@implementation IBAComplexFormField

@synthesize keyPaths = keyPaths_;
@synthesize title = title_;
@synthesize modelManager = modelManager_;
@synthesize delegate = delegate_;
@synthesize formFieldStyle = formFieldStyle_;
@synthesize nullable = nullable_;
@synthesize valueTransformers = valueTransformers_;
@synthesize valuesSeparator = valuesSeparator_;
@synthesize cellHeight = cellHeight_;

#pragma mark -
#pragma mark Initialisation and memory management

- (void)dealloc {
	IBA_RELEASE_SAFELY(keyPaths_);
	IBA_RELEASE_SAFELY(title_);
	IBA_RELEASE_SAFELY(formFieldStyle_);
	IBA_RELEASE_SAFELY(valueTransformers_);
    IBA_RELEASE_SAFELY(valuesSeparator_);
    
	[super dealloc];
}

- (id)initWithKeyPaths:(NSArray*)keyPaths title:(NSString*)title valueTransformers:(NSArray *)valueTransformers {
	if ((self = [super init])) {
		self.keyPaths = keyPaths;
		title_ = [title copy];
		self.nullable = YES;
		self.valueTransformers = valueTransformers;
        self.cellHeight = UITableViewAutomaticDimension;
        self.valuesSeparator = @" ";
	}
    
	return self;
}

- (id)initWithKeyPaths:(NSArray*)keyPaths title:(NSString*)title {
	return [self initWithKeyPaths:keyPaths title:title valueTransformers:nil];
}

- (id)initWithKeyPaths:(NSArray*)keyPaths {
	return [self initWithKeyPaths:keyPaths title:nil valueTransformers:nil];
}

- (id)initWithTitle:(NSString*)title {
	return [self initWithKeyPaths:nil title:title valueTransformers:nil];
}

- (id)init {
	return [self initWithKeyPaths:nil title:nil];
}


- (void)setModelManager:(id<IBAFormModelManager>) modelManager {
	if (modelManager != modelManager_) {
		modelManager_ = modelManager;
        
		// When the model manager changes we should update the content of the cell
		[self updateCellContents];
	}
}

- (void)setFormFieldStyle:(IBAFormFieldStyle *)formFieldStyle {
	if (formFieldStyle != formFieldStyle_) {
        IBA_RELEASE_SAFELY(formFieldStyle_);
		formFieldStyle_ = [formFieldStyle retain];
        
		self.cell.formFieldStyle = formFieldStyle;
	}
}

- (void)setTitle:(NSString *)title {
	if (![title isEqualToString:title_]) {
		NSString *oldTitle = title_;
		title_ = [title copy];
		IBA_RELEASE_SAFELY(oldTitle);
        
		[self updateCellContents];
	}
}

#pragma mark -
#pragma mark Selection notification
- (void)select {
	// Subclasses should override this method
}


#pragma mark -
#pragma mark Cell management

- (IBAFormFieldCell *)cell {
	// To be implemented by subclasses
	NSAssert(NO, @"Subclasses of id<IBAFormFieldProtocol> should override cell");
	return nil;
}

- (void)updateCellContents {
	// To be implemented by subclasses
	NSAssert(NO, @"Subclasses of id<IBAFormFieldProtocol> should override updateCellContents");
}


#pragma mark -
#pragma mark Detail View Controller management

// Subclasses should override these methods
- (BOOL)hasDetailViewController {
	return NO;
}

- (UIViewController *)detailViewController {
	return nil;
}

#pragma mark -
#pragma mark Getting and setting the form field value
- (NSArray*)formFieldValues {
	NSArray *values = [self.modelManager modelValuesForKeyPaths:self.keyPaths];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[values count]];
    for(int i = 0; i < [values count]; i++) {
        id value = [values objectAtIndex:i];
        if(i < [[self valueTransformers] count]) {
            NSValueTransformer *transformer = [[self valueTransformers] objectAtIndex:i];
            if([transformer isKindOfClass:[NSValueTransformer class]]) {
                id transformedValue = [transformer reverseTransformedValue:value];
                if([transformedValue isKindOfClass:[NSSet class]]) {
                    if([transformedValue count] != 0)
                        [result addObject:[[transformedValue allObjects] componentsJoinedByString:@", "]];
                } else if([transformedValue isKindOfClass:[NSArray class]]) {
                    [result addObject:[transformedValue componentsJoinedByString:@", "]];
                } else {
                    if(transformedValue != nil && [transformedValue isKindOfClass:[NSNull class]] == NO && [[transformedValue description] length] > 0)
                        [result addObject:transformedValue];
                }
            } else {
                if(value != nil && [value isKindOfClass:[NSNull class]] == NO && [[value description] length] > 0)
                    [result addObject:[value description]];
            }
        } else {
            if(value != nil && [value isKindOfClass:[NSNull class]] == NO && [[value description] length] > 0)
                [result addObject:[value description]];
        }
    }
    return [NSArray arrayWithArray:result];
}

- (NSString *)formFieldStringValue {
	return [[self formFieldValues] componentsJoinedByString:self.valuesSeparator];
}

- (BOOL)setFormFieldValues:(NSArray*)formVieldValues {
	BOOL setValues = YES;
    
	// Transform the value if we have a transformer
	NSArray *values = formVieldValues;
	if (self.valueTransformers != nil) {
        NSMutableArray *transformedValues = [NSMutableArray arrayWithCapacity:[values count]];
        for(int i = 0; i < [values count]; i++) {
            id value = [values objectAtIndex:i];
            if(i < [[self valueTransformers] count]) {
                NSValueTransformer *transformer = [[self valueTransformers] objectAtIndex:i];
                if([transformer isKindOfClass:[NSValueTransformer class]]) {
                    [transformedValues addObject:[transformer transformedValue:value]];
                } else {
                    [transformedValues addObject:value];
                }
            } else {
                [transformedValues addObject:value];
            }
        }
        values = [NSArray arrayWithArray:transformedValues];
	}
    
	if (self.delegate && [self.delegate respondsToSelector:@selector(formField:willSetValues:)]) {
		setValues = [self.delegate formField:self willSetValue:values];
	}
    
	if (setValues) {
        for(int i = 0; i < [[self keyPaths] count]; i++) {
            NSString *keyPath = [[self keyPaths] objectAtIndex:i];
            if([keyPath isKindOfClass:[NSString class]] == YES) {
                id value = [values objectAtIndex:i];
                [self.modelManager setModelValue:value forKeyPath:keyPath];
            } else {
                [[NSException exceptionWithName:@"Error" reason:@"keyPath must be a string" userInfo:nil] raise];
            }
        }
        
		[self updateCellContents];
        
		if (self.delegate && [self.delegate respondsToSelector:@selector(formField:didSetValues:)]) {
			[self.delegate formField:self didSetValue:values];
		}
	}
    
	return setValues;
}

@end
