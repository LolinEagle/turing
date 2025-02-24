# Turing machine
The goal of this project is to write a program able to simulate a single headed, single tape Turing machine from a machine description provided in json.

## Authors
- [François Russo](https://www.github.com/LolinEagle)
- [thoo-ma](https://github.com/thoo-ma)

## Deployment
To deploy this project run
```bash
git clone https://github.com/LolinEagle/turing && cd turing && make &&
./bin/ft_turing machines/unary_sub.json "111-11="
```

## Arguments
```bash
ft_turing [-h] <jsonfile> <input>
```
jsonfile : json description of the machine

input : input for the machine

### Optional arguments :
-h, --help	show help message and exit
