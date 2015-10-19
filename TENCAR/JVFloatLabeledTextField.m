//
//  JVFloatLabeledTextField.m
//  JVFloatLabeledTextField
//
//  The MIT License (MIT)
//
//  Copyright (c) 2013-2015 Jared Verdi
//  Original Concept by Matt D. Smith
//  http://dribbble.com/shots/1254439--GIF-Mobile-Form-Interaction?list=users
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "JVFloatLabeledTextField.h"
#import "NSString+TextDirectionality.h"

#define MASK_CHAR_NUMERIC      @"#"
#define MASK_CHAR_ALPHANUMERIC @"&"
#define MASK_CHAR_LETTER       @"?"

static CGFloat const kFloatingLabelShowAnimationDuration = 0.3f;
static CGFloat const kFloatingLabelHideAnimationDuration = 0.3f;
static CGFloat const kLineViewHeight = 0.5f;


@interface JVFloatLabeledTextField()

@property (nonatomic, strong) CALayer* bottomBorderLayer;
@property (nonatomic, strong) UIToolbar* numberToolbar;
@property (nonatomic, strong) UIBarButtonItem *clear_btn;
@property (nonatomic, strong) UIBarButtonItem *done_btn;
@property (nonatomic, strong) UIDatePicker* datePicker;
@end

@implementation JVFloatLabeledTextField
{
    BOOL _isFloatingLabelFontDefault;
    
    //masking character for blank parts;
    NSString *numericBlank;
    NSString *alphaNumericBlank;
    NSString *letterBlank;
    UITextField *maskedTextField;
    //user input is stored here
    NSString *inputText;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
        
    }
    return self;
}

