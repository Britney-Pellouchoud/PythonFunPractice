(define (cddr s)
  (cdr (cdr s)))

(define (cadr s)
  (car (cdr s))
)

(define (caddr s)
  (car (cdr (cdr s)))
)


(define (sign x)
  (cond 
	((> 0 x) -1)
	((= 0 x) 0)
	(else 1)
  	)
)

(define (square x) (* x x))

(define (pow b n)
  (cond 
  	((zero? n) 1)
  	((even? n) (square (pow b (/ n 2))))
  		
  	
  	((odd? n) (* b (pow b (- n 1)))) 
  		))  
  	

  

(define (ordered? s)
  (cond 
  ((null? s) #t)
  ((null? (car s)) #t)
  ((null? (cdr s)) #t)
  ((> (car s) (cadr s)) #f)
  (else (ordered? (cdr s)))
))








