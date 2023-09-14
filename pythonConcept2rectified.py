import time
myMemory = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
a = arr = [[0 for i in range(5)] for j in range(3)]
print("a untouched")
for i in range(1, 4):
    for j in range(1, 6):
        print("a[" + str(i - 1) + "][" + str(j - 1) + "] = " + str(a[i - 1][j - 1]))
for j in range(1, 6):
    a[0][j - 1] = myMemory[j - 1]
time.sleep(5)
print("a after modifying first row")
for i in range(1, 4):
    for j in range(1, 6):
        print("a[" + str(i - 1) + "][" + str(j - 1) + "] = " + str(a[i - 1][j - 1]))
for j in range(1, 6):
    a[1][j - 1] = myMemory[j + 1]
time.sleep(5)
print("a after modifying second row")
for i in range(1, 4):
    for j in range(1, 6):
        print("a[" + str(i - 1) + "][" + str(j - 1) + "] = " + str(a[i - 1][j - 1]))
for j in range(1, 6):
    a[2][j - 1] = myMemory[j + 3]
time.sleep(5)
print("a after modifying third row")
for i in range(1, 4):
    for j in range(1, 6):
        print("a[" + str(i - 1) + "][" + str(j - 1) + "] = " + str(a[i - 1][j - 1]))