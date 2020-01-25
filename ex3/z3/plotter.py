import os
import pandas as pd
import matplotlib.pyplot as plt

filedir = os.path.join(os.getcwd(), 'results')
pngdir = os.path.join(os.getcwd(), 'results/png')

files = ['fgl80_10_10', 'lazy80_10_10', 'nb80_10_10',
         'opt80_10_10','serial80_10_10',
         'fgl20_40_40', 'lazy20_40_40', 'nb20_40_40',
         'opt20_40_40', 'serial20_40_40']

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

        
    plt.title(f.title() + ' Lock')
    plt.ylabel('Throughput (Kops/s)')
    plt.xlabel('Thread Count')
    plt.legend(['List Size ' + k for k in ['1024', '8192']])
    plt.savefig(os.path.join(pngdir, f + '.png'))