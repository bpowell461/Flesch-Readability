#include <iostream>
#include <fstream>
#include <sstream>
#include <ctype.h>
#include <set>
#include <string>
#include <unordered_set>
#include <iomanip>
#include<bits/stdc++.h>

using namespace std;
struct flesch
{
  int syllableCount=0;  //
  int wordCount=0;      //Creating a flesch-kincaid object
  int sentenceCount=0;  //
  int diffWordCount=0;  //
};
void countWords(char* args, flesch* index);
int countSyllables(string word);
bool isVowel(char i);
bool isSentence(char i);
bool isWord(string word);
void buildUnorderedSet(unordered_set<string>* dalechall);
bool isDifficultWord(unordered_set<string>* dalechall, string word);
string checkWord(string word);

int main(int argc, char* argv[])
{
  flesch* index = new flesch{0,0,0,0};
  countWords(argv[1], index);
  cout<<"Sentence Count: "<<index->sentenceCount<<endl;
  cout<<"Word Count: "<<index->wordCount<<endl;
  cout<<"Syllable Count: "<<index->syllableCount<<endl;
  cout<<"Difficult Word Count: "<<index->diffWordCount<<endl;
  
  double a = ((double)index->syllableCount)/((double)index->wordCount);
  double b = ((double)index->wordCount)/((double)index->sentenceCount);
  double aD = ((double)index->diffWordCount)/((double)index->wordCount);
  
  delete index;
  
  double readIndex = 206.835-(a*84.6)-(b*1.015);
  double gradeIndex = (a*11.8)+(b*0.39)-15.59;
  double dalePercent = (aD * 100);
  double daleIndex =(dalePercent*0.1579)+(b*0.0496);
  
  if(dalePercent > 5)
    daleIndex += 3.6365;
  cout<<""<<endl;
  cout<<"Readability and Grade Index"<<endl;
  cout<<"-----------------------------------"<<endl;
  cout<<"Flesch Readability Index: "<<(int)readIndex<<endl;
  cout.precision(1);
  cout<<"Flesch Grade Level Index: "<<fixed<<setprecision(1)<<gradeIndex<<endl;
  cout<<"Dale-Chall Readability Level: "<<fixed<<setprecision(1)<<daleIndex<<endl; 
  return 0;
} 

void countWords(char* args, flesch* index)
{
  ifstream file(args);
	string word;
	unordered_set<string>* dalechall= new unordered_set<string>;
  
  buildUnorderedSet(dalechall);
 
	while(file>>word)
	{
    if(isWord(word))  //Checks first letter of word to see if it is a number or word
    {
      for(auto i: word)
      {
        if(isSentence(i))
          index->sentenceCount++;
      }
      word = checkWord(word);
      if(isDifficultWord(dalechall, word))
          index->diffWordCount++;
          
		  index->wordCount+=1;
      index->syllableCount += countSyllables(word); 
    }
	}
  delete dalechall;
	file.close();
}

int countSyllables(string word)
{ 
  int count = 0;
  bool hasSyllable=false;              //boolean to check if word has syllables
  char state = 'c';
  char end = word[(word.length()-1)];
  

  for (auto i : word)                  //This is a state diagram inspired by a Stack Overflow Answer: 
  {
   //cout<<i<<endl;
                                       //https://stackoverflow.com/a/52649782
    switch(state)                      //
    {                                  //The switch statement acts as a state machine.
      case 'c':                        //
      {                                //Each case acts as a state, switching between a state 'c' for cosonant and 
        break;                         //'v' for vowel.
      }                                //
      case 'v':                        //
      {                                //
        if(!isVowel(i))                //Checking here for consecutive vowels
        {
          //cout<<"syllable++"<<endl;
          hasSyllable=true;            //custom boolean for cases where 'e' is the last letter but has no other syllables
          count++;                     //
        }                              //
        break;                         //
      }                                //
    }                                  //
    state = isVowel(i)?'v':'c';        //ternary operator, switching states depending on vowel or cosonant
  }
  if((state == 'v' && end!='e' && hasSyllable)) //Increases syllable count for words that have other syllables and
  {                                                     //does not end in 'e'. Example: "bible","apple","trade"
    count++;
  }
  else if(state=='v' && !hasSyllable)
  {
    count++;
  }
  /*if(state=='v')
    count++;*/
  return count;
}

bool isVowel(char i)
{
  i=tolower(i);
  if(i=='a'||i=='e'||i=='i'||i=='o'||i=='u'||i=='y')
  {
    return true;
  }
  return false;
}
bool isSentence(char i)
{
  if(i=='.'||i==':'||i==';'||i=='!'||i=='?')
  {
    return true;
  }
  return false;
}
bool isWord(string word)
{
  for(auto i : word)
  {
    if(isalpha(i))
      return true;
  }
  return false;
}
void buildUnorderedSet(unordered_set<string>* dalechall)
{
 ifstream file("/pub/pounds/CSC330/dalechall/wordlist1995.txt");
 string difficultWord;
 
 while(file>>difficultWord)
 {
   dalechall->insert(difficultWord);
 }

}
bool isDifficultWord(unordered_set<string>* dalechall, string word)
{
  transform(word.begin(), word.end(), word.begin(), ::tolower);
  bool found = dalechall->find(word)!=dalechall->end();
  return(!found);
}
string checkWord(string word)
{
  if(word[0]=='[')
  {
    word = word.substr(1, word.length());
  }
  if(word[(word.length()-1)]==']' || word[(word.length()-1)]==',' || isSentence(word[(word.length()-1)]))
  {
    word = word.substr(0, word.length()-1);
  }
  return word;

}