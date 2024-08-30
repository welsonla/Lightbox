import UIKit

protocol HeaderViewDelegate: AnyObject {
  @MainActor
  func headerView(_ headerView: HeaderView, didPressRightButton deleteButton: UIButton)
  @MainActor
  func headerView(_ headerView: HeaderView, didPressCloseButton closeButton: UIButton)
}

open class HeaderView: UIView {
  open fileprivate(set) lazy var closeButton: UIButton = { [unowned self] in
    let title = NSAttributedString(
      string: LightboxConfig.CloseButton.text,
      attributes: LightboxConfig.CloseButton.textAttributes)

    let button = UIButton(type: .system)

    button.setAttributedTitle(title, for: UIControl.State())

    if let size = LightboxConfig.CloseButton.size {
      button.frame.size = size
    } else {
      button.sizeToFit()
    }

    button.addTarget(self, action: #selector(closeButtonDidPress(_:)),
      for: .touchUpInside)

    if let image = LightboxConfig.CloseButton.image {
        button.setBackgroundImage(image, for: UIControl.State())
    }

    button.isHidden = !LightboxConfig.CloseButton.enabled

    return button
  }()

  open fileprivate(set) lazy var rightButton: UIButton = { [unowned self] in
    let title = NSAttributedString(
      string: LightboxConfig.RightButton.text,
      attributes: LightboxConfig.RightButton.textAttributes)

    let button = UIButton(type: .system)
    button.imageView?.contentMode = .scaleAspectFit
    button.setAttributedTitle(title, for: .normal)
//      button.backgroundColor = .orange
    if let size = LightboxConfig.RightButton.size {
      button.frame.size = size
    } else {
      button.sizeToFit()
    }

    button.addTarget(self, action: #selector(deleteButtonDidPress(_:)),
      for: .touchUpInside)

    if let image = LightboxConfig.RightButton.image {
//        button.setBackgroundImage(image, for: UIControl.State())
        button.setImage(image, for: UIControl.State())
    }

    button.isHidden = !LightboxConfig.RightButton.enabled

    return button
  }()

  weak var delegate: (any HeaderViewDelegate)?

  // MARK: - Initializers

  public init() {
    super.init(frame: CGRect.zero)

    backgroundColor = UIColor.clear

    [closeButton, rightButton].forEach { addSubview($0) }
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Actions

  @objc func deleteButtonDidPress(_ button: UIButton) {
    delegate?.headerView(self, didPressRightButton: button)
  }

  @objc func closeButtonDidPress(_ button: UIButton) {
    delegate?.headerView(self, didPressCloseButton: button)
  }
}

// MARK: - LayoutConfigurable

extension HeaderView: LayoutConfigurable {

  @objc public func configureLayout() {
    let topPadding: CGFloat

    if #available(iOS 11, *) {
      topPadding = safeAreaInsets.top
    } else {
      topPadding = 0
    }

    rightButton.frame.origin = CGPoint(
      x: bounds.width - rightButton.frame.width - 17,
      y: topPadding
    )

    closeButton.frame.origin = CGPoint(
      x: 17,
      y: topPadding
    )
  }
}
