Testing:
	For our testing, we chose to test each output of the modules based on a generic input. We would test to see if
each output would change based on a change in the inputs. We would then change the inputs back and see if the outputs responded
accordingly. Our tests usually only tested for one or two possible input values such as one or two flip flop indexes or
one or two different bit strings to write into a flip flop. For those such tests, we figured that if one or two worked, then
they all should work. The testing coverage does not justify the time put in so we made it basic.


					********* NOTE *********
Whenever we tested using a clock in an always block, the tests would hang after they finished. I do not know why this happens 
so if you know of a reason and quick solution (that doesn't involve changing our code) then please do so to make sure that the
tests exit once completed.