-(void)configureViewShowMask:(BOOL)showMask
{
    
    
    if (showMask)
    {
        inputText = @"";
        numericBlank      = @"_";
        alphaNumericBlank = @"_";
        letterBlank       = @"_";
        [self configureTextField];
        [self textField:maskedTextField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
    }
    
}




-(void)configureTextField
{
    maskedTextField = self;
    /*
    [maskedTextField setFrame:self.bounds];
    [self addSubview:maskedTextField];
    maskedTextField.delegate = self;
     */
}








- (void)commonInit
{
    
    _floatingLabel = [UILabel new];
    _floatingLabel.alpha = 0.0f;
    [self addSubview:_floatingLabel];
	
    // some basic default fonts/colors
    _floatingLabelFont = [self defaultFloatingLabelFont];
    _floatingLabel.font = _floatingLabelFont;
    _floatingLabelTextColor = [UIColor grayColor];
    _floatingLabel.textColor = _floatingLabelTextColor;
    _animateEvenIfNotFirstResponder = NO;
    _floatingLabelShowAnimationDuration = kFloatingLabelShowAnimationDuration;
    _floatingLabelHideAnimationDuration = kFloatingLabelHideAnimationDuration;
    
    
    [self setValue:[self colorFromHexString:@"#666666"] forKeyPath:@"_placeholderLabel.textColor"];
    [self setFloatingLabelText:self.placeholder];

    _adjustsClearButtonRect = YES;
    _isFloatingLabelFontDefault = YES;
    
    self.delegate = self;
    
    
   
   
   
    
    
    
}
#pragma mark - Text Field Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(_isMaskNeed)
    {
        [self selectTextForInput:textField atRange:NSMakeRange([self calculateCaretLocation], 0)];
        
         if (inputText.length == 0)
         {
         [self textField:maskedTextField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
         }
        
    }
    
    
    
    
   
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    if(_isMaskNeed)
    {
        if (inputText.length == 0)
        {
            textField.text = @"";
        }
    }
    
    
    
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(_isMaskNeed)
    {
        return [self applySimpleMaskOnTextfield:textField range:range replacementString:string];
    }
    else
    {
        return YES;
    }
    
}



#pragma mark -
- (void)selectTextForInput:(UITextField *)input atRange:(NSRange)range
{
    UITextPosition *start = [input positionFromPosition:[input beginningOfDocument]
                                                 offset:range.location];
    UITextPosition *end = [input positionFromPosition:start
                                               offset:range.length];
    [input setSelectedTextRange:[input textRangeFromPosition:start toPosition:end]];
}
- (NSUInteger)calculateCaretLocation
{
    int k = 0;
    NSUInteger caretLoc = -1;
    for (int i = 0; i < _maskCode.length; i++)
    {
        NSString* formatCharacter = [_maskCode substringWithRange:NSMakeRange(i, 1)];
        if ([self isSpecialCharacter:formatCharacter])
        {
            if (k == inputText.length)
            {
                caretLoc = i;
            }
            k++;
        }
    }
    if (caretLoc == -1)
    {
        caretLoc = _maskCode.length;
    }
    return caretLoc;
}

- (void)setIsMaskNeed:(BOOL)isMaskNeed {
    
    _isMaskNeed = isMaskNeed;
   
     [self configureViewShowMask:isMaskNeed];
    
    
}



- (void)setMaskCode:(NSString*)maskCode {
    
    _maskCode = maskCode;
    [maskedTextField resignFirstResponder];
    [self autoKeyboardDecision];
    maskedTextField.text = @"";
    
}
- (NSString*)getRawInputText
{
    return inputText;
}
-(UITextField*)maskedTextField
{
    return maskedTextField;
}
- (void)setIsBottomBorderEnabled:(BOOL)isBottomBorderEnabled {
    
        _isBottomBorderEnabled = isBottomBorderEnabled;
        if (isBottomBorderEnabled) {
                if (!_bottomBorderLayer) {
                        // add bottom border
                        _bottomBorderLayer = [[CALayer alloc] init];
                        _bottomBorderLayer.backgroundColor = [self colorFromHexString:@"#999999"].CGColor;
                        [self.layer addSublayer:_bottomBorderLayer];
                    }
            } else {
                    [_bottomBorderLayer removeFromSuperlayer];
                }
}
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
- (void)setIsDatePicker:(BOOL)isDatePicker {
    
    _isDatePicker = isDatePicker;
    
    if(isDatePicker)
    {
        if(!_datePicker)
        {
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDate *currentDate = [NSDate date];
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            [comps setYear:-21];
            NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
            [comps setYear:-80];
            NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
            
            
            _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
            [_datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
            _datePicker.backgroundColor = [UIColor whiteColor];
            _datePicker.datePickerMode = UIDatePickerModeDate;
            
            [_datePicker setMaximumDate:maxDate];
            [_datePicker setMinimumDate:minDate];
            
            self.inputView = _datePicker;
            
        }
    }
    else
    {
        [_datePicker removeFromSuperview];
    }
        

    
}
-(void)onDatePickerValueChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy"];
    self.text = [dateFormat stringFromDate:datePicker.date];
}

#define BUFFER_SIZE 32
- (void)setRawInput:(NSString*)rawInput
{
    int hardIndex = 0;
    NSArray *indexArr = [self getSpecialCharIndexArray];
    
    NSRange range = { 0, BUFFER_SIZE };
    NSUInteger end = [rawInput length];
    while (range.location < end)
    {
        unichar buffer[BUFFER_SIZE];
        if (range.location + range.length > end)
        {
            range.length = end - range.location;
        }
        [rawInput getCharacters: buffer range: range];
        range.location += BUFFER_SIZE;
        for (unsigned i=0 ; i<range.length ; i++)
        {
            
            if (hardIndex >= indexArr.count)
            {
                return;
            }
            
            unichar c = buffer[i];
            NSString* s = [NSString stringWithCharacters:&c length:1];
            
            int loc = [[indexArr objectAtIndex:hardIndex] intValue];
            [self applySimpleMaskOnTextfield:self.maskedTextField range:NSMakeRange(loc, 1) replacementString:s];
            
            hardIndex++;
        }
    }
}
-(NSArray*)getSpecialCharIndexArray
{
    int hardIndex = 0;
    
    NSMutableArray *indexArr = [[NSMutableArray alloc] init];
    NSRange range = { 0, BUFFER_SIZE };
    NSUInteger end = [_maskCode length];
    while (range.location < end)
    {
        unichar buffer[BUFFER_SIZE];
        if (range.location + range.length > end)
        {
            range.length = end - range.location;
        }
        [_maskCode getCharacters: buffer range: range];
        range.location += BUFFER_SIZE;
        for (unsigned i=0 ; i<range.length ; i++)
        {
            hardIndex++;
            
            unichar c = buffer[i];
            NSString* s = [NSString stringWithCharacters:&c length:1];
            if ([self isSpecialCharacter:s])
            {
                [indexArr addObject:[NSNumber numberWithInt:hardIndex]];
            }
        }
    }
    return [NSArray arrayWithArray:indexArr];
}
-(void)autoKeyboardDecision
{
    int hardIndex = 0;
    NSRange range = { 0, BUFFER_SIZE };
    NSUInteger end = [_maskCode length];
    while (range.location < end)
    {
        unichar buffer[BUFFER_SIZE];
        if (range.location + range.length > end)
        {
            range.length = end - range.location;
        }
        [_maskCode getCharacters: buffer range: range];
        range.location += BUFFER_SIZE;
        for (unsigned i=0 ; i<range.length ; i++)
        {
            hardIndex++;
            
            unichar c = buffer[i];
            NSString* s = [NSString stringWithCharacters:&c length:1];
            if ([s isEqualToString:MASK_CHAR_ALPHANUMERIC] ||
                [s isEqualToString:MASK_CHAR_LETTER])
            {
                return;
            }
        }
    }
    [maskedTextField setKeyboardType:UIKeyboardTypeNumberPad];
}
#pragma mark - Main Masking Operation
- (BOOL)applySimpleMaskOnTextfield:(UITextField*)textField range:(NSRange)range replacementString:(NSString *)string
{
    
    if ([string isEqualToString:@""])
    {
        //Delete character mode
        inputText = [inputText substringToIndex:inputText.length-(inputText.length>0)];
    }
    else
    {
        //Add character mode
        
        //dont allow a longer string to be pasted (is it disabled by the button already)
        if (string.length > 1)
        {
            return NO;
        }
        //return if the input value is different
        if (![self isStringValidForMask:string])
        {
            return NO;
        }
        //add one character
        inputText = [inputText stringByAppendingString:string];
        
    }
    
   
    
    NSString *finalString = @"";
    int k = 0;
    NSUInteger caretLocation = -1;
    for (int i = 0; i < _maskCode.length; i++)
    {
        NSString* formatCharacter = [_maskCode substringWithRange:NSMakeRange(i, 1)];
        if ([self isSpecialCharacter:formatCharacter])
        {
            if (k < inputText.length)
            {
                NSString *inputSubstring = [inputText substringWithRange:NSMakeRange(k, 1)];
                k++;
                
                finalString = [finalString stringByAppendingString:inputSubstring];
               
            }
            else
            {
                
                finalString = [finalString stringByAppendingString:[self blankForSpecialCharacter:formatCharacter]];
            }
            
        }
        else
        {
            finalString = [finalString stringByAppendingString:formatCharacter];
            
        }
    }
    
    caretLocation = [self calculateCaretLocation];
    
    //set the text manually
    textField.text = finalString;
    [self selectTextForInput:textField atRange:NSMakeRange(caretLocation, 0)];
    
    return NO;
}

- (void)showMask
{
    inputText = @"";
    [self textField:maskedTextField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
}

#pragma mark - characterSet Validation

- (BOOL)isStringValidForMask: (NSString*)string
{
    int counter = 0;
    
    //iterate through the format string until the next special character slot to be edited is found
    for (int i = 0; i < _maskCode.length; i++)
    {
        NSString* formatCharacter = [_maskCode substringWithRange:NSMakeRange(i, 1)];
        if ([self isSpecialCharacter:formatCharacter])
        {
            //"counter"th special character
            
            //current mask character is to be tested with a valid character set
            if (counter == inputText.length)
            {
                NSCharacterSet* charSet = [self characterSetForSpecialCharacter:formatCharacter];
                NSRange r = [string rangeOfCharacterFromSet: charSet];
                
                if (r.location != NSNotFound)
                {
                    //string is valid for this set
                    return YES;
                }
                else
                {
                    return NO;
                }
            }
            counter++;
        }
    }
    return NO;
}

- (void)setHaveClearDone:(BOOL)haveClearDone {
  
    
    _haveClearDone = haveClearDone;
    if (haveClearDone) {
        if (!_numberToolbar) {
            
            _numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
            _numberToolbar.barStyle = UIBarStyleDefault; //настройка стиля для панели
            _numberToolbar.tintColor = [self colorFromHexString:@"#00B7F5"]; // настройка цвета кнопок
            
            _clear_btn = [[UIBarButtonItem alloc]initWithTitle:@"ОЧИСТИТЬ" style:UIBarButtonItemStyleBordered target:self action:@selector(clearField)];
            _done_btn = [[UIBarButtonItem alloc]initWithTitle:@"ГОТОВО >" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)];
            
            [_done_btn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont fontWithName:@"ALSSchlangesans-Bold" size:12], NSFontAttributeName,
                                              
                                              nil]
                                    forState:UIControlStateNormal];
            [_clear_btn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIFont fontWithName:@"ALSSchlangesans" size:12], NSFontAttributeName,
                                               
                                               nil]
                                     forState:UIControlStateNormal];
            
            
            //создание массива кнопок
            _numberToolbar.items = [NSArray arrayWithObjects: _clear_btn, // кнопка очистки поля
                                   [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], // пустое место для заполнения пространства панели
                                   _done_btn,nil];//кнопка завершения ввода
            
            [_numberToolbar sizeToFit]; //метод корректного масштабирования панели
            
           
            self.inputAccessoryView = _numberToolbar; // применение новой панели к нужному текстовому полю
           
        }
    } else {
       
        [_numberToolbar removeFromSuperview];
        
    }
}


