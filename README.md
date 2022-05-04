An unorganized collection of fun and maybe useful things
=======

* `make_a_book.sh` Given a book in PDF, produces a new PDF suitable for book binding. Specifically geared at printing on US letter paper - two pages, properly ordered and rotated, per one sheet face.

* `babby-chart.sh` Uses `gnuplot` to generate a monthly chart to print out and track baby's weight.

* `flattener.py` Flattens a Jupyter Notebook into a simple Python file, throws out everything except the code.

* `textgraph.py` Graphs an arbitrary function in a text terminal. Just for fun. For the function `((x**2/80 - 10) + 5*math.sin(x/5))/2 - 10`, the graph looks like

```
  **                          |                         *    
    ***                       |                        *     
       **                     |                              
         *                    |                       *      
          *                   |                     **       
-----------*------------------0------------------***---------
            *                 |               ***            
             *                |             **               
              **  ***         |            *                 
                **   **       |           *                  
                       *      | *****   **                   
                        **   ***     ***                     
                          *** |                              
                              |                              
                              |                              
```
