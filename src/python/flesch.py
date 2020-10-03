#!/usr/bin/python3
import sys

#################################### 
class flesch:
  def __init__(self):               #Building a flesch-readability object with attributes
    self.syllableCount=0
    self.wordCount=0
    self.sentenceCount=0
    self.diffWordCount=0
#################################### 

####################################     
def main(argv):
  index=countWords(sys.argv[0])
  a = (index.syllableCount)/(index.wordCount)   #
  b = (index.wordCount)/(index.sentenceCount)   #Variables used for respective equations
  aD = (index.diffWordCount)/(index.wordCount)  #
  print("Difficult Word: "+str(index.diffWordCount))
  
  readIndex = 206.835-(a*84.6)-(b*1.015)        #Flesch-Readability Index Variable
  gradeIndex = (a*11.8)+(b*0.39)-15.59          #Flesch Grade Level Index
  dalePercent = (aD * 100)                      #Dale-Chall Percentage
  
  daleIndex =(dalePercent*0.1579)+(b*0.0496)    #Dale-Chall Raw Score
  if(dalePercent > 5):
    daleIndex += 3.6365
  print("Sentence Count: "+str(index.sentenceCount))
  print("Word Count: "+str(index.wordCount))
  print("Syllable Count: "+str(index.syllableCount))
  print("\nReadability and Grade Index")
  print("-----------------------------------")
  print("Flesch Readability Level: "+str(round(readIndex)))
  print("Flesch Grade Level Index: "+str(round(gradeIndex, 1)))
  print("Dale-Chall Readability Level: "+str(round(daleIndex, 1)))
#################################### 

#################################### 
def countWords(args):                         #Probably should rename this to buildFleschObject()
  dalechall=buildHashSet()                    #Unordered set of Dale-Chall words
  index=flesch();
  with open(sys.argv[1], 'r') as inFile:      #
    for line in inFile:                       #Reading in file and splitting based on white space
      for word in line.split():               #
        if(isWord(word)):
          i=0
          for i in word:
            if(isSentence(i)):
              index.sentenceCount+=1
          word = checkWord(word)                   
          if(isDifficultWord(dalechall,word)):          #
            index.diffWordCount+=1                      #
          index.wordCount+=1                            #
          index.syllableCount+=countSyllables(word)     #                                          #
  return index                                          #returning built Flesch Object
####################################       

####################################
def countSyllables(word):
  count = 0
  hasSyllable=False              #boolean to check if word has syllables
  state = 'c'                    #Default state is 'c' for cosonant
 
  end = word[-1:]
    
  for i in word:                #Simple state machine inspired by a Stack Overflow answer: https://stackoverflow.com/a/52649782
                                
    if(state=='v'):             #If the previous state of the machine was a vowel
      
      if(not isVowel(i)):   #and if the current state of the machine is not a vowel, increment. This accounts for consecutive vowels.
        hasSyllable=True
        count+=1
          
    state='v' if isVowel(i) else 'c' #Switching states depending on current character
      
  if((state == 'v' and end!='e' and hasSyllable)):           #Special case for when the word ends in 'e'                         
    count+=1;
  elif(state=='v' and (not hasSyllable)):             #Special case for when the word ends in 'e' but has no other syllables
    count+=1;
  return count;
####################################

#################################### 
def isVowel(i):
  i=i.lower()
  if(i=='a'or i=='e' or i=='i' or i=='o' or i=='u' or i=='y'):
    return True;
  return False;
####################################

#################################### 
def isSentence(i):
  if(i=='.' or i==':' or i==';' or i=='!' or i=='?'):
    return True;
  return False;
####################################

#################################### 
def isWord(word):
  i=0
  
  for i in word:                  #Iterates through word, if the word has at least one letter then it is considered a word. 
    if(i.isalpha()):
      return True
      
  return False
####################################

#################################### 
def isDifficultWord(dalechall, word):
  word=word.lower()
  return(not(word in dalechall))        #Returning the negation of the value, i.e. a word is a difficult word if it is NOT in the Dale-Chall list
#################################### 

####################################   
def buildHashSet():
  dalechall = set()
  with open("/pub/pounds/CSC330/dalechall/wordlist1995.txt") as inFile:
    for line in inFile:
      line=line.rstrip('\n')
      dalechall.add(line)
  return dalechall
#################################### 
def checkWord(word):
  if(word[0]=='['):
    word = word[1:]
  if(word[-1]==']' or word[-1]==',' or isSentence(word[-1])):
    word = word[:-1]
  return word
#################################### 
if __name__=='__main__':
  main(sys.argv[1:])