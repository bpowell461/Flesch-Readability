#!/usr/bin/perl
use strict;
use warnings;

package flesch;
sub new {
  my $class = shift;
  my $self = {
    syllableCount=>shift,
    wordCount=>shift,
    sentenceCount=> shift,
    diffWordCount=>shift,
    };
    bless $self, $class;
    return $self;
}

sub buildFleschObject {
 my @dalechall = buildHashSet(); #Building Hash Set
 #print "@dalechall"; 
 my $fleschIndex = new flesch(0,0,0,0); #Flesch Object
 
 my $filename = $_[0] or die "Need to get file name on the  command line\n";
 
 ## Use the filename 
 open(DATA, "<$filename") or die "Couldn't open file $filename, $!"; 
 
 ##the next line puts all the lines from the text file into an array called @all_lines
 my @all_lines = <DATA>; 
 
 ##Now take each line and break it into tokens based on spaces and print the token
 foreach my $line (@all_lines) {
    my @words = split(' ', $line);
       foreach my $word (@words) {
         #print "$word\n";
            if(isWord($word))
            {
              foreach my $char (split //, $word) #Splitting word into characters
              {
                if(isSentence($char))
                {
                  $fleschIndex->{sentenceCount}++;
                }
              }
              $word = checkWord($word);
              #print "Word to be checked: $word\n"; #Word being passed into the parameter
              if(isDifficultWord(\@dalechall, $word)) #Bug occurs here
              {
                $fleschIndex->{diffWordCount}++;
              }
              #print "Word to be checked: $word\n";
              $fleschIndex->{wordCount}++;
              $fleschIndex->{syllableCount}+=countSyllables($word);
              
            }
       }
 }
 return $fleschIndex;
}


sub countSyllables {
  my $count = 0;
  my $hasSyllable = 0; #boolean to check if word has syllables
  my $state = "c"; #state of state machine
  
  my $word = $_[0];
  my $end = substr($word, -1); #end of word character
                                
                                #Simple state machine inspired by a Stack Overflow answer: https://stackoverflow.com/a/52649782
  foreach my $char (split //, $word) #Splitting word into characters
  {
    if($state eq "v") #Check the state of the machine for vowel 
    {
      if(not(isVowel($char)))  #Checks for 2 consecutive vowels
      {
        $hasSyllable = 1;
        $count++;
      }
    }
    $state = isVowel($char)?"v":"c"; #Switching state of the machine
  }
  if(($state eq "v") and (not ($end eq "e")) and ($hasSyllable))#Special case for when the word ends in 'e' but has no other syllables
  {
    $count++;
  }
  elsif(($state eq "v") and (not($hasSyllable))) #Special case for when the word has no syllables
  {
    $count++;
  }
  return ($count);
}

sub isVowel {
  my $char = $_[0];
  $char = lc($char);
  my @vowels = ("a","e","i","o","u","y");
  my %hashmap = map {$_ => 1 } @vowels;
  return (exists($hashmap{$char}));
}

sub isSentence {
  my $char = $_[0];
  ##print "$char";
  my @punctuations = (".",":",";","!","?");
  my %hashmap = map {$_ => 1 } @punctuations;
  return (exists($hashmap{$char}));
}

sub isWord {
  my $word = $_[0];
  $word = lc($word);
  foreach my $char (split //, $word) #Splitting word into characters
  {
  if($char =~ /^[a-z]+$/i) #Super cool regex checker for alphabet
  {
    return 1;
  } 
  }
  
  return 0;
}

sub isDifficultWord  #MAJOR BUG
{
  my $dalechallRef= $_[0];
  my @dalechall = @$dalechallRef;
  #print(@dalechall);
  my $word = $_[1];
  $word = lc($word);
  #print("$word\n");
  #print("Checking for difficult word: $word\n"); #BUG OCCURS HERE ~ WORD GETS ASSIGNED ABLE
  #my %hashmap = map {$_ => 1 } @dalechall;
   return(not(grep { $_ eq $word} @dalechall)); 
}

sub buildHashSet()
{
  my @dalechall;
  my $filename = "/pub/pounds/CSC330/dalechall/wordlist1995.txt";
  open(DATA, "<$filename") or die "Couldn't open file $filename, $!"; 
  my @all_lines = <DATA>; 
  foreach my $line (@all_lines) {
    my @words = split(' ', $line);
       foreach my $word (@words) {
           #print "Added: $word\n";
           push(@dalechall, $word);
       }
  }
  return @dalechall;
}
sub checkWord
{
  my $word = $_[0];
  my $begin = substr($word, 0, 1);
  my $end = substr($word, -1);
  
  if($begin eq "[") #trimming down words to "natural forms ie. [is] = is ; loved, = loved ; etc.
  {
    $word = substr($word, 1);
  }
  if($end eq "]" or $end eq "," or isSentence($end))
  {
    $word = substr($word, 0, -1);
  }
  return $word;
}

  my $fleschIndex=buildFleschObject($ARGV[0]);
  my $a = ($fleschIndex->{syllableCount})/($fleschIndex->{wordCount});   #
  my $b = ($fleschIndex->{wordCount})/($fleschIndex->{sentenceCount});  #Variables used for respective equations
  my $aD = ($fleschIndex->{diffWordCount})/($fleschIndex->{wordCount}); #
  print("Difficult Word: $fleschIndex->{diffWordCount}\n");
  
  my $readIndex = 206.835-($a*84.6)-($b*1.015);        #Flesch-Readability Index Variable
  my $gradeIndex = ($a*11.8)+($b*0.39)-15.59;          #Flesch Grade Level Index
  my $dalePercent = ($aD * 100);                      #Dale-Chall Percentage
  
  my $daleIndex =($dalePercent*0.1579)+($b*0.0496);    #Dale-Chall Raw Score
  if($dalePercent > 5)
  {
    $daleIndex += 3.6365;
  }
  $readIndex = sprintf("%.0f", $readIndex);
  $gradeIndex = sprintf("%.1f", $gradeIndex); #Rounding the numbers
  $daleIndex = sprintf("%.1f", $daleIndex);
  print "Sentence Count: $fleschIndex->{sentenceCount}\n";
  print "Word Count: $fleschIndex->{wordCount}\n";
  print("Syllable Count: $fleschIndex->{syllableCount}\n");
  print("\nReadability and Grade Index\n");
  print("-----------------------------------\n");
  print("Flesch Readability Level: $readIndex\n");
  print("Flesch Grade Level Index: $gradeIndex\n");
  print("Dale-Chall Readability Level: $daleIndex\n");