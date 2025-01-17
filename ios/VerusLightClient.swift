//
//  VerusLightClient.swift
//  VerusLightClient
//
//  Created by Michael Filip Toutonghi on 28/02/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import ZcashLightClientKit
import MnemonicSwift

@objc(VerusLightClient)
class VerusLightClient : NSObject {
    // TODO: Add function to create coin wallets with databases here
    let MainWallet: WalletFolder = WalletFolder()
    
    @objc
    func deriveViewingKey(_ spendingKey: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        do {
            resolve(try DerivationTool.default.deriveViewingKey(spendingKey: spendingKey))
        } catch {
            reject(String(JsonRpcErrors.INTERNAL_ERROR), "Failed to derive viewing key.", error)
        }
    }
    
    @objc
    func deriveSpendingKeys(_ seed: String, isMnemonic: Bool, numberOfAccounts: Int, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        do {
            if (isMnemonic) {
                resolve(try DerivationTool.default.deriveSpendingKeys(seed: Mnemonic.deterministicSeedBytes(from: seed), numberOfAccounts: numberOfAccounts))
            } else {
                resolve(try DerivationTool.default.deriveSpendingKeys(seed: Array(seed.utf8), numberOfAccounts: numberOfAccounts))
            }
        } catch {
            reject(String(JsonRpcErrors.INTERNAL_ERROR), "Failed to derive spending keys.", error)
        }
    }

    @objc
    func deterministicSeedBytes(_ seed: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        do {
            try resolve(Mnemonic.deterministicSeedBytes(from: seed))
        } catch {
            reject(String(JsonRpcErrors.INTERNAL_ERROR), "Failed to derive seed bytes.", error)
        }
    }
    
    @objc
    func createWallet(_ coinId: String, coinProto: String, accountHash: String, address: String, port: Int, numAddresses: Int, viewingKeys: [String], birthday: Int, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        MainWallet.createWallet(coinId: coinId, coinProto: coinProto, accountHash: accountHash, address: address, port: port, numAddresses: numAddresses, viewingKeys: viewingKeys, spendParams: Bundle.main.url(forResource: "sapling-spend", withExtension: ".params")!, outputParams: Bundle.main.url(forResource: "sapling-output", withExtension: ".params")!, birthday: birthday)
        
        resolve(true)
    }
    
    @objc
    func openWallet(_ coinId: String, coinProto: String, accountHash: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        do {
            try MainWallet.openWallet(coinId: coinId, coinProto: coinProto, accountHash: accountHash)
            resolve(true)
        } catch {
            reject(String(JsonRpcErrors.START_SYNC_ERROR), "Failed to open " + coinId + " wallet.", error)
        }
    }
    
    @objc
    func closeWallet(_ coinId: String, coinProto: String, accountHash: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        do {
            try MainWallet.closeWallet(coinId: coinId, coinProto: coinProto, accountHash: accountHash)
            resolve(true)
        } catch {
            reject(String(JsonRpcErrors.START_SYNC_ERROR), "Failed to close " + coinId + " wallet.", error)
        }
    }
    
    @objc
    func deleteWallet(_ coinId: String, coinProto: String, accountHash: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        do {
            try MainWallet.deleteWallet(coinId: coinId, coinProto: coinProto, accountHash: accountHash)
            resolve(true)
        } catch {
            reject(String(JsonRpcErrors.START_SYNC_ERROR), "Failed to delete " + coinId + " wallet.", error)
        }
    }

    @objc
    func request(_ id: Int, method: String, params: [String], resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        guard params.count >= 3 else {
            resolve(formatApiResponse(id: id, result: "CoinID (ticker), account hash, and coin protocol not specified in parameter array.", error: RequestError.badRequestParams(desc: "CoinID (ticker), account hash, and coin protocol not specified in parameter array.")))
            return
        }

        MainWallet.makeJsRequest(coinId: params[0], coinProto: params[1], accountHash: params[2], id: id, method: method, params: Array(params[3...]), completion: { (id, result, error) in
            resolve(formatApiResponse(id: id, result: result, error: error))
        })
    }
    
    @objc
    func startSync(_ coinId: String, coinProto: String, accountHash: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        do {
            try MainWallet.startCoinSync(coinId: coinId, coinProto: coinProto, accountHash: accountHash)
            resolve(true)
        } catch {
            reject(String(JsonRpcErrors.START_SYNC_ERROR), "Failed to start " + coinId + " sync.", error)
        }
    }
    
    @objc
    func stopSync(_ coinId: String, coinProto: String, accountHash: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        do {
            try MainWallet.stopCoinSync(coinId: coinId, coinProto: coinProto, accountHash: accountHash)
            resolve(true)
        } catch {
            reject(String(JsonRpcErrors.STOP_SYNC_ERROR), "Failed to stop " + coinId + " sync.", error)
        }
    }
}

