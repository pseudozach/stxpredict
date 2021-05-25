(define-constant openOracleSource "coinbase")
(define-constant openOracleSymbol "BTC")

(define-read-only (readMarketThreshold (marketId int))
  (begin
    (contract-call? 'ST15RGYVK9ACFQWMFFA2TVASDVZH38B4VAV4WF6BJ.stxpredict_v4 readMarketThreshold marketId)
  )
)

;; public function for a user to call to request resolution of a market
(define-public (requestResolution (marketId int))
  (let (
    (result (unwrap-panic (decideResolution marketId)))
    (currentvalue (to-int (unwrap-panic (get amount (getOraclePrice)))))
    )
    (if (is-eq result true)
      (ok (resolveMarket marketId result))
      (ok (resolveMarket marketId result))
    )
  )
)

(define-private (decideResolution (marketId int))
  (let (
    (threshold (default-to 0 (unwrap-panic (readMarketThreshold marketId))))
    (currentvalue (to-int (unwrap-panic (get amount (getOraclePrice)))))
    )
    (if (> currentvalue threshold)
      (ok true)
      (ok false)
    )
  )
)

(define-private (resolveMarket (marketId int) (result bool))
  (begin
    (contract-call? 'ST15RGYVK9ACFQWMFFA2TVASDVZH38B4VAV4WF6BJ.stxpredict_v4 resolveMarket marketId result)
  )
)

;; psq signed oracle from exchanges
;; STZ0RAC1EFTH949T4W2SYY6YBHJRMAF4ED5QB123.oracle-v1
(define-private (getOraclePrice)
  (contract-call? 'STZ0RAC1EFTH949T4W2SYY6YBHJRMAF4ED5QB123.oracle-v1 get-price openOracleSource openOracleSymbol)
)
