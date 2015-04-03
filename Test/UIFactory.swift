
import UIKit

let UIFactory = UIFactoryClass();

extension UIFont {
    func sizeOfString (string: String, constrainedToWidth width: Double = DBL_MAX) -> CGSize {
        return NSString(string: string).boundingRectWithSize(CGSize(width: width, height: DBL_MAX),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName: self],
            context: nil).size
    }
}

extension UIView {
    var height: CGFloat { 
        get{ return(self.frame.size.height); }
        set(h){ self.frame = UIFactory.rect(self.x, self.y, self.width, h); }
    }
    var width: CGFloat { 
        get{ return(self.frame.size.width); }
        set(w){ self.frame = UIFactory.rect(self.x, self.y, w, self.height); }
    }
    var x: CGFloat { 
        get{ return(self.frame.origin.x); }
        set(x){ self.frame = UIFactory.rect(x, self.y, self.width, self.height); }
    }
    var y: CGFloat { 
        get{ return(self.frame.origin.y); }
        set(y){ self.frame = UIFactory.rect(self.x, y, self.width, self.height); }
    }
    var minX: CGFloat { return(CGRectGetMinX(self.frame)); }
    var midX: CGFloat { return(CGRectGetMidX(self.frame)); }
    var maxX: CGFloat { return(CGRectGetMaxX(self.frame)); }
    var minY: CGFloat { return(CGRectGetMinY(self.frame)); }
    var midY: CGFloat { return(CGRectGetMidY(self.frame)); }
    var maxY: CGFloat { return(CGRectGetMaxY(self.frame)); }
}

class UIFactoryClass {

    enum FontType: String {
        case Light = "Lato-Light"
        case Regular = "Lato-Regular"
        case Bold = "Lato-Bold" 
    };

    init(){ }

    func globalStyling() {
        let tableSelectedBackgroudColor:UIColor = UIColorFromRGB(0xFBF5E3);
        let selectedColorView = UIView();
        selectedColorView.backgroundColor = tableSelectedBackgroudColor;
        UITableViewCell.appearance().selectedBackgroundView = selectedColorView
    }

