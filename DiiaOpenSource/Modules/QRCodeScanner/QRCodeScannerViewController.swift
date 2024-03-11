import UIKit
import AVKit
import DiiaMVPModule
import DiiaUIComponents

protocol QRCodeScannerView: BaseView {
    func showQRError(message: String?)
}

final class QRCodeScannerViewController: UIViewController, Storyboarded {
    
    // MARK: - Properties
    var presenter: QRCodeScannerAction!
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak private var previewContainer: UIView!
    @IBOutlet weak private var alertLabel: UILabel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCamera()
        presenter.configureView()
    }
    
    // MARK: - Setup
    private func setupCamera() {
        onGlobalUtilityQueue { [weak self] in
            guard let self = self else { return }
            self.captureSession = AVCaptureSession()
            onMainQueue { [weak self] in
                guard let self = self else { return }

                guard let device = AVCaptureDevice.default(for: .video) else {
                    self.showClosingAlert()
                    return
                }
                
                if let input = try? AVCaptureDeviceInput(device: device),
                    self.captureSession.canAddInput(input) {
                    self.captureSession.addInput(input)
                    self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                    self.previewLayer.videoGravity = .resizeAspectFill
                    self.previewLayer.frame = self.previewContainer.bounds
                    self.previewContainer.layer.addSublayer(self.previewLayer)
                    self.captureSession.startRunning()
                    
                    let metadataOutput = AVCaptureMetadataOutput()
                    let metaQueue = DispatchQueue(label: "MetaDataSession")
                    metadataOutput.setMetadataObjectsDelegate(self, queue: metaQueue)
                    if self.captureSession.canAddOutput(metadataOutput) {
                        self.captureSession.addOutput(metadataOutput)
                    } else {
                        self.showClosingAlert()
                    }
                    metadataOutput.metadataObjectTypes = [.qr]
                } else {
                    self.showClosingAlert()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.restart()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = previewContainer.bounds
    }
    
    // MARK: - Actions
    @IBAction private func backBtnPressed(_ sender: Any) {
        closeModule(animated: true)
    }
    
    private func showClosingAlert() {
        let alert = UIAlertController(title: R.Strings.photo_problem.localized(), message: R.Strings.photo_problem_description.localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: R.Strings.general_problem_ok.localized(), style: .default, handler: { [weak self] _ in
            self?.closeModule(animated: true)
        }))
        
        present(alert, animated: true)
    }
}

// MARK: - View logic
extension QRCodeScannerViewController: QRCodeScannerView {
    func showQRError(message: String?) {
        alertLabel.text = message
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension QRCodeScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        onMainQueue { [weak self] in
            guard let self = self, self.view.window != nil, self.children.count == 0 else { return }
            if metadataObjects.count == 0 || !self.presenter.shouldProceed() {
                self.showQRError(message: nil)
                return
            }
        
            if let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
                metadataObj.type == .qr {
                if let metaStr = metadataObj.stringValue {
                    self.presenter.proceed(code: metaStr)
                }
            } else {
                self.showQRError(message: nil)
            }
        }
    }
}
