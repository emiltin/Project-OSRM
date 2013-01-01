@routing @testbot @ferry
Feature: Testbot - Handle ferry routes

	Background:
		Given the profile "testbot"

	Scenario: Testbot - Ferry duration, single node
		Given the node map
		 | a | b | c | d |
		 | e | f | g | h |
		 | i | j | k | l |
		 | m | n | o | p |
		 | q | r | s | t |
		 
		And the ways
		 | nodes | highway | route | duration |
		 | ab    | primary |       |          |
		 | cd    | primary |       |          |
		 | ef    | primary |       |          |
		 | gh    | primary |       |          |
		 | ij    | primary |       |          |
		 | kl    | primary |       |          |
		 | mn    | primary |       |          |
		 | op    | primary |       |          |
		 | qr    | primary |       |          |
		 | st    | primary |       |          |
		 | bc    |         | ferry | 0:01     |
		 | fg    |         | ferry | 0:10     |
		 | jk    |         | ferry | 1:00     |
		 | no    |         | ferry | 24:00    |
		 | rs    |         | ferry | 96:00    |

        When I route I should get
         | from | to | route | time        |
         | b    | c  | bc    | 60s +-1     |
         | f    | g  | fg    | 600s +-1    |
         | j    | k  | jk    | 3600s +-1   |
         | n    | o  | no    | 86400s +-1  |
         | r    | s  | rs    | 345600s +-1 |
    

 	Scenario: Testbot - Ferry duration formats
 		Given the node map
 		 | a | b | c | d |
 		 | e | f | g | h |

 		And the ways
 		 | nodes | highway | route | duration |
 		 | ab    | primary |       |          |
 		 | cd    | primary |       |          |
 		 | ef    | primary |       |          |
 		 | gh    | primary |       |          |
 		 | bc    |         | ferry | 0:45     |
 		 | fg    |         | ferry | 00:45    |

         When I route I should get
          | from | to | route | time      |
          | b    | c  | bc    | 2700s +-1 |
          | f    | g  | fg    | 2700s +-1 |

    @todo
 	Scenario: Testbot - Week long ferry routes
 		Given the node map
 		 | a | b | c | d |
 		 | e | f | g | h |
 		 | i | j | k | l |

 		And the ways
 		 | nodes | highway | route | duration |
 		 | ab    | primary |       |          |
 		 | cd    | primary |       |          |
 		 | ef    | primary |       |          |
 		 | gh    | primary |       |          |
 		 | ij    | primary |       |          |
 		 | kl    | primary |       |          |
 		 | bc    |         | ferry | 24:00    |
 		 | fg    |         | ferry | 168:00   |
 		 | jk    |         | ferry | 720:00   |

         When I route I should get
          | from | to | route | time        |
          | b    | c  | bc    | 86400s +-1  |
          | f    | g  | fg    | 604800s +-1 |
          | j    | k  | jk    | 259200s +-1 |

	Scenario: Testbot - Ferry duration, multiple nodes
		Given the node map
		  | x |   |   |   |   | y |
		  |   | a | b | c | d |   |

		And the ways
		 | nodes | highway | route | duration |
		 | xa    | primary |       |          |
		 | yd    | primary |       |          |
		 | ad    |         | ferry | 1:00     |

		When I route I should get
		 | from | to | route | time      |
		 | a    | d  | ad    | 3600s +-1 |
		 | d    | a  | ad    | 3600s +-1 |
    
    @todo
	Scenario: Testbot - Ferry duration, individual parts, fast
    Given a grid size of 10000 meters
		Given the node map
		  | x | y |  | z |  |  | v |
		  | a | b |  | c |  |  | d |

		And the ways
		 | nodes | highway | route | duration |
		 | xa    | primary |       |          |
		 | yb    | primary |       |          |
		 | zc    | primary |       |          |
		 | vd    | primary |       |          |
		 | abcd  |         | ferry | 0:06     |

		When I route I should get
		 | from | to | route | time     |
		 | a    | d  | abcd  | 360s +-1 |
		 | a    | b  | abcd  | 60s +-1  |
		 | b    | c  | abcd  | 120s +-1 |
		 | c    | d  | abcd  | 180s +-1 |
    @todo
 	Scenario: Testbot - Ferry duration, individual parts, slow
 		Given the node map
 		  | x | y |  | z |  |  | v |
 		  | a | b |  | c |  |  | d |

 		And the ways
 		 | nodes | highway | route | duration |
 		 | xa    | primary |       |          |
 		 | yb    | primary |       |          |
 		 | zc    | primary |       |          |
 		 | vd    | primary |       |          |
 		 | abcd  |         | ferry | 1:00     |

 		When I route I should get
 		 | from | to | route | time      |
 		 | a    | d  | abcd  | 3600s ~1% |
 		 | a    | b  | abcd  | 600s ~1%  |
 		 | b    | c  | abcd  | 1200s ~1% |
 		 | c    | d  | abcd  | 1800s ~1% |
 
 	Scenario: Testbot - Ferry duration, connected routes
 		Given the node map
 		  | x |   |   |   | d |   |   |   | y |
 		  |   | a | b | c |   | e | f | g | t |

 		And the ways
 		 | nodes | highway | route | duration |
 		 | xa    | primary |       |          |
 		 | yg    | primary |       |          |
 		 | abcd  |         | ferry | 0:30     |
 		 | defg  |         | ferry | 0:30     |

 		When I route I should get
 		 | from | to | route     | time      |
 		 | a    | g  | abcd,defg | 3600s +-1 |
 		 | g    | a  | defg,abcd | 3600s +-1 |

 	Scenario: Testbot - Prefer road when faster than ferry
 		Given the node map
 		  | x | a | b | c |   |
 		  |   |   |   |   | d |
 		  | y | g | f | e |   |

 		And the ways
 		 | nodes | highway | route | duration |
 		 | xa    | primary |       |          |
 		 | yg    | primary |       |          |
 		 | xy    | primary |       |          |
 		 | abcd  |         | ferry | 0:01     |
 		 | defg  |         | ferry | 0:01     |

 		When I route I should get
 		 | from | to | route    | time    |
 		 | a    | g  | xa,xy,yg | 40s +-1 |
 		 | g    | a  | yg,xy,xa | 40s +-1 |

 	Scenario: Testbot - Long winding ferry route
 		Given the node map
 		  | x |   | b |   | d |   | f |   | y |
 		  |   | a |   | c |   | e |   | g |   |

 		And the ways
 		 | nodes   | highway | route | duration |
 		 | xa      | primary |       |          |
 		 | yg      | primary |       |          |
 		 | abcdefg |         | ferry | 6:30     |

 		When I route I should get
 		 | from | to | route   | time       |
 		 | a    | g  | abcdefg | 23400s +-1 |
 		 | g    | a  | abcdefg | 23400s +-1 |
 		 
	Scenario: Testbot - Ferry routes fan
  		Given the node map
  		  | a | x | y | b |
  		  |   |   | z |   |
  		  |   | q |   |   |

  		And the ways
  		 | nodes | highway | route | duration |
  		 | ax    | primary |       |          |
  		 | xy    |         | ferry | 1:00     |
  		 | xz    |         | ferry | 1:00     |
  		 | xq    |         | ferry | 1:00     |
  		 | yb    | primary |       |          |

  		When I route I should get
  		 | from | to | route | time      |
  		 | x    | y  | xy    | 3600s +-1 |
  		 | y    | x  | xy    | 3600s +-1 |
      	
     Scenario: Testbot - Ferry routes criss-cross
   		Given the node map
   		  | a | x | s | e | m |
   		  | b | y | t | f |   |
   		  | c | z | u | g |   |

   		And the ways
   		 | nodes | highway | route | duration |
   		 | ax    | primary |       |          |
   		 | by    | primary |       |          |
   		 | cz    | primary |       |          |
   		 | se    | primary |       |          |
   		 | tf    | primary |       |          |
   		 | ug    | primary |       |          |
   		 | xs    |         | ferry | 0:10     |
   		 | xy    |         | ferry | 0:10     |
   		 | xu    |         | ferry | 0:10     |
   		 | ys    |         | ferry | 0:10     |
   		 | yu    |         | ferry | 0:10     |
   		 | zs    |         | ferry | 0:10     |
   		 | zu    |         | ferry | 0:10     |

   		When I route I should get
   		 | from | to | route | time      |
   		 | x    | s  | xs    | 600s +-10 |
   		 | x    | y  | xy    | 600s +-10 |
   		 | x    | u  | xu    | 600s +-10 |
   		 | y    | s  | ys    | 600s +-10 |
   		 | y    | u  | yu    | 600s +-10 |
   		 | z    | s  | zs    | 600s +-10 |
   		 | z    | u  | zu    | 600s +-10 |
