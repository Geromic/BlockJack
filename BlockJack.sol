pragma solidity >=0.7.0 <0.9.0;

import "./RandomCardGenerator.sol";
import "./CasinoGame.sol";
import "./ArrayHelpers.sol";


contract BlockJack is RandomCardGenerator, CasinoGame, ArrayHelpers{
    
    uint minimumGameBet = 0.001 ether;
    uint maximumGameBet = 500 ether;
    
    struct Game {
        uint32 bet;
        uint8[] playerHand;
        uint8[] houseHand;
        uint8 playerHandCount;
    }
    
    Game[] public games;
    
    mapping(address => uint) ownerToGame;
    
    modifier checkBetWithinRange(){
        require(msg.value >= minimumGameBet);
        require(msg.value <= maximumGameBet);
        _;
    }
    
    /// @notice Used to start a new game
    /// @dev Create a new game and transfer the initial bet
    function startGame() external payable checkBetWithinRange returns (Game memory)  {
        uint id = createGame();
        
        return games[id];
    }
    
    /// @notice Used for pulling another card 
    /// @dev Generates a new random card to give to the user
    function hit() external returns (Game memory) { 
        Game storage currentGame = games[ownerToGame[msg.sender]];
        require(computeHandSum(currentGame.playerHand) < 21);
        
        addCardToPlayerHand(currentGame);
        checkIfPlayerHasBlackjack(currentGame);
        
        return currentGame;
    }
    
    /// @notice Used for stand action
    function stand() external returns (Game memory) {
        Game storage currentGame = games[ownerToGame[msg.sender]];
        uint8 playerHandSum = computeHandSum(currentGame.playerHand);
        require(playerHandSum < 21);
        
        drawHouseCards(currentGame);
        determineWinnerAndSendMoney(currentGame);
        
        return currentGame;
    }
    
    function addCardToPlayerHand(Game storage game) internal {
        uint8 newCard = generateUniqueRandomCard(concatenateArrays(game.playerHand, game.houseHand));
        game.playerHand[game.playerHandCount++] = newCard;
    }
    
    function createGame() internal returns (uint) {
        uint8[] memory initialCards = new uint8[](3);
        initialCards[0] = generateUniqueRandomCard(initialCards);
        initialCards[1] = generateUniqueRandomCard(initialCards);
        initialCards[2] = generateUniqueRandomCard(initialCards);
        
        uint8[] memory playerHand = new uint8[](11);
        uint8[] memory houseHand = new uint8[](11);
        
        playerHand[0] = initialCards[0];
        playerHand[1] = initialCards[1];
        houseHand[0] = initialCards[2];

        Game memory newGame = Game(uint32(msg.value), playerHand, houseHand, 2);
        games.push(newGame);
        uint id = games.length - 1;
        ownerToGame[msg.sender] = id;
        
        return id;
    }
    
    function drawHouseCards(Game storage game) internal {
        uint8 playerHandSum = computeHandSum(game.playerHand);
        uint8 houseHandSum = computeHandSum(game.houseHand);
        uint8 houseHandCount = 1;
        
        while(houseHandSum < 21 && houseHandSum < playerHandSum){
            uint8 newCard = generateUniqueRandomCard(concatenateArrays(game.houseHand, game.playerHand));
            game.houseHand[houseHandCount++] = newCard;
            houseHandSum = computeHandSum(game.houseHand);
        }
    }
    
    function determineWinnerAndSendMoney(Game memory game) internal {
        if(computeHandSum(game.playerHand) == computeHandSum(game.houseHand)){
            sendBetMoney(msg.sender, games[ownerToGame[msg.sender]].bet, 1);
        }
        else if(computeHandSum(game.houseHand) > 21){
            sendBetMoney(msg.sender, games[ownerToGame[msg.sender]].bet, 2);
        }
    }
    
    function computeHandSum(uint8[] memory hand) internal pure returns (uint8) {
        uint8 sum = 0;
        for(uint i = 0; i < 11; i++){
            if(hand[i] == 0) break;
            sum += getCardValue(hand[i]);
        }
        return sum;
    }
    
    function getCardValue(uint8 cardIndex) internal pure returns (uint8) {
        if(cardIndex > 35) return 10;
        return cardIndex / 4 + 1;
    }
    
    function checkIfPlayerHasBlackjack(Game memory game) internal {
        if(computeHandSum(game.playerHand) == 21){
            sendBetMoney(msg.sender, games[ownerToGame[msg.sender]].bet, 2);
        }
    }
}