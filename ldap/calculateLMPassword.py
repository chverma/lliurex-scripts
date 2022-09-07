from passlib.hash import lmhash
import sys
print(lmhash.hash(sys.argv[1]))
