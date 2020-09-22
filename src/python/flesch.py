#!/usr/bin/python3
import sys

#################################### 
class flesch:
  def __init__(self):
    self.syllableCount=0
    self.wordCount=0
    self.sentenceCount=0
    self.diffWordCount=0
#################################### 

####################################     
def main(argv):
  index=countWords(sys.argv[0])
  a = (index.syllableCount)/(index.wordCount)
  b = (index.wordCount)/(index.sentenceCount)
  aD = (index.diffWordCount)/(index.wordCount)
  readIndex = 206.835-(a*84.6)-(b*1.015)
  gradeIndex = (a*11.8)+(b*0.39)-15.59
  dalePercent = (aD * 100)
  
  daleIndex =(dalePercent*0.1579)+(b*0.0496)
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
def countWords(args):
  dalechall=buildHashSet()
  index=flesch();
  with open(sys.argv[1], 'r') as inFile:
    for line in inFile:
      for word in line.split():
        if(isWord(word)):
          if(isDifficultWord(dalechall,word)):
            index.diffWordCount+=1
          index.wordCount+=1
          index.syllableCount+=countSyllables(word)
          i=0
          for i in word:
            if(isSentence(i)):
              index.sentenceCount+=1
  return index
####################################       

####################################
def countSyllables(word):
  count = 0
  hasSyllable=False              #boolean to check if word has syllables
  state = 'c'
 
  end = word[-1:]
  
  if(isSentence(end)):
  
    word = word[:-1]
    
  for i in word:
    
    if(state=='v'):
      
      if(not isVowel(i)):
        hasSyllable=True
        count+=1
          
    state='v' if isVowel(i) else 'c' 
      
  if((state == 'v' and end!='e' and hasSyllable)):                                        
    count+=1;
  elif(state=='v' and (not hasSyllable)):
    count+=1;
  return count;
####################################

#################################### 
def isVowel(i):
  vowels=set(['a','e','i','o','u','y'])
  return (i in vowels)
####################################

#################################### 
def isSentence(i):
  punctuation=set(['.',':',';','!','?'])
  return(i in punctuation)
####################################

#################################### 
def isWord(word):
  i=0
  
  for i in word:
    if(i.isalpha()):
      return True
      
  return False
####################################

#################################### 
def isDifficultWord(dalechall, word):
  return(not(word in dalechall))
#################################### 

####################################   
def buildHashSet():
  dalechall = set();
  with open("/pub/pounds/CSC330/dalechall/wordlist1995.txt") as inFile:
    for line in inFile:
      dalechall.add(line)
  return dalechall
#################################### 

if __name__=='__main__':
  main(sys.argv[1:])