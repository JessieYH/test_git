import math

#x = 5
#tab = ' '
#a = ' *'
#while x >= 0:
#    if x != 0:
#        tmp = tab * (10 - 2 * x) + a * x
#        print(tmp + tab + tmp[::-1])
#    else:
#        tmp = tab * (10 - 1) 
#        print(tmp + a)    
#    x -= 1

a = '* '
spc = ' '
level = 6
count = 1
init_spc = level + 1
while count <= level:
    for i in range(0,3):
        leaf = a * (count + i)
        print spc * (init_spc -i),
        print leaf
    init_spc -= 1      
    count += 1
else:
    print spc * 2,
    print '=' * (level * 2 - 1)
