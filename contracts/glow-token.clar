;; GlowToken Contract

(define-fungible-token glow-token)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant reward-amount u100)

;; Public Functions
(define-public (mint (recipient principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ft-mint? glow-token reward-amount recipient)
  )
)

(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (ft-transfer? glow-token amount sender recipient)
)
