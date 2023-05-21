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
        rescaleAndCenterImageInScrollView(image: image)
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        if let shareimage = imageView.image {
            let shareController = UIActivityViewController(activityItems: [shareimage], applicationActivities: nil)
            present(shareController, animated: true)
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image:UIImage) {
        let minZommScale = scrollView.minimumZoomScale //  Минимальный масштаб зумирования
        let maxZoomScale = scrollView.maximumZoomScale // Максимальный масштаб зумирования
        view.layoutIfNeeded() //Обновляем экран если требуется
        let visibleRectSize = scrollView.bounds.size // Размеры видимой части экрана (телефона)
        let imageSize = image.size //Размеры экрана
        let hScale = visibleRectSize.width / imageSize.width //Текущее соотношение высоты экрана к высоте картинки
        let vScale = visibleRectSize.height / imageSize.height //Текущее соотношение ширины экрана к ширине картинки
        let scale = min(maxZoomScale, max(minZommScale,min(hScale,vScale))) //минимальный масштаб

        scrollView.setZoomScale(scale, animated: true) //Новое значение масштабирования
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize // Размер представления содержимого
        let x = (newContentSize.width - visibleRectSize.width) / 2 //
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
