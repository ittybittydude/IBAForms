#import <Foundation/Foundation.h>
#import "IBAFormFieldCell.h"
#import "IBAFormModelManager.h"

@protocol IBAFormFieldDelegate;

@protocol IBAFormFieldProtocol <NSObject>

@property (nonatomic, readonly) IBAFormFieldCell *cell;
@property (nonatomic, assign) id<IBAFormModelManager> modelManager;
@property (nonatomic, assign) id<IBAFormFieldDelegate> delegate;
@property (nonatomic, retain) IBAFormFieldStyle *formFieldStyle;
@property (nonatomic, assign) CGFloat cellHeight;

- (void)updateCellContents;

#pragma mark -
#pragma mark Detail View Controller management
- (BOOL)hasDetailViewController;
- (UIViewController *)detailViewController;

#pragma mark -
#pragma mark Selection notification
- (void)select;

@end


@protocol IBAFormFieldDelegate <NSObject>
@optional
- (BOOL)formField:(id<IBAFormFieldProtocol>)formField willSetValue:(id)value;
- (void)formField:(id<IBAFormFieldProtocol>)formField didSetValue:(id)value;
- (BOOL)formFieldWillBecomeActive:(id<IBAFormFieldProtocol>)formField;
- (void)formFieldDidBecomeActive:(id<IBAFormFieldProtocol>)formField;
@end