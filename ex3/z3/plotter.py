import os
import pandas as pd
import matplotlib.pyplot as plt

filedir = os.path.join(os.getcwd(), 'results')

files = ['lazy', 'fgl', 'nb', 'opt', 'serial']
for f in files:
    path = os.path.join(filedir, f + '.csv')
    df = pd.read_csv(path, usecols=[0, 1, 2])

    plt.figure(f, figsize=(12, 9))
    for i in range(0, 8):
        x, y = df.iloc[i::8, 0], df.iloc[i::8, 1]
        plt.plot(x, y, 'o-')
        plt.xticks(x)

    plt.title(f.title() + ' Lock')
    plt.ylabel('Throughput (Kops/s)')
    plt.xlabel('Thread Count')
    plt.legend(['List Size ' + k for k in ['1024', '8192']])
    plt.savefig(os.path.join(filedir, f + '.png'))