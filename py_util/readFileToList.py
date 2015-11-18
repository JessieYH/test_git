def readFileToList(inFile, colget = 't'):
    in_file = open(inFile)

    data = []
    while True:
        line = in_file.readline()
        if len(line) == 0:
            break
        else:
            line = line.rstrip()     # delete whitespace character on the right side
            if colget == 't':
                data.insert(len(data),line.split(','))   # split on a delimiter into a list of substring
            else:
                line = line.split(',')
                data.append(line[colget])
            
    in_file.close() 
    return data

openFile = '/homes/yihsuan/test/PinOrder_PAIR.csv'
outputList = readFileToList(openFile)
print outputList

