@import Foundation;
@import UIKit;
@import QuartzCore;

// --- Interfaces ---
@interface MTMaterialView : UIView
- (id)_viewControllerForAncestor;
@end

@interface CCUIContentModuleContentContainerView : UIView {
    MTMaterialView *_moduleMaterialView;
}
@end

@interface MRUContinuousSliderView : UIView
@property (readonly, nonatomic) UIView *materialView;
@end

@interface FCUIActivityControl : UIView {
    MTMaterialView *_backgroundView;
}
@end

@interface MRUControlCenterView : UIView
@property (retain, nonatomic) UIView *materialView;
@end

@interface _FCUIAddActivityControl : UIView {
    MTMaterialView *_backgroundMaterialView;
}
@end

@interface MediaControlsVolumeSliderView : UIView {
    UIView *_materialView;
}
@end

// --- Helper Logic ---
// Hàm dùng chung để tránh lặp code và đảm bảo an toàn
static void ApplyCCBorderStyle(UIView *mainView, UIView *backgroundView) {
    if (!mainView || !backgroundView || !mainView.window) return;

    // Ẩn nền gốc
    [backgroundView setAlpha:0.0];
    backgroundView.hidden = YES;

    // Cấu hình viền cho View chính
    mainView.layer.borderWidth = 1.0;
    mainView.layer.borderColor = [UIColor whiteColor].CGColor;
    mainView.layer.cornerRadius = backgroundView.layer.cornerRadius;
    mainView.layer.masksToBounds = YES; 
}

// --- Hooks ---

%hook CCUIContentModuleContentContainerView
- (void)layoutSubviews {
    %orig;
    MTMaterialView *matView = MSHookIvar<MTMaterialView *>(self, "_moduleMaterialView");
    ApplyCCBorderStyle(self, matView);
}
%end

%hook MRUContinuousSliderView
- (void)layoutSubviews {
    %orig;
    if ([self respondsToSelector:@selector(materialView)]) {
        ApplyCCBorderStyle(self, self.materialView);
    }
}
%end

%hook MediaControlsVolumeSliderView
- (void)layoutSubviews {
    %orig;
    UIView *matView = MSHookIvar<UIView *>(self, "_materialView");
    ApplyCCBorderStyle(self, matView);
}
%end

%hook FCUIActivityControl
- (void)layoutSubviews {
    %orig;
    MTMaterialView *matView = MSHookIvar<MTMaterialView *>(self, "_backgroundView");
    ApplyCCBorderStyle(self, matView);
}
%end

%hook MRUControlCenterView
- (void)layoutSubviews {
    %orig;
    if ([self respondsToSelector:@selector(materialView)]) {
        ApplyCCBorderStyle(self, self.materialView);
    }
}
%end

%hook _FCUIAddActivityControl
- (void)layoutSubviews {
    %orig;
    MTMaterialView *matView = MSHookIvar<MTMaterialView *>(self, "_backgroundMaterialView");
    ApplyCCBorderStyle(self, matView);
}
%end

%hook MTMaterialView
- (void)layoutSubviews {
    %orig;
    // Xử lý riêng cho module Focus (DND)
    if ([self respondsToSelector:@selector(_viewControllerForAncestor)]) {
        id vc = [self _viewControllerForAncestor];
        if ([vc isKindOfClass:NSClassFromString(@"FCCCControlCenterModule")]) {
            [self setAlpha:0.0];
            self.hidden = YES;
            
            UIView *parent = self.superview;
            if (parent) {
                parent.layer.borderWidth = 1.0;
                parent.layer.borderColor = [UIColor whiteColor].CGColor;
                parent.layer.cornerRadius = self.layer.cornerRadius;
                parent.layer.masksToBounds = YES;
            }
        }
    }
}
%end
