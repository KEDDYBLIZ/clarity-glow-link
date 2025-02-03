;; GlowLink Main Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-invalid-skin-type (err u102))

;; Data Maps
(define-map UserProfiles
  principal
  {
    skin-type: (string-ascii 20),
    routines: (list 100 uint),
    reputation: uint
  }
)

(define-map Routines
  uint
  {
    creator: principal,
    weather-type: (string-ascii 20),
    skin-type: (string-ascii 20),
    steps: (list 10 (string-utf8 256)),
    votes: uint
  }
)

;; Variables
(define-data-var routine-counter uint u0)

;; Public Functions
(define-public (create-profile (skin-type (string-ascii 20)))
  (begin
    (asserts! (is-valid-skin-type skin-type) err-invalid-skin-type)
    (ok (map-set UserProfiles tx-sender {
      skin-type: skin-type,
      routines: (list),
      reputation: u0
    }))
  )
)

(define-public (create-routine (weather-type (string-ascii 20)) 
                             (skin-type (string-ascii 20))
                             (steps (list 10 (string-utf8 256))))
  (let ((routine-id (+ (var-get routine-counter) u1)))
    (begin
      (var-set routine-counter routine-id)
      (ok (map-set Routines routine-id {
        creator: tx-sender,
        weather-type: weather-type,
        skin-type: skin-type,
        steps: steps,
        votes: u0
      }))
    )
  )
)

;; Read Only Functions
(define-read-only (get-profile (user principal))
  (ok (map-get? UserProfiles user))
)

(define-read-only (get-routine (routine-id uint))
  (ok (map-get? Routines routine-id))
)
