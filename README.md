## Quickstart

```sh
git clone https://github.com/smartcontractkit/foundry-starter-kit
cd foundry-starter-kit
make # This installs the project's dependencies.
make test
```

## Notes
Explain how someone could deposit more than 1 eth per block:

This would require the DaoEscrowFarm contract to have an unrealistic amount of ETH. However, if we can assume that this contract has a near infinite amount of ETH:

1. The obvious exploit is to transfer in 0.2 ETH, then 1 ETH, which makes allows you to drain the contract via refund as the contract uses solidity 0.6.11. Alternatively, you could transfer 2**256 - 1 ETH which would perform a similar exploit, however, it is unrealistic to have that much eth in one account even with existing things like flash loans

2.  The only problem is that you would need enough ETH such that `(bool success, ) = msg.sender.call{value: refundValue}("");` doesn't revert, ie basically 2**256 which is unrealistic.

Analyze the contract for re-entrancy vulnerabilities. If there are any, write a sample contract to exploit it. If not, explain why the contract is secure.

The withdraw function is safe, as it follows the checks-effects-interactions pattern.

There are two main call-paths through the default receive function. 

In the normal control flow where msg.value is less than or equal to 1 ether and no ether has been deposited by that user in that block, we are safe from reentrancy attacks as there are no external calls in that control path.

In the control flow where msg.value is less than or equal to 1 ether and ether previously deposited in this block by the same user + msg.value would be greater than 1, we have a single external call


There may potentially be an exploit in the receive() function
Optimise the `receive` function so that it is at least 20% cheaper and send a sample contract showing how the optimisation is done.