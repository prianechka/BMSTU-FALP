#(
  (and 'fee 'fie 'foe)            ; FOE 
  (or 'fee 'fie 'foe)             ; FEE
  (and (equal 'abc 'abc) 'yes)    ; YES
  (or nil 'fie 'foe)              ; FIE
  (and nil 'fie 'foe)             ; NIL
  (or (equal 'abc 'abc) 'yes)     ; T
)