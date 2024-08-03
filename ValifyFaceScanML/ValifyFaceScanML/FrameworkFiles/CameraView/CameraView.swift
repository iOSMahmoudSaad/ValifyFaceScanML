//
//  CameraView.swift
//  ValifyFaceScanML
//
//  Created by Mahmoud Saad on 03/08/2024.
//

import UIKit
import AVFoundation

class CameraView: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // MARK: - Property
    
    public var didClose:(() -> Void)?
    public var didCapturePhoto: ((UIImage?) -> Void)?
    
    
    var drawings: [CAShapeLayer] = []
    var previewLayer:AVCaptureVideoPreviewLayer!

    private let captureSession = AVCaptureSession()
    private var captureDevice:AVCaptureDevice!
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private var isCapturedPhoto = false
    
    
    
    private let CaptureButton: UIButton = {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 5
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    private let cancelButton: UIButton = {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InitUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkCameraPermissions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    private func InitUI() {
        
        view.backgroundColor = .black
        view.addSubview(CaptureButton)
        view.addSubview(cancelButton)
        
        CaptureButton.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height - 100)
        cancelButton.center = CGPoint(x: 50, y: view.frame.size.height - 100)
        CaptureButton.addTarget(self, action: #selector(didTapCapturePhoto), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didCancel), for: .touchUpInside)
        
    }
    
    private func checkCameraPermissions() {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                
                guard granted else {
                    
                    DispatchQueue.main.async { self?.didClose?() }
                    return
                }
                DispatchQueue.main.async { self?.prepareCamera() }
            }
            
        case .authorized:
            
            DispatchQueue.main.async { self.prepareCamera() }
            
        case .denied, .restricted:
            
            didClose?()
            
        @unknown default:
            break
        }
    }
    
    @objc private func didTapCapturePhoto() {
        
        isCapturedPhoto = true
    }
    
    @objc private func didCancel() {
        
        didClose?()
    }
}
    
extension CameraView: AVCapturePhotoCaptureDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            
            debugPrint(" Cant access image from the sample buffer")
            return
        }
        
        detectFace(image: frame, completion: { [weak self] isFace in
            if self!.isCapturedPhoto {
                
                self!.isCapturedPhoto = false
                
                if !isFace { return }
                
                self?.stopCaputreSession()
                
                DispatchQueue.main.async {
                    
                    let ciImage = CIImage(cvImageBuffer: frame)
                    let image = UIImage(ciImage: ciImage)
                    
                    let previewPhotoView = PreviewPhotoView.initWith(image)
                    previewPhotoView.didConfirmPhoto = { [weak self] img in
                        self?.didCapturePhoto?(img)
                    }
                    self?.navigationController?.pushViewController(previewPhotoView, animated: false)
                }
            }
        })
    }
}


extension CameraView {
    
    func prepareCamera() {
        
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        if let availableDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .front).devices.first {
            
            captureDevice = availableDevice
            beginSession()
        }
    }
    
    func beginSession () {
        
        getInputSettings()
        
        showCameraView()
        
        startSession()
        
        getCameraFrames()
        
        captureSession.commitConfiguration()
    }
    
    func startSession() {
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            
            guard let self = self else { return }
            self.captureSession.startRunning()
        }
    }
    
    private func getInputSettings() {
        
        do {
            
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
            
        } catch {
            
            print(error.localizedDescription)
        }
    }
    
    private func showCameraView() {
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer = previewLayer
        self.view.layer.addSublayer(self.previewLayer)
        self.previewLayer.frame = self.view.layer.frame
    }
    
    private func getCameraFrames() {
        
        videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString): NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]
        
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        let queue = DispatchQueue(label: "camera_frame_processing_queue")
        videoDataOutput.setSampleBufferDelegate(self, queue: queue)
        
        captureSession.addOutput(videoDataOutput)
        
        guard let connection = videoDataOutput.connection(with: .video), connection.isVideoOrientationSupported else {
            return
        }
        connection.videoOrientation = .portrait
        connection.isVideoMirrored = true
    }
    
    func stopCaputreSession() {
        
        captureSession.stopRunning()
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            
            for input in inputs {
                
                self.captureSession.removeInput(input)
            }
        }
        
        if let outputs = captureSession.outputs as? [AVCaptureVideoDataOutput] {
            
            for output in outputs {
                
                self.captureSession.removeOutput(output)
            }
        }
    }
}
