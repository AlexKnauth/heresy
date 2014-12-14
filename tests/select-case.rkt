#lang s-exp heresy

(require rackunit)

(check-equal? (select case 5
                      [(1 2 3) "one, two, or three"]
                      [(4 5 6) "four, five, or six"]
                      [else "something else"])
              "four, five, or six")
