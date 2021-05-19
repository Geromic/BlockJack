import "./Ownable.sol";

/// @title Casino Game
/// @author sudo-team (sudo.rocks)
/// @notice Basic money-related operations used by Casino Games
contract CasinoGame is Ownable{
    
    /// @notice Owner withdraws the money inside the contract
    /// @dev The contract balance is transfered to the contract's owner
    function withdraw() external onlyOwner {
        address payable _owner = payable(address(uint160(owner())));
        _owner.transfer(address(this).balance);
    }
    
    /// @notice Used for depositing money
    function deposit() external payable onlyOwner{
        // i mean, we only need to deposit a certain amount
        // nothing to do here
    }
    
    /// @notice Used for checking contract account balance
    function checkBalance() external payable onlyOwner returns (uint){
        return address(this).balance;
    }
    
    function sendBetMoney(address playerAddress, uint bet, uint8 multiplier) internal{
        address payable playerPayable = payable(playerAddress);
        playerPayable.transfer(bet * multiplier);
    }
}