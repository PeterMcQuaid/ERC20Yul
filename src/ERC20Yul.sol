/**
 * @title ERC20 token in pure Yul
 * @author Peter McQuaid
 * @notice This Yul script implements a fully functional ERC20 token including
 * optional 'name', 'symbol' and 'decimals' methods: https://eips.ethereum.org/EIPS/eip-20
 * @dev As with regular Solidity, the function selector comparison here will manually implement a single binary search
 * with the function selectors sorted in ascending order (this is not done automatically in pure Yul)
 */
 object "ERC20Yul" {
    // Constructor defines immutable values and sets initial balance for contract creator (entire token supply)
    // Storage Layout:
    // Slot 0 (mapping reserve slot): mapping(address => uint256) balance 
    // Slot 1 (mapping reserve slot): mapping(address => mapping(address => uint256)) allowance
    code {
        let initialBalance := 0x3b9aca00
        let account := caller()
        mstore(0, account)
        mstore(0x20, 0)     // Ensure 2nd word of scratch space is zero
        let storageSlot := keccak256(0, 0x40) // Following Solidity storage conventions
        sstore(storageSlot, initialBalance)  // Set balance for address 'account'
        datacopy(0, dataoffset("DeployedContract"), datasize("DeployedContract"))
        setimmutable(0, "name", "ERC20Yul")       // Offset == 0 to overwrite default placeholder
        setimmutable(0, "symbol", "YUL")
        setimmutable(0, "decimals", 18)
        setimmutable(0, "totalSupply", initialBalance)  // 1 billion in hex
        setimmutable(0, "owner", caller())  // Set owner to contract creator
        return(0, datasize("DeployedContract"))
    }

    // Deployed contract
    object "DeployedContract" {
        code {  // Not setting FMP here as no need -> only "scratch space" is used
            if iszero(iszero(callvalue())) {    // Revert if ether is sent to contract
                revert(0, 0)
            }

            let selector := shr(0xe0, calldataload(0)) // Load first word of calldata and SHR by 28 bytes
            let medianSelector := 0x313ce567    // 'decimals' selector for binary search (5 of 9)

            if gt(selector, medianSelector) {
                switch selector
                case 0x313ce567 {   // 'decimals()'
                    mstore(0, loadimmutable("decimals"))
                    return(0, 0x20)
                }
                case 0x70a08231 {   // 'balanceOf(address)'
                    let inputAddress := calldataload(0x04)
                    let addressBalance := getBalance(inputAddress)
                    mstore(0, addressBalance)
                    return(0, 0x20)
                }
                case 0x95d89b41 {   // 'symbol()'
                    mstore(0, loadimmutable("symbol"))
                    return(0, 0x20)
                }
                case 0xa9059cbb {   // 'transfer(address,uint256)'
                    let sender := caller()
                    let recipient := calldataload(0x04)
                    let callerBalance := getBalance(sender)
                    let amount := calldataload(0x24)
                    if lt(callerBalance, amount) {
                        revert(0, 0)
                    }
                    setBalance(sender, sub(callerBalance, amount))
                    setBalance(recipient, add(getBalance(recipient), amount))
                    mstore(0, 1)
                    return(0, 0x20) // Return 'true' if successful
                }
                case 0xdd62ed3e {   // 'allowance(address,address)'
                    let account := calldataload(0x04)
                    let spender := calldataload(0x24)
                    let allowance := getAllowance(account, spender)
                    mstore(0, allowance)
                    return(0, 0x20)
                }
                default {
                    revert(0, 0)
                }
            }
            {
                switch selector
                case 0x06fdde03 {   // 'name()'
                    mstore(0, loadimmutable("name"))
                    return(0, 0x20)
                }
                case 0x095ea7b3 {   // 'approve(address,uint256)'
                    let spender := calldataload(0x04)
                    let amount := calldataload(0x24)
                    let success := setAllowance(caller(), spender, amount)
                    if iszero(success) {
                        revert(0, 0)
                    }
                }
                case 0x18160ddd {   // 'totalSupply()'
                    mstore(0, loadimmutable("totalSupply"))
                    return(0, 0x20)
                }
                case 0x23b872dd {   // 'transferFrom(address,address,uint256)'
                    let sender := caller()
                    let sentFrom := calldataload(0x04)
                    let recipient := calldataload(0x24)
                    let amount := calldataload(0x44)
                    let callerAllowance := getAllowance(sentFrom, sender)
                    if lt(callerAllowance, amount) {
                        revert(0, 0)
                    }
                    setBalance(sentFrom, sub(getBalance(sentFrom), amount))
                    setBalance(recipient, add(getBalance(recipient), amount))
                    mstore(0, 1)
                    return(0, 0x20) // Return 'true' if successful
                }
                default {
                    revert(0, 0)
                }
            }

            function setBalance(account, balanceToSet) {
                mstore(0, account)
                mstore(0x20, 0)     // Ensure 2nd word of scratch space is zero
                let storageSlot := keccak256(0, 0x40) // Following Solidity storage conventions
                sstore(storageSlot, balanceToSet)  // Set balance for address 'account'
            }

            function getBalance(account) -> accountBalance {
                mstore(0, account)
                mstore(0x20, 0)
                accountBalance := sload(keccak256(0, 0x40))
            }

            function getAllowance(account, spender) -> allowance {
                mstore(0, account)
                mstore(0x20, 1)
                let nestedReserveSlot := keccak256(0, 0x40)
                mstore(0, spender)
                mstore(0x20, nestedReserveSlot)
                allowance := sload(keccak256(0, 0x40))
            }

            function setAllowance(account, spender, amount) -> success {
                mstore(0, account)
                mstore(0x20, 1)
                let nestedReserveSlot := keccak256(0, 0x40)
                mstore(0, spender)
                mstore(0x20, nestedReserveSlot)
                sstore(keccak256(0, 0x40), amount)  // Setting new allowance, which can be any 32 byte size. Overwrites existing allowance
                success := 1
            }
        }
    }
}