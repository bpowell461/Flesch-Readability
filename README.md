# Flesch Readility

This is the Flesh Readability Project for different translations of the Bible.

# Flesch and Dalechall Scores

Three unique scores will be generated using equations based on four attributes: Amount of words (**_wordCount_**), amount of sentences (**_sentenceCount_**), amount of syllables (**_syllableCount_**), and amount of difficult words (**_diffWordCount_**). 

**_wordCount_** is determined by the amount of words in a file de-limited by whitespace. As long as a word has at least one letter, it is considered a word i.e. 123a, [is], for-each.

**_sentenceCount_** is determined by the amount of sentences in a file de-limited by the character set {. , : , ; , ! , ?}.

**_syllableCount_** is determined by the amount of syllables in each word. The amount of syllables are determined by vowels and cosonants in a word and are determined by these rules:
- Consecutive, or adjacent, vowels count as one syllables
- The character, e, at the end of the word does not count as a syllable **unless** the word contains no prior vowels
- All words contain at least one syllable.

**_diffWordCount_** is determined by the amount of difficult words in each file. A word is considered difficult if it not an element of the official _1995 Dale-Chall Word List_. 

# Compilation and Execution
Below are details on how to properly compile and execute every program in each language listed.

## C++
**_Compilation:_**
`c++ flesch.cpp`

**_Execution:_**
`a.out <filename>`

## Java
**_Compilation:_**
`javac flesch.cpp`

**_Execution:_**
`java flesch <filename>`

## Python
**_Execution:_**
`flesch.py <filename>`

## Perl
**_Execution:_**
`perl flesch.pl <filename>`

## Fortran
**_Compilation:_**
`gfortran -c myFuncs.f95 flesch.f95`

**_Linking:_**
`gfortran myFuncs.o flesch.o`

**_Execution:_**
`a.out <filename>`

_Warning: My implementation of Fortran runs extremely slow, around 18.0 seconds_

# Bible Translations Paths
**Example Path**
`/pub/pounds/CSC330/translations/<example.txt>`
