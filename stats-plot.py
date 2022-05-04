import matplotlib.pyplot as plt

x = [0, 1, 2, 3, 4, 5, 6]
# y1 = [0, -5, 8, 18, 27, 32, 39]
# y2 = [0, 27, 20, 15, -5, -3, -3]

y1 = [0, -5, -7, -7,  3,  7, 10]
y1err = [0, 0, 0, 3, 0, 0, 4]
y2 = [0,  5,  7,  9, -7, -6, -6]
y2err = [0, 0, 0, 3, 0, 0, 4]

plt.grid(axis="y")
#plt.plot(x, y1, label="Azilsartan-Candesartan")
#plt.plot(x, y2, label="Candesartan-Azilsartan")

eb1 = plt.errorbar(x, y1, label="Azilsartan-Candesartan", yerr=y1err, capsize=5, errorevery=(3,3), color='k', lw=2)

eb2 = plt.errorbar(x, y2, label="Candesartan-Azilsartan", yerr=y2err, capsize=5, errorevery=(3,3), color='k', lw=2, linestyle='dashed')
eb2[-1][0].set_linestyle('dashed')

plt.xlabel('Months')
plt.ylabel('Change in UPCR (%)')
plt.title("Mean percent changes in UPCR during the 6 months of treatment")
plt.legend()



plt.show()
