;; tests
(createMarket "test1" u5 tx-sender u1618114840 "auto")
(var-get numberOfMarkets)
(map-get? marketDatabase {marketId:0}) ;; no such market
(map-get? marketDatabase {marketId:1})
(getBalance 1)
(getResolveTime 1)
(get-current-block-time)
(get-block-info? time block-height)
(joinMarket 1 false 2) ;; should fail because low amount
(joinMarket 5 true 1) ;; should fail because doesnt exist
(joinMarket 1 true 5)
(check-time-to-resolve 1)
(resolveMarket 1 true) ;; should fail until check-time-to-resolve = true
(map-get? marketDatabase {marketId:1})
(map-get? yesvoters {marketId:1})
(getBalance 1)
(getPayout 1)
(exitMarket 1)