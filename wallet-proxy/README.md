# Wallet Proxy

This simple containerized proxy script allows JSONRPC communication between the Defi Wallet Webapp and the Defichain node, without CORS issues. Only run this in your private network!
Anyone with access to this proxy server can communicate with your node. You need to have docker installed.

## Build instructions
Open a terminal in this folder and run the following command:
`docker build -t defi-wallet-proxy .`

## Run instructions
Have your RPC username and password that correspond with the rpcauth hash that you put in the defi.conf hash of your node. If you didn't, run the script [here](https://github.com/DeFiCh/ain/tree/master/share/rpcauth) 
and follow the instructions to put the hash in your defi.conf file, and write down the password and your chosen username.
Also, write down the IP address of the machine (in your local network!) that is running your node, and the RPC port  thatis exposed on your node (default is 8554).

`docker run -it -p 5001:5001 -e RPC_HOST=your_node_ip_address:port -e RPC_AUTH='your_rpc_username:your_rpc_password' defi-wallet-proxy`

**NOTE: I strongly advise against running this outside of your local network, or on a machine that has its ports exposed to the internet.**
