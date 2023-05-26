import UIKit
final class SingleImageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var image: UIImage!{
        didSet{
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        scrollView.delegate = self
        
        super.viewDidLoad()
        imageView.image = image
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 2.0
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        if let shareimage = imageView.image {
            let shareController = UIActivityViewController(activityItems: [shareimage], applicationActivities: nil)
            present(shareController, animated: true, completion: nil)
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image:UIImage) {
        
        let minZommScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZommScale,max(hScale,vScale)))
        scrollView.setZoomScale(scale, animated: true)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }

}

//MARK: - Extension SingleImageViewController UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
}
