import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    private var alertPresenter = AlertPresener()
    
    var imageURL: String!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        scrollView.delegate = self
    
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 2.0
        showImage()
    }
    
    func showImage() {
        UIBlockingProgressHUD.show()
        guard let url = URL(string: imageURL) else { return }
        imageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showAlert()
            }
        }
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
    
    private func showAlert(){
        let alert = UIAlertController(title: "Что-то пошло не так", message: "Попробовать ещё раз?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Не надо", style: .cancel)
        let action2 = UIAlertAction(title: "Повторить", style: .default) {_ in
            self.showImage()
        }
        alert.addAction(action1)
        alert.addAction(action2)
        self.present(alert, animated: true)
    }
    

}

//MARK: - Extension SingleImageViewController UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
}
