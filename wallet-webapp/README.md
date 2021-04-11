# Wallet Web App
This is a containerized webapp only version of the [Defi Wallet](https://github.com/DefiCh/app). To be used in conjunction with the wallet-proxy that can also be found
in this repository. As the app is made as an electron app, not all functionality is fully working.

## Why?
For example, if you want to run your node on a Raspberry Pi but still want a nice GUI to be able to check your balances, make swaps and send and receive funds.

## How to build
Open a terminal in this folder and run the following command:

`docker build -t defi-wallet .`

## How to run
`docker run -p 5000:5000 defi-wallet`

## What works
* Seeing your wallet and liquidity mining holdings
* Swapping funds
* Sending/receiving tokens

All these have been tested when connected to a DefiChain node that had a wallet running on the node.

## TODO:
* Do not use webpack to serve the wallet (made for debugging) but do a production build instead and serve with a lightweight webserver.
* Find more robust way to inject the RPC settings into the webapp
* More thorough checking of what works and what doesn't.