    func rect(x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect { return CGRect(x: x, y: y, width: width, height: height); }
    func rect(x: Double, _ y: Double, _ width: Double, _ height: Double) -> CGRect { return CGRect(x: x, y: y, width: width, height: height); }

    func vcenter(parent: UIView, _ child: UIView){
        var childY = (parent.height - child.height) / 2.0;
        child.y = childY;
    }
 
    func hcenter(parent: UIView, _ child: UIView){
        var childX = (parent.width - child.width) / 2.0;
        child.x = childX;
    }

    func color(rgbValue: UInt) -> UIColor {
        return UIColor(
                       red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                       alpha: CGFloat(1.0))
    }

    func color(r: Int, _ g: Int, _ b: Int) -> UIColor { return color(r, g, b, 1.0); }
    func color(red: Int, _ green: Int, _ blue: Int, _ alpha: Double) -> UIColor {
        var r = CGFloat(red)/255.0;
        var g = CGFloat(green)/255.0;
        var b = CGFloat(blue)/255.0;
        var a = CGFloat(alpha);

        return UIColor(red: r, green: g, blue: b, alpha: a);
    }

    func goldColor() -> UIColor {
        return self.color(212, 175, 55);
    }

    func grayColor() -> UIColor {
        return self.color(190, 190, 190);
    }

    func lightGrayColor() -> UIColor {
        return self.color(216, 216, 216);
    }

    func roundImageView(image: UIImageView) {
        image.layer.cornerRadius = image.frame.size.width / 2;
        image.clipsToBounds = true;
    }

    // this is calculated by vcenter in NavBar, and then I use
    // the value here to line up a few other buttons, like the modal "X"
    func navBarButtonTop() -> CGFloat {
        return(19.5);
    }

    func navBarButtonSide() -> CGFloat {
        return(45.0);
    }

    func font(type: FontType, _ size: CGFloat) -> UIFont {
        return UIFont(name: labelFont(type), size: size)!;
    }

    func font(control: UILabel, _ size: CGFloat) {
        font(control, .Regular, size);
    }

    func font(control: UILabel, _ font: FontType, _ size: CGFloat) {
        control.font = UIFont(name: labelFont(font), size: size);
    }

    func font(control: UITextView, _ font: FontType, _ size: CGFloat) {
        control.font = UIFont(name: labelFont(font), size: size);
    }

    func font(control: UITextView, _ size: CGFloat) {
        font(control, .Regular, size);
    }


    func labelFont(font: FontType) -> String {
        return font.rawValue;
    }

    func label() -> UILabel { 
        return label(self.rect(0.0, 0.0, 0.0, 0.0));
    }

    func label(frame: CGRect) -> UILabel {
        return label(frame, font: .Regular)
    }

    func label(frame: CGRect, size: CGFloat) -> UILabel {
        return label(frame, font: .Regular, size: size)
    }

    func label(frame: CGRect, font: FontType) -> UILabel {
        return label(frame, font: .Regular, size: 16)
    }

    func label(frame: CGRect, font: FontType, size: CGFloat) -> UILabel {
        let label = UILabel(frame: frame);
        label.font = UIFont(name: labelFont(font), size: size);
        return label;
    }

    func buttonImage(image: UIImage) -> UIImage {
        return image.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
    }

    func view() -> UIView {

        let view = UIView(frame: UIScreen.mainScreen().applicationFrame);

        view.backgroundColor = UIColor.whiteColor();

        return(view);
    }

    func setLabelHeight(label: UILabel) {
        if let text = label.text {
            var size = label.font.sizeOfString(text, constrainedToWidth: Double(label.width));
            label.height = size.height;
        }
    }

    func mock(view: UIView, _ title: String){
        mock(view, title, 40);
    }

    func mock(view: UIView, _ title: String, _ size: CGFloat){
        mock(view, title, size, 0.0);
    }

    func mock(view: UIView, _ title: String, _ size: CGFloat, _ yOffset: CGFloat){
        let bottom = view.maxY;
        let labelY = (view.midY - size) + yOffset
        let labelWidth = view.maxX;

        let labelFrame = self.rect(0.0, labelY, labelWidth, size + 5);

        let label = UIFactory.label(labelFrame, font: .Bold, size: size);

        label.textAlignment = NSTextAlignment.Center;
        label.text = title;

        view.addSubview(label);
    }


    var _hamburgerIcon : UIImage?;

    func hamburgerIcon() -> UIImage {
        
        if(_hamburgerIcon != nil){ return _hamburgerIcon!; }

        UIGraphicsBeginImageContextWithOptions(CGSizeMake(20.0, 13.0), false, 0.0);
        
        self.goldColor().setFill();
        UIBezierPath(rect: CGRectMake(0, 0, 20, 2)).fill();
        UIBezierPath(rect: CGRectMake(0, 5, 20, 2)).fill();
        UIBezierPath(rect: CGRectMake(0, 10, 20, 2)).fill();
        
        _hamburgerIcon = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return _hamburgerIcon!;
    }

    func groupDrawerIconLarge(text: String) -> UIImage {
        
        let side: CGFloat = 26;

        UIGraphicsBeginImageContextWithOptions(CGSizeMake(side, side), false, 0.0);
        var context = UIGraphicsGetCurrentContext();

        self.goldColor().setFill();

        CGContextFillEllipseInRect(context, CGRectMake(0, 0, side, side));

        // NSColor(calibratedRed: 0.147, green: 0.222, blue: 0.162, alpha: 1.0)
        var font = self.font(.Regular, 20.0);
        let textColor = UIColor.whiteColor();

        let textFontAttributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: textColor,
        ]

        var letterSize = text.sizeWithAttributes(textFontAttributes);

        // Calculate height & width, and center text in context
        var x: CGFloat = (side - letterSize.width) / 2;
        var y: CGFloat = (side - letterSize.height) / 2;
        y -= 1; // make it higher rather than lower

        text.drawAtPoint(CGPointMake(x, y), withAttributes: textFontAttributes);

        var icon = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return icon;
    }