- (void)doneWithNumberPad
{
    [self resignFirstResponder];
    
}
- (void)clearField
{
   
    if(_isMaskNeed)
    {
      
       inputText = @"";
      [self textField:maskedTextField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
        
    }
    else
    {
        self.text = @"";
    }
    
    
}
- (UIFont *)defaultFloatingLabelFont
{
    UIFont *textFieldFont = nil;
    
    if (!textFieldFont && self.attributedPlaceholder && self.attributedPlaceholder.length > 0) {
        textFieldFont = [self.attributedPlaceholder attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    }
    if (!textFieldFont && self.attributedText && self.attributedText.length > 0) {
        textFieldFont = [self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    }
    if (!textFieldFont) {
        textFieldFont = self.font;
    }
    
    return [UIFont fontWithName:textFieldFont.fontName size:roundf(textFieldFont.pointSize * 0.7f)];
}

- (void)updateDefaultFloatingLabelFont
{
    UIFont *derivedFont = [self defaultFloatingLabelFont];
    
    if (_isFloatingLabelFontDefault) {
        self.floatingLabelFont = derivedFont;
    }
    else {
        // dont apply to the label, just store for future use where floatingLabelFont may be reset to nil
        _floatingLabelFont = derivedFont;
    }
}

- (UIColor *)labelActiveColor
{
    if (_floatingLabelActiveTextColor) {
        return _floatingLabelActiveTextColor;
    }
    else if ([self respondsToSelector:@selector(tintColor)]) {
        return [self performSelector:@selector(tintColor)];
    }
    return [UIColor blueColor];
}

- (void)setFloatingLabelFont:(UIFont *)floatingLabelFont
{
    if (floatingLabelFont != nil) {
        _floatingLabelFont = floatingLabelFont;
    }
    _floatingLabel.font = _floatingLabelFont ? _floatingLabelFont : [self defaultFloatingLabelFont];
    _isFloatingLabelFontDefault = floatingLabelFont == nil;
    [self setFloatingLabelText:self.placeholder];
    [self invalidateIntrinsicContentSize];
}

- (void)showFloatingLabel:(BOOL)animated
{
    void (^showBlock)() = ^{
        _floatingLabel.alpha = 1.0f;
        _floatingLabel.frame = CGRectMake(_floatingLabel.frame.origin.x,
                                          _floatingLabelYPadding,
                                          _floatingLabel.frame.size.width,
                                          _floatingLabel.frame.size.height);
    };
    
    if (animated || 0 != _animateEvenIfNotFirstResponder) {
        [UIView animateWithDuration:_floatingLabelShowAnimationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                         animations:showBlock
                         completion:nil];
    }
    else {
        showBlock();
    }
}

- (void)hideFloatingLabel:(BOOL)animated
{
    void (^hideBlock)() = ^{
        _floatingLabel.alpha = 0.0f;
        _floatingLabel.frame = CGRectMake(_floatingLabel.frame.origin.x,
                                          _floatingLabel.font.lineHeight + _placeholderYPadding,
                                          _floatingLabel.frame.size.width,
                                          _floatingLabel.frame.size.height);

    };
    
    if (animated || 0 != _animateEvenIfNotFirstResponder) {
        [UIView animateWithDuration:_floatingLabelHideAnimationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                         animations:hideBlock
                         completion:nil];
    }
    else {
        hideBlock();
    }
}

- (void)setLabelOriginForTextAlignment
{
    CGRect textRect = [self textRectForBounds:self.bounds];
    
    CGFloat originX = textRect.origin.x;
    
    if (self.textAlignment == NSTextAlignmentCenter) {
        originX = textRect.origin.x + (textRect.size.width/2) - (_floatingLabel.frame.size.width/2);
    }
    else if (self.textAlignment == NSTextAlignmentRight) {
        originX = textRect.origin.x + textRect.size.width - _floatingLabel.frame.size.width;
    }
    else if (self.textAlignment == NSTextAlignmentNatural) {
        JVTextDirection baseDirection = [_floatingLabel.text getBaseDirection];
        if (baseDirection == JVTextDirectionRightToLeft) {
            originX = textRect.origin.x + textRect.size.width - _floatingLabel.frame.size.width;
        }
    }
    
    _floatingLabel.frame = CGRectMake(originX + _floatingLabelXPadding, _floatingLabel.frame.origin.y,
                                      _floatingLabel.frame.size.width, _floatingLabel.frame.size.height);
}

- (void)setFloatingLabelText:(NSString *)text
{
    _floatingLabel.text = text;
    [self setNeedsLayout];
}

#pragma mark - UITextField

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self updateDefaultFloatingLabelFont];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self updateDefaultFloatingLabelFont];
}

