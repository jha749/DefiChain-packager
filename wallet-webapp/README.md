# Wallet Web App
This is a containerized webapp only version of the [Defi Wallet](https://github.com/DefiCh/app).

## Why?
For example, if you want to run your node on a Raspberry Pi but still want a nice GUI to be able to check your balances, make swaps and send and receive funds.

## How to build
Open a terminal in this folder and run the following command to build the latest released version of the app.

`docker build -t defi-wallet .`

If you want to build a specific version, you can specify that with passing `BUILD_VERSION` as `build-arg`. E.g.:

`docker build -t defi-wallet --build-arg BUILD_VERSION=2.3.3 .`

## How to run
Have your RPC username and password that correspond with the rpcauth hash that you put in the defi.conf hash of your node. If you didn't, run the script [here](https://github.com/DeFiCh/ain/tree/master/share/rpcauth) 
and follow the instructions to put the hash in your defi.conf file, and write down the password and your chosen username.
Also, write down the IP address of the machine (in your local network!) that is running your node, and the RPC port  thatis exposed on your node (default is 8554).

`docker run -p 5000:5000 -p 5001:5001 -e RPC_HOST=your_node_ip_address:port -e RPC_AUTH='your_rpc_username:your_rpc_password' defi-wallet`

## What works
* Seeing your wallet and liquidity mining holdings
* Swapping funds
* Sending/receiving tokens
* The console

All these have been tested when connected to a DefiChain node that had a wallet running on the node.

## TODO:
* Find more robust way to inject the RPC settings into the webapp
* More thorough checking of what works and what doesn't.