    func groupDrawerIcon(text: String) -> UIImage {
        
        let side: CGFloat = 26;

        UIGraphicsBeginImageContextWithOptions(CGSizeMake(side, side), false, 0.0);
        var context = UIGraphicsGetCurrentContext();

        self.goldColor().setFill();

        CGContextFillEllipseInRect(context, CGRectMake(0, 0, side, side));

        // NSColor(calibratedRed: 0.147, green: 0.222, blue: 0.162, alpha: 1.0)
        var font = self.font(.Regular, 20.0);
        let textColor = UIColor.whiteColor();

        let textFontAttributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: textColor,
        ]

        var letterSize = text.sizeWithAttributes(textFontAttributes);

        // Calculate height & width, and center text in context
        var x: CGFloat = (side - letterSize.width) / 2;
        var y: CGFloat = (side - letterSize.height) / 2;
        y -= 1; // make it higher rather than lower

        text.drawAtPoint(CGPointMake(x, y), withAttributes: textFontAttributes);

        var icon = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return icon;
    }

    func imageViewButton(imageName: String, target: AnyObject, selector: Selector) -> UIImageView {
        return imageViewButton(UIImage(named: imageName)!, target: target, selector: selector);
    }

    func imageViewButton(image: UIImage, target: AnyObject, selector: Selector) -> UIImageView {

        var imageView = UIImageView();
        imageView.image = image.imageWithRenderingMode(.AlwaysOriginal);
        imageView.userInteractionEnabled = true;

        var tapRecognizer = UITapGestureRecognizer(target: target, action: selector);
        tapRecognizer.numberOfTouchesRequired = 1;

        imageView.addGestureRecognizer(tapRecognizer);

        // imageView.frame = self.rect(0, 0, image.size.width, image.size.height);

        return(imageView);
    }

    func viewButton(target: AnyObject, selector: Selector) -> UIView {
        return(viewButton(CGRectZero, target: target, selector: selector));
    }

    func viewButton(frame: CGRect, target: AnyObject, selector: Selector) -> UIView {

        var view = UIView(frame: frame);
        detectTap(view, target: target, selector: selector);
        return(view);
    }

    func detectTap(view: UIView, target: AnyObject, selector: Selector) {
        var tapRecognizer = UITapGestureRecognizer(target: target, action: selector);
        tapRecognizer.numberOfTouchesRequired = 1;

        view.addGestureRecognizer(tapRecognizer);
    }

    var colors = [
        UIColor.redColor(),
        UIColor.greenColor(),
        UIColor.blueColor(),
        UIColor.cyanColor(),
        UIColor.yellowColor(),
        UIColor.magentaColor(),
        UIColor.orangeColor(),
        UIColor.purpleColor(),
        UIColor.brownColor()
    ];

    var _lastColor = 0;
    func getColor() -> UIColor {
        _lastColor++;
        if(_lastColor >= colors.count){
            _lastColor = 0;
        }

        return(colors[_lastColor]);
    }

    func colorViews(view: UIView) {
        view.backgroundColor = getColor();
        for sv in view.subviews {
            colorViews(sv as UIView);
        }
    }

    /*
        CGFloat lineWidth = 2;
        CGRect borderRect = CGRectMake(self.frame.size.width/2, self.frame.size.height - 20, 10.0, 10.0);
        borderRect = CGRectInset(borderRect, lineWidth * 0.5, lineWidth * 0.5);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBStrokeColor(context, 85.0/255.0, 143.0/255.0, 220.0/255.0, 1.0);
        CGContextSetRGBFillColor(context, 5.0/255.0, 43.0/255.0, 20.0/255.0, 1.0);
        CGContextSetLineWidth(context, 2.0);
        CGContextFillEllipseInRect (context, borderRect);
        CGContextStrokeEllipseInRect(context, borderRect);
        CGContextFillPath(context);
        */

}