- (CGSize)intrinsicContentSize
{
    CGSize textFieldIntrinsicContentSize = [super intrinsicContentSize];
    [_floatingLabel sizeToFit];
    return CGSizeMake(textFieldIntrinsicContentSize.width,
                      textFieldIntrinsicContentSize.height + _floatingLabelYPadding + _floatingLabel.bounds.size.height);
}

- (void)setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:placeholder];
    [self setFloatingLabelText:placeholder];
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder
{
    [super setAttributedPlaceholder:attributedPlaceholder];
    [self setFloatingLabelText:attributedPlaceholder.string];
    [self updateDefaultFloatingLabelFont];
}

- (void)setPlaceholder:(NSString *)placeholder floatingTitle:(NSString *)floatingTitle
{
    [super setPlaceholder:placeholder];
    [self setFloatingLabelText:floatingTitle];
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect rect = [super textRectForBounds:bounds];
    if ([self.text length] || self.keepBaseline) {
        rect = [self insetRectForBounds:rect];
    }
    return CGRectIntegral(rect);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect rect = [super editingRectForBounds:bounds];
    if ([self.text length] || self.keepBaseline) {
        rect = [self insetRectForBounds:rect];
    }
    return CGRectIntegral(rect);
}

- (CGRect)insetRectForBounds:(CGRect)rect {
    CGFloat topInset = ceilf(_floatingLabel.bounds.size.height + _placeholderYPadding);
    topInset = MIN(topInset, [self maxTopInset]);
    return CGRectMake(rect.origin.x, rect.origin.y + topInset / 2.0f, rect.size.width, rect.size.height);
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    CGRect rect = [super clearButtonRectForBounds:bounds];
    if (0 != self.adjustsClearButtonRect) {
        if ([self.text length] || self.keepBaseline) {
            CGFloat topInset = ceilf(_floatingLabel.font.lineHeight + _placeholderYPadding);
            topInset = MIN(topInset, [self maxTopInset]);
            rect = CGRectMake(rect.origin.x, rect.origin.y + topInset / 2.0f, rect.size.width, rect.size.height);
        }
    }
    return CGRectIntegral(rect);
}

