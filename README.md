# BlockJack

Etherium gambling at its finest. Ever wanted to put your money in the hands of RNG (which is not even a true random) at the leasure of your home? Say no more, I am here to introduce you to BlockJack.

As the name suggest, BlockJack is a gambling game just like the famous blackjack, but betting is placed in the form of ether.

Just in case you live under a rock, I am gonna breifly explain the rules of blackjack. To start, the player needs to bet an initial amount of money (in our case ether). The player is then dealt two starting cards. The goal is to make it as close to a 21 sum hand as possible, without going over it. Over the course of the game, the player can "hit" - meaning they are willing to pull another card, or stand, in which case the house will pull cards until satisfied. In the end, if the player is closer or exactly at 21 they win, doubling their money. In case of a draw, the player gets his money back, and lastly, in case of a loss, the player will go cry into a corner with his digital account empty.

<br>

## The Contract

To start it off, the user will need to make a startGame transaction to our contract with a chosen amount of ether - this will be the initial bet. Once the transaction is complete the user has two choices - hit or stand. Both of these calls will not require any ether to be spent, meaning they are non payable.

Depending on the outcome of the game, at the end there will be one last transaction. The contract will transfer to the user's account double the initial bet in the case of a win and just the initial bet if it ends up in a draw. On the other hand, if the player looses, none of the ether will be returned and the house will keep it for further bets.

<br>

## The Implementation

Every card is represented by a number between 0 and 51; 0-3 means an Ace, 4-7 means a 2 and so on. Given that every card higher than 10 is also considered a 10 in this game, every card number higher than 35 will be considered a 10.

For computing the suit of the card you can simply take the card number modulus 4 and decide on a convention (0 - hearts, 1 - diamond, 2 - spade, 3 - clover). We leave it to developers implementing a client for our contract to decide the convention they want to use.

To store the hand of the player and house we used the maximum hand size there can be before exceeding 21 (eq. 4 aces + 4 twos + 3 threes which is exactly 21).
