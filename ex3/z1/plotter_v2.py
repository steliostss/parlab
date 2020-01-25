import os
import pandas as pd
import matplotlib.pyplot as plt

filedir = os.path.join(os.getcwd(), 'results')
pngdir = os.path.join(os.getcwd(), 'results')

files = ['accounts', 'accounts_faster']

for f in files:
    path = os.path.join(filedir, f + '.csv')
    df = pd.read_csv(path, usecols=[0, 1])

    plt.figure(f, figsize=(12, 9))
    for i in range(0, 2):
        x = df.iloc[i::2, 0]
        y = df.iloc[i::2, 1]
        plt.plot(x, y, 'o-')
        plt.xticks(x)
        # for a,b in zip(x,y):
        #     plt.text((a+1),(b+5),str(b))

    plt.title(f.title() + ' Version')
    plt.ylabel('Throughput (Kops/s)')
    plt.xlabel('Thread Count')
    plt.legend(['Execution ' + k for k in ['1st', '2nd']])
    plt.savefig(os.path.join(pngdir, f + '.png'))