- (CGFloat)maxTopInset
{
    return MAX(0, floorf(self.bounds.size.height - self.font.lineHeight - 4.0f));
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [super setTextAlignment:textAlignment];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setLabelOriginForTextAlignment];
    
    CGSize floatingLabelSize = [_floatingLabel sizeThatFits:_floatingLabel.superview.bounds.size];
    
    _floatingLabel.frame = CGRectMake(_floatingLabel.frame.origin.x,
                                      _floatingLabel.frame.origin.y,
                                      floatingLabelSize.width,
                                      floatingLabelSize.height);
    
    BOOL firstResponder = self.isFirstResponder;
    _floatingLabel.textColor = (firstResponder && self.text && self.text.length > 0 ?
                                self.labelActiveColor : self.floatingLabelTextColor);
    if (!self.text || 0 == [self.text length]) {
        [self hideFloatingLabel:firstResponder];
    }
    else {
        [self showFloatingLabel:firstResponder];
    }
    _bottomBorderLayer.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), kLineViewHeight);
}

#pragma mark - Special Character (MASK_CHAR_x)

-(BOOL)isSpecialCharacter: (NSString*)specialCharacter
{
    return  [specialCharacter isEqualToString:MASK_CHAR_NUMERIC]      ||
    [specialCharacter isEqualToString:MASK_CHAR_ALPHANUMERIC] ||
    [specialCharacter isEqualToString:MASK_CHAR_LETTER];
}

