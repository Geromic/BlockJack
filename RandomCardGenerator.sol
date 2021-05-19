pragma solidity >=0.7.0 <0.9.0;

contract RandomCardGenerator {
  uint randNonce = 0;
  
  function generateRandomCard() internal returns(uint8) {
    randNonce++;
    return uint8(uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % 52);
  }
  
  function generateUniqueRandomCard(uint8[] memory usedCards) internal returns(uint8){
      uint8 generatedCard;
      do{
          generatedCard = generateRandomCard();
      } while(isCardInUsedCards(generatedCard, usedCards));
      return generatedCard;
  }
  
  function isCardInUsedCards(uint8 generatedCard, uint8[] memory usedCards) pure internal returns(bool){
      for(uint8 i = 0; i < usedCards.length; i++){
          if(generatedCard == usedCards[i])
            return true;
      }
      return false;
  }
}