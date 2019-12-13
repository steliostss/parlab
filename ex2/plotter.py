import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import os

mpi_filepath = os.path.join(os.getcwd(), 'results', 'run_mpi_final_MAPBYNODE.csv')
serial_filepath = os.path.join(os.getcwd(), 'results', 'run_serial.csv')

mpi_data = pd.read_csv(mpi_filepath)
serial_data = pd.read_csv(serial_filepath)

a = ['Jacobi_conv', 'Jacobi_NO_conv', 'Gauss-Seidel_conv', 'Gauss-Seidel_NO_conv', 'Red-Black-SOR_conv', 'Red-Black-SOR_NO_conv']
b = ['Jacobi_conv', 'Jacobi_NO_conv', 'GaussSeidelSOR_conv', 'GaussSeidelSOR_NO_conv', 'RedBlackSOR_conv', 'RedBlackSOR_NO_conv']
titles = {
    'Jacobi_conv': 'Jacobi Method, with convergence test',
    'Jacobi_NO_conv': 'Jacobi Method, without convergence test',
    'GaussSeidelSOR_conv': 'Gauss-Seidel-SOR Method, with convergence test',
    'GaussSeidelSOR_NO_conv': 'Gauss-Seidel-SOR Method, without convergence test',
    'RedBlackSOR_conv': 'Red-Black-SOR Method, with convergence test',
    'RedBlackSOR_NO_conv': 'Red-Black-SOR Method, without convergence test'
    }


method_translate = {k: v for k, v in zip(b, a)}

for index, row in serial_data.iterrows():
    method = row['Method']
    plt.figure(method)
    plt.xlabel('Number of Processes')
    plt.ylabel('Speedup')
    plt.xticks(np.arange(0, 40, 1))
    plt.title(titles[method])

    serial_time = row['Time']
    xsize = row['Xsize']
    ysize = row['Ysize']
    temp = mpi_data[(mpi_data['Method'] == method_translate[method]) &
                    (mpi_data['Xsize'] == xsize) &
                    (mpi_data['Ysize'] == ysize)]
    plt.plot(
        temp['Px'] + temp['Py'],  # x
        serial_time / temp['ComputationTime'],
        'o-',
        label=f'{method}, {xsize} x {ysize}'
    )

    plt.legend()

for method in serial_data['Method'].unique():
    data = mpi_data[(mpi_data['Method'] == method_translate[method])]
    proc_num = data['Px'] + data['Py']
    data = data[np.floor(np.log2(proc_num)) == np.ceil(np.log2(proc_num))]

    plt.figure(method + '2')
    plt.title(titles.get(method) + '\nRed: 2048x2048, Blue: 4096x4096, Orange: 6144x6144')
    r = np.arange(data.shape[0])
    plt.ylabel('Computation Time (s)')
    plt.xlabel('Number of Processes')
    plt.bar(
        r,
        data['ComputationTime'],
        tick_label=data['Px'] + data['Py'],
        color=['red']*4 + ['blue']*4 + ['orange']*4
    )


for method in serial_data['Method'].unique():
    data = mpi_data[(mpi_data['Method'] == method_translate[method])]
    proc_num = data['Px'] + data['Py']
    data = data[np.floor(np.log2(proc_num)) == np.ceil(np.log2(proc_num))]

    plt.figure(method + '3')
    plt.title(titles.get(method) + '\nRed: 2048x2048, Blue: 4096x4096, Orange: 6144x6144')
    r = np.arange(data.shape[0])
    plt.ylabel('Total Time (s)')
    plt.xlabel('Number of Processes')
    plt.bar(
        r,
        data['ComputationTime'],
        tick_label=data['Px'] + data['Py'],
        color=['red']*4 + ['blue']*4 + ['orange']*4
    )

save_directory = os.path.join(os.getcwd(), 'figures')
for method in serial_data['Method'].unique():
    plt.figure(method)
    plt.savefig(os.path.join(save_directory, method + '_speedup.png'))
    plt.figure(method + "2")
    plt.savefig(os.path.join(save_directory, method + '_Computation Time.png'))
    plt.figure(method + "3")
    plt.savefig(os.path.join(save_directory, method + '_Total Time.png'))
