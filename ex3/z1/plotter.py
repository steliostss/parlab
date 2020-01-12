import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

question1 = "./results/question1.csv"
accounts_data = pd.read_csv(question1)

x1 = accounts_data.Nthreads1
y1 = accounts_data.Throughput1
x2 = accounts_data.Nthreads2
y2 = accounts_data.Throughput2

plt.figure(figsize=(10,7))
plt.title('1st execution Nthreads and Throughput')
plt.xlabel('Nthreads')
plt.ylabel('Throughput (Mops/sec)')
plt.margins(x=0.05)
plt.xticks(x1)
plt.plot(x1,y1,'g', marker='s')
# for a,b in zip(x1,y1):
#     plt.text(a,b,str(b))

plt.savefig('./results/1stExecution.png')

plt.figure(figsize=(10,7))
plt.title('2nd execution Nthreads and Throughput')
plt.xlabel('Nthreads')
plt.ylabel('Throughput (Mops/sec)')
plt.margins(x=0.05)
plt.xticks(x2)
plt.plot(x2,y2,'b', marker='s')
# for a,b in zip(x1,y1):
#     plt.text(a,b,str(b))

plt.savefig('./results/2ndExecution.png')
