import java.io.IOException; 
import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.*; 


public class flesch
{
  int syllableCount=0;  //
  int wordCount=0;      //Creating a flesch-kincaid object
  int sentenceCount=0;  //
  int diffWordCount=0;
   
   
   
  static flesch countWords(String args)
  {
    HashSet<String> dalechall = buildHashSet();
    flesch index = new flesch();
    try{
    File file = new File(args);
    Scanner reader = new Scanner(file);
    while(reader.hasNext())
    {
      String word = reader.next();
      if(isWord(word))  //Checks first letter of word to see if it is a number or word
      {
      
        if(isDifficultWord(dalechall, word))
          index.diffWordCount++;
        
        index.wordCount++;
        index.syllableCount += countSyllables(word); 
        for(char i: word.toCharArray())
        {
          if(isSentence(i))
            index.sentenceCount++;
        }
      }
	  }
	  reader.close();
  } 
  catch (FileNotFoundException e)
  { 
    System.out.println("No File Found");
    e.printStackTrace();
  }
  return index;
}



  static int countSyllables(String word)
  { 
    int count = 0;
    boolean hasSyllable=false;              //boolean to check if word has syllables
    char state = 'c';
  
    char end = word.charAt(word.length()-1);

   //cout<<endl;
   //cout<<"Word: "<<word<<endl;
    if(isSentence(end))
    {
      word = word.substring(0, word.length() - 1);
    }
    for (char i : word.toCharArray())                  //This is a state diagram inspired by a Stack Overflow Answer: 
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
    if((state == 'v' && end!='e' && hasSyllable))//Increases syllable count for words that have other syllables 
    {                                                          //and does not end in 'e'. Example: "bible","apple","trade"
      count++;
    }
    else if(state=='v' && !hasSyllable)
    {
      count++;
    }
    return count;
  }



  static boolean isVowel(char i)
  {
    Set<Character> vowels = new HashSet<>();
    vowels.add('a');
    vowels.add('e');
    vowels.add('i');
    vowels.add('o');
    vowels.add('u');
    vowels.add('y');
    boolean found = vowels.contains(i);
    return (found);
  }
  
  
  static boolean isSentence(char i)
  {
    Set<Character> punctuation = new HashSet<>();
    punctuation.add('.');
    punctuation.add(':');
    punctuation.add(';');
    punctuation.add('!');
    punctuation.add('?');
    boolean found = punctuation.contains(i);
    return (found);
  }
  
  
  static boolean isWord(String word)
  {
    for(char i : word.toCharArray())
    {
      if(Character.isLetter(i))
        return true;
    }
    return false;
  }
  
  
  static HashSet<String> buildHashSet(){
    HashSet<String> dalechall = new HashSet<>();
    try{
    File file = new File("/pub/pounds/CSC330/dalechall/wordlist1995.txt");
    Scanner reader = new Scanner(file);
    while(reader.hasNext())
    {
      String difficultWord = reader.next();
      dalechall.add(difficultWord);
	  }
	  reader.close();
  } 
  catch (FileNotFoundException e)
  { 
    System.out.println("No File Found");
    e.printStackTrace();
  }
  
  return dalechall;
  }
  
  
  static boolean isDifficultWord(HashSet<String> dalechall, String word)
  {
    return(!dalechall.contains(word));
    
  }
  static double round(double value, int precision) 
  {
    int scale = (int) Math.pow(10, precision);
    return (double) Math.round(value * scale) / scale;
  }
  
  public static void main(String[] args)
  {
    flesch index = countWords(args[0]);
    double a = ((double)index.syllableCount)/((double)index.wordCount);
    double b = ((double)index.wordCount)/((double)index.sentenceCount);
    double aD = ((double)index.diffWordCount)/((double)index.wordCount);
    double readIndex = 206.835-(a*84.6)-(b*1.015);
    double gradeIndex = (a*11.8)+(b*0.39)-15.59;
    double dalePercent = (aD * 100);
   
   
    double daleIndex =(dalePercent*0.1579)+(b*0.0496);
    if(dalePercent > 5)
      daleIndex += 3.6365;
      
      
    gradeIndex = round(gradeIndex, 1);
    daleIndex = round(daleIndex, 1);
    System.out.println("Sentence Count: "+index.sentenceCount);
    System.out.println("Word Count: "+index.wordCount);
    System.out.println("Syllable Count: "+index.syllableCount);
    System.out.println("\nReadability and Grade Index");
    System.out.println("-----------------------------------");
    System.out.println("Flesch Readability Level: "+(int)readIndex);
    System.out.println("Flesch Grade Level Index: "+gradeIndex);
    System.out.println("Dale-Chall Readability Level: "+daleIndex);
  }
}