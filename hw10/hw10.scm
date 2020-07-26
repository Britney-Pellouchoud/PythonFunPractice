(define (accumulate combiner start n term)
	(define (helper combiner start n term total)
		(cond 
			((= n 0) (combiner start total))
			(else 
		 	(helper combiner start (- n 1) term (combiner total (term n)))
		  				)
			)
		)

(if (= 0 (combiner 1 0)) (helper combiner start n term 1) (helper combiner start n term 0))


  )
			
	
	

(define (accumulate-tail combiner start n term)
	
  (combiner start (accumulate combiner (term n) (- n 1) term))
	)


; (counter 3 '(1 2 3 3 3 3 3) 0)


(define (rle s)

	(define (helper first counter k)
	   (cond
	    ((null? k) (cons-stream (list first counter) nil))
	    ((= (car k) first) (helper first (+ 1 counter) (cdr-stream k)))
	    (else (cons-stream (list first counter) (helper (car k) 1 (cdr-stream k))))
	   )
	 )
 
 (if (null? s)
  '()
  (helper (car s) 1 (cdr-stream s))
 )	









)




	