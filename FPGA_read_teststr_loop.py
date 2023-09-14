import datetime
from ok import *
from cnt_diff import *
import time

def FPGA_read_teststr_loop(xem):
    #% FPGA readout
    #close all
    #figure
    print("reading data from FPGA\n")
    time_run = "_" + str(datetime.datetime.now().year) + "-" + str(datetime.datetime.now().month) + "-" + str(datetime.datetime.now().day) + "_" + str(datetime.datetime.now().hour) + str(datetime.datetime.now().month) + str(datetime.datetime.now().second)
    data_points = 2**12
    data_read_leng = 2**10
    test_len = 2**4
    data_transient = []
    row16 = [] #A row of 16 zeroes
    for idx in range(1, 17):
        row16.append(0)
    twentyRowsof16 = [] #Contains 20 row16s
    for idx in range(1, 21):
        twentyRowsof16.append(row16)
    data_transient.append(twentyRowsof16)
    data_transient.append(twentyRowsof16)

    for k in range(1, test_len + 1):
        print("Run #{}\n".format(k))
        tic = time.time()

        time.sleep(0.5)

        data_pipeout = []
        temp_array = [] #This is going to a 4*data_points long 1D array full of zeroes, it will be appended to data_pipeout 19 times
        for i in range(1, (4 * data_points) + 1):
            temp_array.append(0)
        for i in range(1, 20): #needs to iterate 19 times only, not 20
            data_pipeout.append(temp_array)
        buf = bytearray(4 * data_points) #buf is an array of 4 * data_points 1 byte values (I think this is what this command accomplishes)
        xem.ReadFromBlockPipeOut(0xb3, data_read_leng, buf)
        temp_array1 = []
        for i in range(1, (4 * data_points) + 1):
            #toAppend = buf[i - 1]
            #print(str(i) + " : " + str(toAppend) + "\n")
            temp_array1.append(buf[i - 1])
        data_pipeout.append(temp_array1)

        #if k == 1:
            #for i in range(0, 4*data_points):
                #print("Column " + str(i + 1) + " : " + str(data_pipeout[19][i]) + "\n")

        #NOT SURE ABOUT THIS, but I think both data_out and data_out2 are 8 * data_points arrays with every element being 0
        data_out = []
        toc = time.time()
        timeinterval = toc - tic
        temp_array2 = [] #This is going to a data_points long 1D array full of zeroes, it will be appended to data_out 19 times
        for i in range(1, data_points + 1):
            temp_array2.append(0)
        for i in range(1, 20):
            data_out.append(temp_array2)
        #each of these temp-arrays is data_points (4096) long
        #temp_array3 = mod(double(data_pipeout(j,3:4:end)),2^5)*2^2
        #temp_array4 = fix(double(data_pipeout(j,2:4:end))/2^6)
        #temp_array5 = mod(double(data_pipeout(j,2:4:end)),2^6)*2^8
        #temp_array6 = double( data_pipeout(j,1:4:end))
        temp_array3 = []
        for i in range(3, (4*data_points) + 1, 4):
            ans = float(data_pipeout[19][i - 1])
            #toAppend = (ans % (2 ** 5)) * 2**2
            #print(str(i) + " : " + str(toAppend) + "\n")
            temp_array3.append((ans % (2 ** 5)) * 2**2)
        temp_array4 = []
        for i in range(2, (4*data_points) + 1, 4):
            toAdd = (float(data_pipeout[19][i - 1])) / (2 ** 6)
            #print(str(i) + " : " + str(toAdd) + "\n")
            if toAdd >= 0:
                toAdd = toAdd // 1
            else:
                toAdd = (toAdd // 1) + 1
            #print(str(i) + " : " + str(toAdd) + "\n")
            temp_array4.append(toAdd)
        temp_array5 = []
        for i in range(2, (4*data_points) + 1, 4):
            #toAppend = ((float(data_pipeout[19][i - 1])) % (2 ** 6)) * 2**8
            #print(str(i) + " : " + str(toAppend) + "\n")
            temp_array5.append(((float(data_pipeout[19][i - 1])) % (2 ** 6)) * 2**8)
        temp_array6 = []
        for i in range(1, (4 * data_points) + 1, 4):
            #toAppend = float(data_pipeout[19][i - 1])
            #print(str(i) + " : " + str(toAppend) + "\n")
            temp_array6.append(float(data_pipeout[19][i - 1]))
        temp_array7 = []
        for i in range(1, data_points + 1):
            #toAppend = (temp_array3[i - 1] + temp_array4[i - 1])/128 + temp_array5[i - 1] + temp_array6[i - 1]
            #print("toAppend: " + str(toAppend) + "\n")
            temp_array7.append((temp_array3[i - 1] + temp_array4[i - 1])/128 + temp_array5[i - 1] + temp_array6[i - 1])
        data_out.append(temp_array7)

        data_transient[0][19][k - 1] = cnt_diff(data_out[19], data_points)
        print("Ref_cnt_avg = {}\n".format(data_transient[0][19][k - 1]))
        if k == 1:
            data_transient[1][19][k - 1] = 0
        if k > 1:
            data_transient[1][19][k - 1] = data_transient[1][19][k - 2] + timeinterval
        #I HAVE NOT INCLUDED COMMANDS TO PLOT ANYTHING, I DON'T KNOW IF IT CAN BE DONE IN PYTHON OR IF IT NEEDS TO BE DONE