-(NSString*)blankForSpecialCharacter:(NSString*)specialCharacter
{
    if ([specialCharacter isEqualToString:MASK_CHAR_NUMERIC])
    {
        
        return numericBlank;
    }
    else if ([specialCharacter isEqualToString:MASK_CHAR_ALPHANUMERIC])
    {
        return alphaNumericBlank;
    }
    else if ([specialCharacter isEqualToString:MASK_CHAR_LETTER])
    {
        return letterBlank;
    }
    else
    {
        return @"_";
    }
}
- (BOOL)isFieldComplete
{
    NSString *speacialChars = [NSString stringWithFormat:@"%@%@%@",MASK_CHAR_ALPHANUMERIC,MASK_CHAR_NUMERIC,MASK_CHAR_LETTER];
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:speacialChars] invertedSet];
    NSString *rawFormat = [_maskCode stringByTrimmingCharactersInSet:characterSet];
    rawFormat = [rawFormat stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return rawFormat.length == inputText.length;
}
-(NSCharacterSet*)characterSetForSpecialCharacter: (NSString*)specialCharacter
{
    if ([specialCharacter isEqualToString:MASK_CHAR_NUMERIC])
    {
        return [NSCharacterSet decimalDigitCharacterSet];
    }
    else if ([specialCharacter isEqualToString:MASK_CHAR_ALPHANUMERIC])
    {
        return [NSCharacterSet alphanumericCharacterSet];
    }
    else if ([specialCharacter isEqualToString:MASK_CHAR_LETTER])
    {
        return [NSCharacterSet letterCharacterSet];
    }
    else
    {
        return nil;
    }
}
#pragma mark - Clear

-(void)dealloc
{
    maskedTextField.delegate = nil;
}

@end
