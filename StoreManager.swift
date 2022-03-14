//
//  StoreManager.swift
//  HypnoPluss
//
//  Created by Yalcin Emilli on 05.12.20.
//

import StoreKit

typealias FetchCompletionHandler = (([SKProduct]) -> Void)
typealias PurchaseCompletionHandler = ((SKPaymentTransaction?) -> Void)

class StoreManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    private var fetchedProducts = [SKProduct]()
    public var meineKurs = [Kurse]()
    private var productRequest: SKProductsRequest?
    @Published var transactionState: SKPaymentTransactionState?
    @Published var allProductKurse = [productKurse]()
    public var completePurchase = [String]() {
        didSet  {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                for index in self.allProductKurse.indices {
                    self.allProductKurse[index].isLocked =
                        !self.completePurchase.contains(self.allProductKurse[index].id)
                }
            }
        }
    }
    private var kurse = FetchJson()
    private var fetchCompletionHandler: FetchCompletionHandler?
    private var purchaseCompletionHandler: PurchaseCompletionHandler?
    private let userDefaultsKey = "PurchaseComplete"
    private var IDs = [String]()
    
    override init() {
        super.init()
        startObersingPaymentQueue()

        kurse.kurs.forEach { (kurs1) in
            IDs.append(kurs1.inappID)
        }
        
        fetchProducts { product in
            self.allProductKurse = product.map{productKurse(product: $0)}
        }
        if ((UserDefaults.standard.object(forKey: userDefaultsKey)) == nil) {
        UserDefaults.standard.setValue(completePurchase, forKey: userDefaultsKey)
        UserDefaults.standard.synchronize()
        }
        loadStoredPurchase()
   }
    
    func loadStoredPurchase() {
        if let storedPurchase = UserDefaults.standard.object(forKey: userDefaultsKey) as? [String] {
            self.completePurchase = storedPurchase
            UserDefaults.standard.synchronize()
        }
        print(self.completePurchase)
        self.completePurchase.forEach{ (kurs) in
            kurse.kurs.forEach{ (kurs12) in
                if (kurs12.inappID == kurs) {
                    self.meineKurs.append(kurs12)
                }
            }
            
        }
    }
    
    private func startObersingPaymentQueue() {
        SKPaymentQueue.default().add(self)
    }
    private func fetchProducts(_ completion: @escaping FetchCompletionHandler) {
        guard self.productRequest == nil else { return }
        
        fetchCompletionHandler = completion
        
        
        productRequest = SKProductsRequest(productIdentifiers: Set(IDs))
        productRequest?.delegate = self
        productRequest?.start()
        
    }
    
    private func buy(_ product: SKProduct, completion: @escaping PurchaseCompletionHandler) {
        purchaseCompletionHandler = completion
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func product(for identifier: String) -> SKProduct? {
        return fetchedProducts.first(where: {$0.productIdentifier == identifier})
    }
    
    func purchaseProduct(_ product: SKProduct) {
        startObersingPaymentQueue()
        buy(product) {_ in }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        dump(transactions)
        for transaction in transactions {
            var shouldFinisTransaction = false
            switch transaction.transactionState {
            case .purchased, .restored:
                completePurchase.append(transaction.payment.productIdentifier)
                kurse.kurs.forEach{ (kurs12) in
                    if (kurs12.inappID == transaction.payment.productIdentifier) {
                        self.meineKurs.append(kurs12)
                    }
                }
                shouldFinisTransaction = true
                break
            case .failed:
                shouldFinisTransaction = true
                break
            case .purchasing, .deferred:
                break
           @unknown default:
                break
            }
            
            if shouldFinisTransaction {
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.purchaseCompletionHandler?(transaction)
                    self.purchaseCompletionHandler = nil
                }
                
            }
        }
        
        if !completePurchase.isEmpty {
            UserDefaults.standard.setValue(completePurchase, forKey: userDefaultsKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    func restoreProducts() {
        print("Restoring products ...")
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func purchaseProduct(product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            print("User can't make payment.")
        }
        
        
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        let loadedProducts = response.products
        let invalidPrduct = response.invalidProductIdentifiers
        
        
        guard !loadedProducts.isEmpty else {
                print("Keine Produkte")
            if !invalidPrduct.isEmpty {
                print("Invalid identifiers found: \(invalidPrduct)")
            }
            productRequest = nil
            return
        }
        fetchedProducts = loadedProducts
        DispatchQueue.main.async {
            self.fetchCompletionHandler?(loadedProducts)
            self.fetchCompletionHandler = nil
            self.productRequest = nil
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Request did fail: \(error)")
    }
    
}
