/**
 * @title ERC20 token in pure Yul
 * @author Peter McQuaid
 * @notice This Yul script implements a fully functional ERC20 token including
 * optional 'name', 'symbol' and 'decimals' methods
 * @dev As with regular Solidity, the function selector comparison here will manually implement a single binary search
 * with the function selectors sorted in ascending order (this is not done automatically in pure Yul)
 */
 object "ERC20Yul" {
    // Empty constructor, equivalent to '0x60_600b5f3960_5ff3' in EVM bytecode, where '_' is byte length of "DeployedContract" object
    code {
        datacopy(0, dataoffset("DeployedContract"), datasize("DeployedContract"))
        return(0, datasize("DeployedContract"))
    }

    // Deployed contract
    object "DeployedContract" {
        code {
            mstore(0x40, 0x80) // Setting free memory pointer in same arbitrary format as Solidity

            if iszero(iszero(callvalue())) {    // Revert if ether is sent to contract
                revert(0, 0)
            }

            let selector := shr(0xe0, calldataload(0)) // Load first word of calldata and SHR by 28 bytes
            let medianSelector := 0x313ce567    // 'decimals' selector for binary search (5 of 9)

            if gt(selector, medianSelector) {
                switch selector
                case 0x70a08231 {}
                case 0x95d89b41 {}
                case 0xa9059cbb {}
                case 0xdd62ed3e {}
                default {
                    revert(0, 0)
                }
            }
            {
                switch selector
                case 0x06fdde03 {}
                case 0x095ea7b3 {}
                case 0x18160ddd {}
                case 0x23b872dd {}
                default {
                    revert(0, 0)
                }
            }
    }
    }
 }

/*
Public/external

name() -> 0x06fdde03
approve(address,uint256) -> 0x095ea7b3
totalSupply() -> 0x18160ddd
transferFrom(address,address,uint256) -> 0x23b872dd
decimals() -> 0x313ce567
balanceOf(address) -> 0x70a08231
symbol() -> 0x95d89b41
transfer(address,uint256) -> 0xa9059cbb
allowance(address,address) -> 0xdd62ed3e

events

Transfer(address,address,uint256) -> 0xddf252ad
Approval(address,address,uint256) -> 0x8c5be1e5

*/


