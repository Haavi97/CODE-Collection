import os

os.chdir(os.getcwd() + os.sep + 'flatten')

flatten_contracts = os.listdir()

for contract in flatten_contracts:
    if '_cleaned' not in contract:
        with open(contract, 'r') as f:
            contract_name = contract.split('.')[0]
            with open(contract_name + '_cleaned.txt', 'w') as f2:
                once = False
                for line in f.readlines():
                    if '// SPDX' in line:
                        if not once:
                            once = True
                            f2.write(line)
                    else:
                            f2.write(line)
        os.remove(contract)