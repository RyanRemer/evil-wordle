# Evil Wordle

Wordle, but the computer changes the word as you play

# Algorithm

The computer follows this general algorithm while playing:

1. Load "assets/answers.txt" as the starting word list of possible answers
2. Wait for the player to submit a guess
3. Sort the possible answers by grouping together words that would color a guess in the same way
4. Color the player's guess based on the largest grouping of possible answers
5. Set the grouping of possible answer as the new word list
6. Repeat sets 2-5 until the player wins or loses
